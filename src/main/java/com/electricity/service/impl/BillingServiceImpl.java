package com.electricity.service.impl;

import com.electricity.dto.BillingResult;
import com.electricity.dto.GridResponse;
import com.electricity.mapper.BillMapper;
import com.electricity.mapper.CustomerMapper;
import com.electricity.mapper.IssuanceMapper;
import com.electricity.model.Bill;
import com.electricity.model.Customer;
import com.electricity.model.Issuance;
import com.electricity.service.BillingService;
import com.electricity.service.ParameterService;
import com.electricity.util.MeterReadingPair;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.math.BigDecimal;
import java.math.RoundingMode;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;

@Service
@RequiredArgsConstructor
public class BillingServiceImpl implements BillingService {

    private final BillMapper billMapper;
    private final CustomerMapper customerMapper;
    private final IssuanceMapper issuanceMapper;
    private final ParameterService parameterService;

    @Override
    public BillingResult runTrial(Long issuanceId, Map<Long, MeterReadingPair> meterReadings) {
        return compute(issuanceId, meterReadings, true);
    }

    @Override
    @Transactional
    public BillingResult runFinal(Long issuanceId, Map<Long, MeterReadingPair> meterReadings) {
        // Delete any previous trial bills for this issuance
        billMapper.deleteTrialByIssuance(issuanceId);
        BillingResult result = compute(issuanceId, meterReadings, false);

        // Persist the bills
        List<Bill> toSave = new ArrayList<>();
        for (BillingResult.BillRow row : result.getBills()) {
            Bill b = mapRowToBill(row, issuanceId, result.getExchangeRate(), false);
            toSave.add(b);
        }
        if (!toSave.isEmpty()) {
            billMapper.insertBatch(toSave);
        }
        // Finalize issuance
        issuanceMapper.updateStatus(issuanceId, "FINAL");
        return result;
    }

    @Override
    public List<Bill> getBillsByIssuance(Long issuanceId, boolean isTrial) {
        return billMapper.findByIssuanceId(issuanceId, isTrial);
    }

    @Override
    public Object getPagedBills(int page, int rows, Long issuanceId) {
        int offset = (page - 1) * rows;
        long total = billMapper.countAll(issuanceId);
        List<Bill> list = billMapper.findAllPaged(offset, rows, issuanceId);
        return new GridResponse<>(page, rows, total, list);
    }

    private BillingResult compute(Long issuanceId,
                                   Map<Long, MeterReadingPair> meterReadings,
                                   boolean isTrial) {
        Issuance issuance = issuanceMapper.findById(issuanceId);
        if (issuance == null) throw new IllegalArgumentException("Issuance not found: " + issuanceId);

        BigDecimal pricePerKwh      = parameterService.getDecimalValue("PRICE_PER_KWH");
        BigDecimal pricePerAmper    = parameterService.getDecimalValue("PRICE_PER_AMPER");
        BigDecimal subFeePerAmper   = parameterService.getDecimalValue("SUBSCRIPTION_FEE_PER_AMPER");
        BigDecimal exchangeRate     = issuance.getExchangeRate();

        List<Customer> customers = customerMapper.findAll();

        BillingResult result = new BillingResult();
        result.setIssuanceId(issuanceId);
        result.setExchangeRate(exchangeRate);
        result.setTrial(isTrial);

        List<BillingResult.BillRow> rows = new ArrayList<>();
        BigDecimal grandTotalUsd = BigDecimal.ZERO;
        BigDecimal grandTotalLbp = BigDecimal.ZERO;

        for (Customer c : customers) {
            if (!Boolean.TRUE.equals(c.getActive())) continue;

            BillingResult.BillRow row = new BillingResult.BillRow();
            row.setCustomerId(c.getId());
            row.setCustomerName(c.getName());
            row.setZoneName(c.getZoneName());
            row.setBoxName(c.getBoxName());
            row.setBillingType(c.getBillingType());

            BigDecimal totalUsd;

            if ("METER".equals(c.getBillingType())) {
                MeterReadingPair readings = meterReadings != null ? meterReadings.get(c.getId()) : null;
                BigDecimal prev = readings != null ? readings.getPrevReading() : BigDecimal.ZERO;
                BigDecimal curr = readings != null ? readings.getCurrReading() : BigDecimal.ZERO;
                BigDecimal consumption = curr.subtract(prev).max(BigDecimal.ZERO);

                row.setPrevReading(prev);
                row.setCurrReading(curr);
                row.setConsumption(consumption);
                row.setPricePerKwh(pricePerKwh);

                // sub fee for meter = subFeePerAmper * amperCapacity (if set)
                BigDecimal amper = c.getAmperCapacity() != null ? c.getAmperCapacity() : BigDecimal.ZERO;
                BigDecimal subFee = subFeePerAmper.multiply(amper).setScale(2, RoundingMode.HALF_UP);
                row.setSubFee(subFee);

                BigDecimal consumptionCost = consumption.multiply(pricePerKwh).setScale(2, RoundingMode.HALF_UP);
                totalUsd = consumptionCost.add(subFee);
            } else {
                // AMPER based
                BigDecimal amper = c.getAmperCapacity() != null ? c.getAmperCapacity() : BigDecimal.ZERO;
                row.setAmperCapacity(amper);
                row.setPricePerAmper(pricePerAmper);

                BigDecimal amperCost = amper.multiply(pricePerAmper).setScale(2, RoundingMode.HALF_UP);
                BigDecimal subFee    = subFeePerAmper.multiply(amper).setScale(2, RoundingMode.HALF_UP);
                row.setSubFee(subFee);
                totalUsd = amperCost.add(subFee);
            }

            row.setTotalUsd(totalUsd);
            BigDecimal totalLbp = totalUsd.multiply(exchangeRate).setScale(0, RoundingMode.HALF_UP);
            row.setTotalLbp(totalLbp);

            grandTotalUsd = grandTotalUsd.add(totalUsd);
            grandTotalLbp = grandTotalLbp.add(totalLbp);
            rows.add(row);
        }

        result.setBills(rows);
        result.setGrandTotalUsd(grandTotalUsd);
        result.setGrandTotalLbp(grandTotalLbp);
        return result;
    }

    private Bill mapRowToBill(BillingResult.BillRow row, Long issuanceId,
                               BigDecimal exchangeRate, boolean isTrial) {
        Bill b = new Bill();
        b.setIssuanceId(issuanceId);
        b.setCustomerId(row.getCustomerId());
        b.setBillingType(row.getBillingType());
        b.setPrevReading(row.getPrevReading());
        b.setCurrReading(row.getCurrReading());
        b.setConsumption(row.getConsumption());
        b.setPricePerKwh(row.getPricePerKwh());
        b.setAmperCapacity(row.getAmperCapacity());
        b.setPricePerAmper(row.getPricePerAmper());
        b.setSubFee(row.getSubFee());
        b.setTotalUsd(row.getTotalUsd());
        b.setTotalLbp(row.getTotalLbp());
        b.setExchangeRate(exchangeRate);
        b.setIsTrial(isTrial);
        return b;
    }
}
