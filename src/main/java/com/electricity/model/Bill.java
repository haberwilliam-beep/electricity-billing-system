package com.electricity.model;

import java.math.BigDecimal;
import java.time.LocalDateTime;

public class Bill {

    public enum BillStatus {
        PENDING, INVOICED, PAID, CANCELLED
    }

    private Long id;
    private Long clientId;
    private String clientName;
    private Long meterReadingId;
    private Long issuanceId;
    private Integer billingMonth;
    private Integer billingYear;
    private boolean isTrial;
    private String zoneName;
    private BigDecimal prevReading;
    private BigDecimal currReading;
    private BigDecimal consumption;
    private BigDecimal pricePerKwh;
    private BigDecimal pricePerAmpere;
    private BigDecimal subscriptionFeePerAmpere;
    private Integer ampereCapacity;
    private BigDecimal consumptionChargeUsd;
    private BigDecimal subscriptionFeeUsd;
    private BigDecimal totalAmountUsd;
    private BigDecimal totalAmountLbp;
    private BigDecimal exchangeRate;
    private BillStatus status;
    private LocalDateTime createdAt;
    private LocalDateTime updatedAt;

    public Bill() {}

    public Long getId() { return id; }
    public void setId(Long id) { this.id = id; }

    public Long getClientId() { return clientId; }
    public void setClientId(Long clientId) { this.clientId = clientId; }
    /** Alias for {@link #getClientId()} */
    public Long getCustomerId() { return clientId; }

    public String getClientName() { return clientName; }
    public void setClientName(String clientName) { this.clientName = clientName; }
    /** Alias for {@link #getClientName()} */
    public String getCustomerName() { return clientName; }

    public Long getMeterReadingId() { return meterReadingId; }
    public void setMeterReadingId(Long meterReadingId) { this.meterReadingId = meterReadingId; }

    public Long getIssuanceId() { return issuanceId; }
    public void setIssuanceId(Long issuanceId) { this.issuanceId = issuanceId; }

    public Integer getBillingMonth() { return billingMonth; }
    public void setBillingMonth(Integer billingMonth) { this.billingMonth = billingMonth; }

    public Integer getBillingYear() { return billingYear; }
    public void setBillingYear(Integer billingYear) { this.billingYear = billingYear; }

    public boolean isIsTrial() { return isTrial; }
    public boolean getIsTrial() { return isTrial; }
    public void setIsTrial(boolean isTrial) { this.isTrial = isTrial; }

    public String getZoneName() { return zoneName; }
    public void setZoneName(String zoneName) { this.zoneName = zoneName; }

    public BigDecimal getPrevReading() { return prevReading; }
    public void setPrevReading(BigDecimal prevReading) { this.prevReading = prevReading; }

    public BigDecimal getCurrReading() { return currReading; }
    public void setCurrReading(BigDecimal currReading) { this.currReading = currReading; }

    public BigDecimal getConsumption() { return consumption; }
    public void setConsumption(BigDecimal consumption) { this.consumption = consumption; }

    public BigDecimal getPricePerKwh() { return pricePerKwh; }
    public void setPricePerKwh(BigDecimal pricePerKwh) { this.pricePerKwh = pricePerKwh; }

    public BigDecimal getPricePerAmpere() { return pricePerAmpere; }
    public void setPricePerAmpere(BigDecimal pricePerAmpere) { this.pricePerAmpere = pricePerAmpere; }
    /** Alias for {@link #getPricePerAmpere()} */
    public BigDecimal getPricePerAmper() { return pricePerAmpere; }
    /** Alias for {@link #setPricePerAmpere(BigDecimal)} */
    public void setPricePerAmper(BigDecimal pricePerAmpere) { this.pricePerAmpere = pricePerAmpere; }

    public BigDecimal getSubscriptionFeePerAmpere() { return subscriptionFeePerAmpere; }
    public void setSubscriptionFeePerAmpere(BigDecimal subscriptionFeePerAmpere) { this.subscriptionFeePerAmpere = subscriptionFeePerAmpere; }

    public Integer getAmpereCapacity() { return ampereCapacity; }
    public void setAmpereCapacity(Integer ampereCapacity) { this.ampereCapacity = ampereCapacity; }

    public BigDecimal getConsumptionChargeUsd() { return consumptionChargeUsd; }
    public void setConsumptionChargeUsd(BigDecimal consumptionChargeUsd) { this.consumptionChargeUsd = consumptionChargeUsd; }

    public BigDecimal getSubscriptionFeeUsd() { return subscriptionFeeUsd; }
    public void setSubscriptionFeeUsd(BigDecimal subscriptionFeeUsd) { this.subscriptionFeeUsd = subscriptionFeeUsd; }
    /** Alias for {@link #getSubscriptionFeeUsd()} */
    public BigDecimal getSubFee() { return subscriptionFeeUsd; }
    /** Alias for {@link #setSubscriptionFeeUsd(BigDecimal)} */
    public void setSubFee(BigDecimal subscriptionFeeUsd) { this.subscriptionFeeUsd = subscriptionFeeUsd; }

    public BigDecimal getTotalAmountUsd() { return totalAmountUsd; }
    public void setTotalAmountUsd(BigDecimal totalAmountUsd) { this.totalAmountUsd = totalAmountUsd; }
    /** Alias for {@link #getTotalAmountUsd()} */
    public BigDecimal getTotalUsd() { return totalAmountUsd; }
    /** Alias for {@link #setTotalAmountUsd(BigDecimal)} */
    public void setTotalUsd(BigDecimal totalAmountUsd) { this.totalAmountUsd = totalAmountUsd; }

    public BigDecimal getTotalAmountLbp() { return totalAmountLbp; }
    public void setTotalAmountLbp(BigDecimal totalAmountLbp) { this.totalAmountLbp = totalAmountLbp; }
    /** Alias for {@link #getTotalAmountLbp()} */
    public BigDecimal getTotalLbp() { return totalAmountLbp; }
    /** Alias for {@link #setTotalAmountLbp(BigDecimal)} */
    public void setTotalLbp(BigDecimal totalAmountLbp) { this.totalAmountLbp = totalAmountLbp; }

    public BigDecimal getExchangeRate() { return exchangeRate; }
    public void setExchangeRate(BigDecimal exchangeRate) { this.exchangeRate = exchangeRate; }

    public BillStatus getStatus() { return status; }
    public void setStatus(BillStatus status) { this.status = status; }

    public LocalDateTime getCreatedAt() { return createdAt; }
    public void setCreatedAt(LocalDateTime createdAt) { this.createdAt = createdAt; }

    public LocalDateTime getUpdatedAt() { return updatedAt; }
    public void setUpdatedAt(LocalDateTime updatedAt) { this.updatedAt = updatedAt; }
}
