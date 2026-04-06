package com.electricity.model;

import lombok.Data;
import java.math.BigDecimal;
import java.time.LocalDate;
import java.time.LocalDateTime;

@Data
public class Issuance {
    private Long id;
    private LocalDate issuanceDate;
    private LocalDate billingMonth;
    private BigDecimal exchangeRate;
    private String status; // DRAFT or FINAL
    private String notes;
    private Long createdBy;
    private LocalDateTime createdAt;
    private LocalDateTime updatedAt;

    // join
    private String createdByUsername;
}
