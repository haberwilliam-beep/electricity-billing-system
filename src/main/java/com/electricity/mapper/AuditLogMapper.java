package com.electricity.mapper;

import com.electricity.model.AuditLog;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;
import java.util.List;

@Mapper
public interface AuditLogMapper {
    int insert(AuditLog log);
    List<AuditLog> findAllPaged(@Param("offset") int offset, @Param("limit") int limit,
                                @Param("search") String search);
    long countAll(@Param("search") String search);
}
