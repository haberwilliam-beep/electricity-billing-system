package com.electricity.dao;

import com.electricity.model.MeterReading;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import java.util.List;

@Mapper
public interface MeterReadingDao {

    MeterReading findById(Long id);

    List<MeterReading> findAll();

    List<MeterReading> findByClientId(@Param("clientId") Long clientId);

    List<MeterReading> findByMonthAndYear(@Param("billingMonth") int billingMonth,
                                          @Param("billingYear") int billingYear);

    MeterReading findByClientAndPeriod(@Param("clientId") Long clientId,
                                       @Param("billingMonth") int billingMonth,
                                       @Param("billingYear") int billingYear);

    int insert(MeterReading meterReading);

    int update(MeterReading meterReading);

    int deleteById(Long id);
}
