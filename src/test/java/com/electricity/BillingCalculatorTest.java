package com.electricity;

import com.electricity.util.BillingCalculator;
import com.electricity.util.CurrencyConverter;
import org.junit.jupiter.api.Test;

import java.math.BigDecimal;

import static org.junit.jupiter.api.Assertions.*;

class BillingCalculatorTest {

    @Test
    void testConsumptionCharge() {
        BigDecimal consumption = new BigDecimal("185");
        BigDecimal pricePerKwh = new BigDecimal("0.15");
        BigDecimal result = BillingCalculator.calculateConsumptionCharge(consumption, pricePerKwh);
        assertEquals(new BigDecimal("27.75"), result);
    }

    @Test
    void testAmpereCharge() {
        BigDecimal pricePerAmpere = new BigDecimal("20.00");
        BigDecimal result = BillingCalculator.calculateAmpereCharge(5, pricePerAmpere);
        assertEquals(new BigDecimal("100.00"), result);
    }

    @Test
    void testSubscriptionFee() {
        BigDecimal subscriptionFeePerAmpere = new BigDecimal("5.00");
        BigDecimal result = BillingCalculator.calculateSubscriptionFee(10, subscriptionFeePerAmpere);
        assertEquals(new BigDecimal("50.00"), result);
    }

    @Test
    void testMeterBasedBill() {
        BigDecimal consumption = new BigDecimal("185");
        BigDecimal pricePerKwh = new BigDecimal("0.15");
        BigDecimal subscriptionFeePerAmpere = new BigDecimal("5.00");
        int ampereCapacity = 5;

        BigDecimal result = BillingCalculator.calculateMeterBasedBill(
                consumption, pricePerKwh, ampereCapacity, subscriptionFeePerAmpere);

        // (185 * 0.15) + (5 * 5) = 27.75 + 25 = 52.75
        assertEquals(new BigDecimal("52.75"), result);
    }

    @Test
    void testAmperBasedBill() {
        BigDecimal pricePerAmpere = new BigDecimal("20.00");
        BigDecimal subscriptionFeePerAmpere = new BigDecimal("5.00");
        int ampereCapacity = 10;

        BigDecimal result = BillingCalculator.calculateAmperBasedBill(
                ampereCapacity, pricePerAmpere, subscriptionFeePerAmpere);

        // (10 * 20) + (10 * 5) = 200 + 50 = 250
        assertEquals(new BigDecimal("250.00"), result);
    }

    @Test
    void testCurrencyConversionUsdToLbp() {
        BigDecimal amountUsd = new BigDecimal("52.75");
        BigDecimal exchangeRate = new BigDecimal("89500");
        BigDecimal result = CurrencyConverter.usdToLbp(amountUsd, exchangeRate);
        assertEquals(new BigDecimal("4721125.00"), result);
    }

    @Test
    void testCurrencyConversionLbpToUsd() {
        BigDecimal amountLbp = new BigDecimal("4721125.00");
        BigDecimal exchangeRate = new BigDecimal("89500");
        BigDecimal result = CurrencyConverter.lbpToUsd(amountLbp, exchangeRate);
        assertEquals(new BigDecimal("52.75"), result);
    }

    @Test
    void testNullInputsReturnZero() {
        assertEquals(BigDecimal.ZERO, BillingCalculator.calculateConsumptionCharge(null, new BigDecimal("0.15")));
        assertEquals(BigDecimal.ZERO, BillingCalculator.calculateConsumptionCharge(new BigDecimal("100"), null));
        assertEquals(BigDecimal.ZERO, CurrencyConverter.usdToLbp(null, new BigDecimal("89500")));
        assertEquals(BigDecimal.ZERO, CurrencyConverter.lbpToUsd(null, new BigDecimal("89500")));
    }
}
