package com.electricity.service;

import com.electricity.model.Customer;
import java.util.List;

public interface CustomerService {
    Customer findById(Long id);
    List<Customer> findAll();
    Object getPagedCustomers(int page, int rows, String search, String billingType, Long zoneId);
    void createCustomer(Customer customer);
    void updateCustomer(Customer customer);
    void deleteCustomer(Long id);
}
