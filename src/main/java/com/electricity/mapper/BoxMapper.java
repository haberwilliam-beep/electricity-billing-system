package com.electricity.mapper;

import com.electricity.model.Box;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;
import java.util.List;

@Mapper
public interface BoxMapper {
    Box findById(Long id);
    List<Box> findAll();
    List<Box> findByZoneId(Long zoneId);
    List<Box> findAllActive();
    List<Box> findAllPaged(@Param("offset") int offset, @Param("limit") int limit,
                           @Param("search") String search,
                           @Param("zoneId") Long zoneId);
    long countAll(@Param("search") String search, @Param("zoneId") Long zoneId);
    int insert(Box box);
    int update(Box box);
    int deleteById(Long id);
}
