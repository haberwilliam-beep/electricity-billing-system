package com.electricity.mapper;

import com.electricity.model.Issuance;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;
import java.util.List;

@Mapper
public interface IssuanceMapper {
    Issuance findById(Long id);
    Issuance findByBillingMonth(String billingMonth);
    List<Issuance> findAll();
    List<Issuance> findAllPaged(@Param("offset") int offset, @Param("limit") int limit);
    long countAll();
    int insert(Issuance issuance);
    int update(Issuance issuance);
    int updateStatus(@Param("id") Long id, @Param("status") String status);
    int deleteById(Long id);
}
