package com.electricity.mapper;

import com.electricity.model.Customer;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;
import java.util.List;

@Mapper
public interface CustomerMapper {
    Customer findById(Long id);
    List<Customer> findAll();
    List<Customer> findByBoxId(Long boxId);
    List<Customer> findAllPaged(@Param("offset") int offset, @Param("limit") int limit,
                                @Param("search") String search,
                                @Param("billingType") String billingType,
                                @Param("zoneId") Long zoneId);
    long countAll(@Param("search") String search,
                  @Param("billingType") String billingType,
                  @Param("zoneId") Long zoneId);
    List<Customer> findByIssuanceForBilling(@Param("issuanceId") Long issuanceId);
    int insert(Customer customer);
    int update(Customer customer);
    int deleteById(Long id);
}
