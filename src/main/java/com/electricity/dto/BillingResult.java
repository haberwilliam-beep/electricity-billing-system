package com.electricity.dto;

import lombok.Data;
import java.math.BigDecimal;
import java.util.List;

/**
 * DTO for trial/final billing results displayed before saving.
 */
@Data
public class BillingResult {
    private Long issuanceId;
    private String billingMonth;
    private BigDecimal exchangeRate;
    private List<BillRow> bills;
    private BigDecimal grandTotalUsd;
    private BigDecimal grandTotalLbp;
    private boolean trial;

    @Data
    public static class BillRow {
        private Long customerId;
        private String customerName;
        private String zoneName;
        private String boxName;
        private String billingType;
        // Meter
        private BigDecimal prevReading;
        private BigDecimal currReading;
        private BigDecimal consumption;
        private BigDecimal pricePerKwh;
        // Amper
        private BigDecimal amperCapacity;
        private BigDecimal pricePerAmper;
        // Common
        private BigDecimal subFee;
        private BigDecimal totalUsd;
        private BigDecimal totalLbp;
    }
}
