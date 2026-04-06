package com.electricity.service;

import com.electricity.model.Parameter;
import java.math.BigDecimal;
import java.util.List;

public interface ParameterService {
    Parameter findByKey(String key);
    BigDecimal getDecimalValue(String key);
    List<Parameter> findAll();
    void saveParameter(Parameter parameter);
}
