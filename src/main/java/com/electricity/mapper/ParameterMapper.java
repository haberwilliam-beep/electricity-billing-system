package com.electricity.mapper;

import com.electricity.model.Parameter;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;
import java.util.List;

@Mapper
public interface ParameterMapper {
    Parameter findByKey(String paramKey);
    List<Parameter> findAll();
    int insert(Parameter parameter);
    int update(Parameter parameter);
    int upsert(Parameter parameter);
}
