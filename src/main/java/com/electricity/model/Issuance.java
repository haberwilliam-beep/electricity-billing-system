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
}
