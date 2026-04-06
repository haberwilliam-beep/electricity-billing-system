package com.electricity.service.impl;

import com.electricity.mapper.ParameterMapper;
import com.electricity.model.Parameter;
import com.electricity.service.ParameterService;
import lombok.RequiredArgsConstructor;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.math.BigDecimal;
import java.util.List;

@Service
@RequiredArgsConstructor
public class ParameterServiceImpl implements ParameterService {

    private final ParameterMapper parameterMapper;

    @Override
    public Parameter findByKey(String key) {
        return parameterMapper.findByKey(key);
    }

    @Override
    public BigDecimal getDecimalValue(String key) {
        Parameter p = parameterMapper.findByKey(key);
        if (p == null) return BigDecimal.ZERO;
        try {
            return new BigDecimal(p.getParamValue());
        } catch (NumberFormatException e) {
            return BigDecimal.ZERO;
        }
    }

    @Override
    public List<Parameter> findAll() {
        return parameterMapper.findAll();
    }

    @Override
    @Transactional
    public void saveParameter(Parameter parameter) {
        parameterMapper.upsert(parameter);
    }
}
