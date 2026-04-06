package com.electricity.service;

import com.electricity.dao.BillDao;
import com.electricity.model.Bill;
import com.electricity.model.Client;
import com.electricity.model.MeterReading;
import com.electricity.util.BillingCalculator;
import com.electricity.util.CurrencyConverter;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.math.BigDecimal;
import java.util.List;

@Service
@Transactional
public class BillingService {

    private final BillDao billDao;
    private final ClientService clientService;
    private final MeterReadingService meterReadingService;
    private final ParameterService parameterService;

    @Autowired
    public BillingService(BillDao billDao,
                          ClientService clientService,
                          MeterReadingService meterReadingService,
                          ParameterService parameterService) {
        this.billDao = billDao;
        this.clientService = clientService;
        this.meterReadingService = meterReadingService;
        this.parameterService = parameterService;
    }

    public Bill findById(Long id) {
        return billDao.findById(id);
    }

    public List<Bill> findAll() {
        return billDao.findAll();
    }

    public List<Bill> findByClientId(Long clientId) {
        return billDao.findByClientId(clientId);
    }

    public List<Bill> findByMonthAndYear(int billingMonth, int billingYear) {
        return billDao.findByMonthAndYear(billingMonth, billingYear);
    }

    /**
     * Generates a bill for a meter-based client.
     *
     * @param clientId     client ID
     * @param meterReadingId meter reading ID
     * @param billingMonth billing month
     * @param billingYear  billing year
     * @return generated Bill
     */
    public Bill generateMeterBasedBill(Long clientId, Long meterReadingId, int billingMonth, int billingYear) {
        Client client = clientService.findById(clientId);
        MeterReading reading = meterReadingService.findById(meterReadingId);

        BigDecimal pricePerKwh = parameterService.getPricePerKwh();
        BigDecimal subscriptionFeePerAmpere = parameterService.getSubscriptionFeePerAmpere();
        BigDecimal exchangeRate = parameterService.getExchangeRate();

        BigDecimal consumption = reading.getEndReading().subtract(reading.getStartReading());
        BigDecimal consumptionCharge = BillingCalculator.calculateConsumptionCharge(consumption, pricePerKwh);
        BigDecimal subscriptionFee = BillingCalculator.calculateSubscriptionFee(client.getAmpereCapacity(), subscriptionFeePerAmpere);
        BigDecimal totalUsd = consumptionCharge.add(subscriptionFee);
        BigDecimal totalLbp = CurrencyConverter.usdToLbp(totalUsd, exchangeRate);

        Bill bill = new Bill();
        bill.setClientId(clientId);
        bill.setMeterReadingId(meterReadingId);
        bill.setBillingMonth(billingMonth);
        bill.setBillingYear(billingYear);
        bill.setConsumption(consumption);
        bill.setPricePerKwh(pricePerKwh);
        bill.setSubscriptionFeePerAmpere(subscriptionFeePerAmpere);
        bill.setAmpereCapacity(client.getAmpereCapacity());
        bill.setConsumptionChargeUsd(consumptionCharge);
        bill.setSubscriptionFeeUsd(subscriptionFee);
        bill.setTotalAmountUsd(totalUsd);
        bill.setTotalAmountLbp(totalLbp);
        bill.setExchangeRate(exchangeRate);
        bill.setStatus(Bill.BillStatus.PENDING);

        billDao.insert(bill);
        return bill;
    }

    /**
     * Generates a bill for an amper-based client.
     *
     * @param clientId     client ID
     * @param billingMonth billing month
     * @param billingYear  billing year
     * @return generated Bill
     */
    public Bill generateAmperBasedBill(Long clientId, int billingMonth, int billingYear) {
        Client client = clientService.findById(clientId);

        BigDecimal pricePerAmpere = parameterService.getPricePerAmpere();
        BigDecimal subscriptionFeePerAmpere = parameterService.getSubscriptionFeePerAmpere();
        BigDecimal exchangeRate = parameterService.getExchangeRate();

        BigDecimal ampereCharge = BillingCalculator.calculateAmpereCharge(client.getAmpereCapacity(), pricePerAmpere);
        BigDecimal subscriptionFee = BillingCalculator.calculateSubscriptionFee(client.getAmpereCapacity(), subscriptionFeePerAmpere);
        BigDecimal totalUsd = ampereCharge.add(subscriptionFee);
        BigDecimal totalLbp = CurrencyConverter.usdToLbp(totalUsd, exchangeRate);

        Bill bill = new Bill();
        bill.setClientId(clientId);
        bill.setBillingMonth(billingMonth);
        bill.setBillingYear(billingYear);
        bill.setPricePerAmpere(pricePerAmpere);
        bill.setSubscriptionFeePerAmpere(subscriptionFeePerAmpere);
        bill.setAmpereCapacity(client.getAmpereCapacity());
        bill.setConsumptionChargeUsd(ampereCharge);
        bill.setSubscriptionFeeUsd(subscriptionFee);
        bill.setTotalAmountUsd(totalUsd);
        bill.setTotalAmountLbp(totalLbp);
        bill.setExchangeRate(exchangeRate);
        bill.setStatus(Bill.BillStatus.PENDING);

        billDao.insert(bill);
        return bill;
    }

    public void updateBill(Bill bill) {
        billDao.update(bill);
    }

    public void deleteBill(Long id) {
        billDao.deleteById(id);
    }

    public void updateStatus(Long id, String status) {
        billDao.updateStatus(id, status);
    }
}
