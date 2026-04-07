package com.electricity.model;

import java.math.BigDecimal;

/**
 * Holds a pair of consecutive meter readings used to calculate consumption.
 */
public class MeterReadingPair {

    private BigDecimal prevReading;
    private BigDecimal currReading;

    public MeterReadingPair() {}

    public MeterReadingPair(BigDecimal prevReading, BigDecimal currReading) {
        this.prevReading = prevReading;
        this.currReading = currReading;
    }

    public BigDecimal getPrevReading() { return prevReading; }
    public void setPrevReading(BigDecimal prevReading) { this.prevReading = prevReading; }

    public BigDecimal getCurrReading() { return currReading; }
    public void setCurrReading(BigDecimal currReading) { this.currReading = currReading; }

    public BigDecimal getConsumption() {
        if (currReading == null || prevReading == null) {
            return BigDecimal.ZERO;
        }
        return currReading.subtract(prevReading);
    }
}
