package com.electricity.model;

/**
 * Alias for {@link Client}.
 * <p>
 * The primary class in this application is {@code Client}. This alias exists
 * so that code written against the name {@code Customer} still compiles.
 * Prefer using {@link Client} directly in new code.
 * </p>
 */
public class Customer extends Client {

    public Customer() {
        super();
    }
}
