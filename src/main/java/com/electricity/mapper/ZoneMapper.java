package com.electricity.mapper;

import com.electricity.model.Zone;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;
import java.util.List;

@Mapper
public interface ZoneMapper {
    Zone findById(Long id);
    List<Zone> findAll();
    List<Zone> findAllActive();
    List<Zone> findAllPaged(@Param("offset") int offset, @Param("limit") int limit,
                            @Param("search") String search);
    long countAll(@Param("search") String search);
    int insert(Zone zone);
    int update(Zone zone);
    int deleteById(Long id);
}
