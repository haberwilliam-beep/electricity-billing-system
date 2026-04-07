package com.electricity.dao;

import com.electricity.model.Parameter;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import java.util.List;

@Mapper
public interface ParameterDao {

    Parameter findById(Long id);

    Parameter findByKey(@Param("paramKey") String paramKey);

    List<Parameter> findAll();

    int insert(Parameter parameter);

    int update(Parameter parameter);

    int upsert(Parameter parameter);

    int deleteById(Long id);
}
