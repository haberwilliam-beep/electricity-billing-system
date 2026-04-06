package com.electricity.util;

import lombok.AllArgsConstructor;
import lombok.Data;
import java.math.BigDecimal;

/**
 * Simple pair holding previous and current meter readings.
 */
@Data
@AllArgsConstructor
public class MeterReadingPair {
    private BigDecimal prevReading;
    private BigDecimal currReading;
}
