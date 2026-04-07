package com.electricity.util;

import java.math.BigDecimal;
import java.math.RoundingMode;

public class CurrencyConverter {

    private CurrencyConverter() {}

    /**
     * Converts a USD amount to Lebanese Lira (LBP).
     *
     * @param amountUsd    amount in USD
     * @param exchangeRate USD to LBP exchange rate
     * @return equivalent amount in LBP, rounded to 2 decimal places
     */
    public static BigDecimal usdToLbp(BigDecimal amountUsd, BigDecimal exchangeRate) {
        if (amountUsd == null || exchangeRate == null) {
            return BigDecimal.ZERO;
        }
        return amountUsd.multiply(exchangeRate).setScale(2, RoundingMode.HALF_UP);
    }

    /**
     * Converts an LBP amount to USD.
     *
     * @param amountLbp    amount in LBP
     * @param exchangeRate USD to LBP exchange rate
     * @return equivalent amount in USD, rounded to 2 decimal places
     */
    public static BigDecimal lbpToUsd(BigDecimal amountLbp, BigDecimal exchangeRate) {
        if (amountLbp == null || exchangeRate == null || exchangeRate.compareTo(BigDecimal.ZERO) == 0) {
            return BigDecimal.ZERO;
        }
        return amountLbp.divide(exchangeRate, 2, RoundingMode.HALF_UP);
    }
}
