package com.electricity.model;

/**
 * Alias for {@link Invoice}.
 * <p>
 * The primary class in this application is {@code Invoice}. This alias exists
 * so that code written against the name {@code Issuance} still compiles.
 * Prefer using {@link Invoice} directly in new code.
 * </p>
 */
public class Issuance extends Invoice {

    public Issuance() {
        super();
    }

    /**
     * String-based overload of {@link Invoice#setStatus(Invoice.InvoiceStatus)}.
     * Converts the supplied string to the matching {@link Invoice.InvoiceStatus} constant
     * (case-insensitive) so that code passing plain strings compiles without casting.
     *
     * @param status the status name (e.g. "ISSUED", "PAID", "OVERDUE", "CANCELLED")
     * @throws IllegalArgumentException if the value does not match any known status
     */
    public void setStatus(String status) {
        super.setStatus(Invoice.InvoiceStatus.valueOf(status.toUpperCase()));
    }
}
