package com.electricity.model;

import java.math.BigDecimal;
import java.time.LocalDateTime;

public class Parameter {

    private Long id;
    private String paramKey;
    private String paramValue;
    private String description;
    private LocalDateTime createdAt;
    private LocalDateTime updatedAt;

    // Well-known parameter keys
    public static final String PRICE_PER_KWH = "PRICE_PER_KWH";
    public static final String PRICE_PER_AMPERE = "PRICE_PER_AMPERE";
    public static final String SUBSCRIPTION_FEE_PER_AMPERE = "SUBSCRIPTION_FEE_PER_AMPERE";
    public static final String EXCHANGE_RATE_USD_TO_LBP = "EXCHANGE_RATE_USD_TO_LBP";

    public Parameter() {}

    public Parameter(String paramKey, String paramValue, String description) {
        this.paramKey = paramKey;
        this.paramValue = paramValue;
        this.description = description;
    }

    public Long getId() { return id; }
    public void setId(Long id) { this.id = id; }

    public String getParamKey() { return paramKey; }
    public void setParamKey(String paramKey) { this.paramKey = paramKey; }

    public String getParamValue() { return paramValue; }
    public void setParamValue(String paramValue) { this.paramValue = paramValue; }

    public String getDescription() { return description; }
    public void setDescription(String description) { this.description = description; }

    public LocalDateTime getCreatedAt() { return createdAt; }
    public void setCreatedAt(LocalDateTime createdAt) { this.createdAt = createdAt; }

    public LocalDateTime getUpdatedAt() { return updatedAt; }
    public void setUpdatedAt(LocalDateTime updatedAt) { this.updatedAt = updatedAt; }

    public BigDecimal getValueAsBigDecimal() {
        return new BigDecimal(this.paramValue);
    }
}
