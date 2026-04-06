package com.electricity.mapper;

import com.electricity.model.Bill;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;
import java.util.List;

@Mapper
public interface BillMapper {
    Bill findById(Long id);
    List<Bill> findByIssuanceId(@Param("issuanceId") Long issuanceId,
                                @Param("isTrial") boolean isTrial);
    List<Bill> findAllPaged(@Param("offset") int offset, @Param("limit") int limit,
                            @Param("issuanceId") Long issuanceId);
    long countAll(@Param("issuanceId") Long issuanceId);
    int insertBatch(@Param("bills") List<Bill> bills);
    int insert(Bill bill);
    int deleteTrialByIssuance(Long issuanceId);
    int deleteByIssuance(Long issuanceId);
}
