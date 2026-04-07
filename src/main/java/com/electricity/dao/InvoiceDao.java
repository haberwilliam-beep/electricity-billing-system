package com.electricity.dao;

import com.electricity.model.Invoice;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import java.util.List;

@Mapper
public interface InvoiceDao {

    Invoice findById(Long id);

    Invoice findByInvoiceNumber(String invoiceNumber);

    List<Invoice> findAll();

    List<Invoice> findByClientId(@Param("clientId") Long clientId);

    List<Invoice> findByMonthAndYear(@Param("billingMonth") int billingMonth,
                                     @Param("billingYear") int billingYear);

    int insert(Invoice invoice);

    int update(Invoice invoice);

    int deleteById(Long id);

    int updateStatus(@Param("id") Long id, @Param("status") String status);

    long countAll();
}
