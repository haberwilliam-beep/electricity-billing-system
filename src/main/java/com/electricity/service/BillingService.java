package com.electricity.service;

import com.electricity.dto.BillingResult;
import com.electricity.model.Bill;
import com.electricity.util.MeterReadingPair;
import java.util.List;
import java.util.Map;

public interface BillingService {
    /**
     * Perform a trial billing run (not saved permanently).
     */
    BillingResult runTrial(Long issuanceId, Map<Long, MeterReadingPair> meterReadings);

    /**
     * Perform the final billing run and save permanently.
     */
    BillingResult runFinal(Long issuanceId, Map<Long, MeterReadingPair> meterReadings);

    List<Bill> getBillsByIssuance(Long issuanceId, boolean isTrial);

    Object getPagedBills(int page, int rows, Long issuanceId);
}
