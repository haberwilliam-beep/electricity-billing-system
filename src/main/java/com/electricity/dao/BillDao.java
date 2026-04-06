package com.electricity.dao;

import com.electricity.model.Bill;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import java.util.List;

@Mapper
public interface BillDao {

    Bill findById(Long id);

    List<Bill> findAll();

    List<Bill> findByClientId(@Param("clientId") Long clientId);

    List<Bill> findByMonthAndYear(@Param("billingMonth") int billingMonth,
                                  @Param("billingYear") int billingYear);

    Bill findByClientAndPeriod(@Param("clientId") Long clientId,
                               @Param("billingMonth") int billingMonth,
                               @Param("billingYear") int billingYear);

    int insert(Bill bill);

    int update(Bill bill);

    int deleteById(Long id);

    int updateStatus(@Param("id") Long id, @Param("status") String status);
}
