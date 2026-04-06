package com.electricity.service.impl;

import com.electricity.dto.GridResponse;
import com.electricity.mapper.CustomerMapper;
import com.electricity.model.Customer;
import com.electricity.service.CustomerService;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;

@Service
@RequiredArgsConstructor
public class CustomerServiceImpl implements CustomerService {

    private final CustomerMapper customerMapper;

    @Override
    public Customer findById(Long id) { return customerMapper.findById(id); }

    @Override
    public List<Customer> findAll() { return customerMapper.findAll(); }

    @Override
    public Object getPagedCustomers(int page, int rows, String search,
                                     String billingType, Long zoneId) {
        int offset = (page - 1) * rows;
        long total = customerMapper.countAll(search, billingType, zoneId);
        List<Customer> list = customerMapper.findAllPaged(offset, rows, search, billingType, zoneId);
        return new GridResponse<>(page, rows, total, list);
    }

    @Override
    @Transactional
    public void createCustomer(Customer customer) {
        if (customer.getActive() == null) customer.setActive(true);
        customerMapper.insert(customer);
    }

    @Override
    @Transactional
    public void updateCustomer(Customer customer) { customerMapper.update(customer); }

    @Override
    @Transactional
    public void deleteCustomer(Long id) { customerMapper.deleteById(id); }
}
