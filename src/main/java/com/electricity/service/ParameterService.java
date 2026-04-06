package com.electricity.service;

import com.electricity.dao.ParameterDao;
import com.electricity.model.Parameter;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.math.BigDecimal;
import java.util.List;

@Service
@Transactional
public class ParameterService {

    private final ParameterDao parameterDao;

    @Autowired
    public ParameterService(ParameterDao parameterDao) {
        this.parameterDao = parameterDao;
    }

    public Parameter findByKey(String key) {
        return parameterDao.findByKey(key);
    }

    public List<Parameter> findAll() {
        return parameterDao.findAll();
    }

    public BigDecimal getPricePerKwh() {
        Parameter p = parameterDao.findByKey(Parameter.PRICE_PER_KWH);
        return p != null ? p.getValueAsBigDecimal() : BigDecimal.ZERO;
    }

    public BigDecimal getPricePerAmpere() {
        Parameter p = parameterDao.findByKey(Parameter.PRICE_PER_AMPERE);
        return p != null ? p.getValueAsBigDecimal() : BigDecimal.ZERO;
    }

    public BigDecimal getSubscriptionFeePerAmpere() {
        Parameter p = parameterDao.findByKey(Parameter.SUBSCRIPTION_FEE_PER_AMPERE);
        return p != null ? p.getValueAsBigDecimal() : BigDecimal.ZERO;
    }

    public BigDecimal getExchangeRate() {
        Parameter p = parameterDao.findByKey(Parameter.EXCHANGE_RATE_USD_TO_LBP);
        return p != null ? p.getValueAsBigDecimal() : BigDecimal.ONE;
    }

    public void saveParameter(Parameter parameter) {
        parameterDao.upsert(parameter);
    }

    public void updateParameter(Parameter parameter) {
        parameterDao.update(parameter);
    }

    public void deleteParameter(Long id) {
        parameterDao.deleteById(id);
    }
}
