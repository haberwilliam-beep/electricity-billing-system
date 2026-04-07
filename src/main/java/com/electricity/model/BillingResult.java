package com.electricity.model;

import java.math.BigDecimal;
import java.util.List;

/**
 * Aggregated result of a billing run for one issuance period.
 */
public class BillingResult {

    private Long issuanceId;
    private boolean trial;
    private BigDecimal grandTotalUsd;
    private BigDecimal grandTotalLbp;
    private BigDecimal exchangeRate;
    private List<BillRow> bills;

    public BillingResult() {}

    public Long getIssuanceId() { return issuanceId; }
    public void setIssuanceId(Long issuanceId) { this.issuanceId = issuanceId; }

    public boolean isTrial() { return trial; }
    public void setTrial(boolean trial) { this.trial = trial; }

    public BigDecimal getGrandTotalUsd() { return grandTotalUsd; }
    public void setGrandTotalUsd(BigDecimal grandTotalUsd) { this.grandTotalUsd = grandTotalUsd; }

    public BigDecimal getGrandTotalLbp() { return grandTotalLbp; }
    public void setGrandTotalLbp(BigDecimal grandTotalLbp) { this.grandTotalLbp = grandTotalLbp; }

    public BigDecimal getExchangeRate() { return exchangeRate; }
    public void setExchangeRate(BigDecimal exchangeRate) { this.exchangeRate = exchangeRate; }

    public List<BillRow> getBills() { return bills; }
    public void setBills(List<BillRow> bills) { this.bills = bills; }

    /**
     * Represents a single customer's bill line within a {@link BillingResult}.
     */
    public static class BillRow {

        private Long customerId;
        private BigDecimal prevReading;
        private BigDecimal currReading;
        private BigDecimal consumption;
        private BigDecimal amperCapacity;
        private BigDecimal pricePerKwh;
        private BigDecimal pricePerAmper;
        private BigDecimal subFee;
        private BigDecimal totalUsd;
        private BigDecimal totalLbp;

        public BillRow() {}

        public Long getCustomerId() { return customerId; }
        public void setCustomerId(Long customerId) { this.customerId = customerId; }

        public BigDecimal getPrevReading() { return prevReading; }
        public void setPrevReading(BigDecimal prevReading) { this.prevReading = prevReading; }

        public BigDecimal getCurrReading() { return currReading; }
        public void setCurrReading(BigDecimal currReading) { this.currReading = currReading; }

        public BigDecimal getConsumption() { return consumption; }
        public void setConsumption(BigDecimal consumption) { this.consumption = consumption; }

        public BigDecimal getAmperCapacity() { return amperCapacity; }
        public void setAmperCapacity(BigDecimal amperCapacity) { this.amperCapacity = amperCapacity; }

        public BigDecimal getPricePerKwh() { return pricePerKwh; }
        public void setPricePerKwh(BigDecimal pricePerKwh) { this.pricePerKwh = pricePerKwh; }

        public BigDecimal getPricePerAmper() { return pricePerAmper; }
        public void setPricePerAmper(BigDecimal pricePerAmper) { this.pricePerAmper = pricePerAmper; }

        public BigDecimal getSubFee() { return subFee; }
        public void setSubFee(BigDecimal subFee) { this.subFee = subFee; }

        public BigDecimal getTotalUsd() { return totalUsd; }
        public void setTotalUsd(BigDecimal totalUsd) { this.totalUsd = totalUsd; }

        public BigDecimal getTotalLbp() { return totalLbp; }
        public void setTotalLbp(BigDecimal totalLbp) { this.totalLbp = totalLbp; }
    }
}
