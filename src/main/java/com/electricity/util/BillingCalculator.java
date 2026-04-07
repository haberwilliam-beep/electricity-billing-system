package com.electricity.util;

import java.math.BigDecimal;
import java.math.RoundingMode;

/**
 * Utility class for electricity billing calculations.
 *
 * <p>Billing formulas:
 * <ul>
 *   <li>Meter-based: (endReading - startReading) * pricePerKwh
 *                  + subscriptionFeePerAmpere * ampereCapacity</li>
 *   <li>Amper-based: pricePerAmpere * ampereCapacity
 *                  + subscriptionFeePerAmpere * ampereCapacity</li>
 * </ul>
 */
public class BillingCalculator {

    private BillingCalculator() {}

    /**
     * Calculates the consumption charge for a meter-based client.
     *
     * @param consumption  kWh consumed (endReading - startReading)
     * @param pricePerKwh  price per kWh in USD
     * @return consumption charge in USD
     */
    public static BigDecimal calculateConsumptionCharge(BigDecimal consumption, BigDecimal pricePerKwh) {
        if (consumption == null || pricePerKwh == null) {
            return BigDecimal.ZERO;
        }
        return consumption.multiply(pricePerKwh).setScale(2, RoundingMode.HALF_UP);
    }

    /**
     * Calculates the ampere-based charge for an amper-based client.
     *
     * @param ampereCapacity   subscribed ampere capacity
     * @param pricePerAmpere   price per ampere per month in USD
     * @return ampere charge in USD
     */
    public static BigDecimal calculateAmpereCharge(int ampereCapacity, BigDecimal pricePerAmpere) {
        if (pricePerAmpere == null) {
            return BigDecimal.ZERO;
        }
        return pricePerAmpere.multiply(BigDecimal.valueOf(ampereCapacity)).setScale(2, RoundingMode.HALF_UP);
    }

    /**
     * Calculates the monthly subscription fee.
     *
     * @param ampereCapacity           subscribed ampere capacity
     * @param subscriptionFeePerAmpere monthly subscription fee per ampere in USD
     * @return total subscription fee in USD
     */
    public static BigDecimal calculateSubscriptionFee(int ampereCapacity, BigDecimal subscriptionFeePerAmpere) {
        if (subscriptionFeePerAmpere == null) {
            return BigDecimal.ZERO;
        }
        return subscriptionFeePerAmpere.multiply(BigDecimal.valueOf(ampereCapacity)).setScale(2, RoundingMode.HALF_UP);
    }

    /**
     * Calculates the total bill for a meter-based client.
     *
     * @param consumption              kWh consumed
     * @param pricePerKwh              price per kWh in USD
     * @param ampereCapacity           subscribed ampere capacity
     * @param subscriptionFeePerAmpere monthly subscription fee per ampere in USD
     * @return total bill in USD
     */
    public static BigDecimal calculateMeterBasedBill(BigDecimal consumption,
                                                      BigDecimal pricePerKwh,
                                                      int ampereCapacity,
                                                      BigDecimal subscriptionFeePerAmpere) {
        BigDecimal consumptionCharge = calculateConsumptionCharge(consumption, pricePerKwh);
        BigDecimal subscriptionFee = calculateSubscriptionFee(ampereCapacity, subscriptionFeePerAmpere);
        return consumptionCharge.add(subscriptionFee).setScale(2, RoundingMode.HALF_UP);
    }

    /**
     * Calculates the total bill for an amper-based client.
     *
     * @param ampereCapacity           subscribed ampere capacity
     * @param pricePerAmpere           price per ampere per month in USD
     * @param subscriptionFeePerAmpere monthly subscription fee per ampere in USD
     * @return total bill in USD
     */
    public static BigDecimal calculateAmperBasedBill(int ampereCapacity,
                                                      BigDecimal pricePerAmpere,
                                                      BigDecimal subscriptionFeePerAmpere) {
        BigDecimal ampereCharge = calculateAmpereCharge(ampereCapacity, pricePerAmpere);
        BigDecimal subscriptionFee = calculateSubscriptionFee(ampereCapacity, subscriptionFeePerAmpere);
        return ampereCharge.add(subscriptionFee).setScale(2, RoundingMode.HALF_UP);
    }
}
