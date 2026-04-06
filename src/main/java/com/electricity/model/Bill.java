package com.electricity.model;

import lombok.Data;
import java.math.BigDecimal;
import java.time.LocalDateTime;

@Data
public class Bill {
    private Long id;
    private Long issuanceId;
    private Long customerId;
    private String billingType; // METER or AMPER
    // Meter fields
    private BigDecimal prevReading;
    private BigDecimal currReading;
    private BigDecimal consumption;
    private BigDecimal pricePerKwh;
    // Amper fields
    private BigDecimal amperCapacity;
    private BigDecimal pricePerAmper;
    // Common
    private BigDecimal subFee;
    private BigDecimal totalUsd;
    private BigDecimal totalLbp;
    private BigDecimal exchangeRate;
    private Boolean isTrial;
    private LocalDateTime createdAt;

    // joins
    private String customerName;
    private String boxName;
    private String zoneName;
    private String billingMonthStr;
}
