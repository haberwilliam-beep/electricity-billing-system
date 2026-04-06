package com.electricity.service;

import com.electricity.dao.MeterReadingDao;
import com.electricity.model.MeterReading;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;

@Service
@Transactional
public class MeterReadingService {

    private final MeterReadingDao meterReadingDao;

    @Autowired
    public MeterReadingService(MeterReadingDao meterReadingDao) {
        this.meterReadingDao = meterReadingDao;
    }

    public MeterReading findById(Long id) {
        return meterReadingDao.findById(id);
    }

    public List<MeterReading> findAll() {
        return meterReadingDao.findAll();
    }

    public List<MeterReading> findByClientId(Long clientId) {
        return meterReadingDao.findByClientId(clientId);
    }

    public List<MeterReading> findByMonthAndYear(int billingMonth, int billingYear) {
        return meterReadingDao.findByMonthAndYear(billingMonth, billingYear);
    }

    public MeterReading findByClientAndPeriod(Long clientId, int billingMonth, int billingYear) {
        return meterReadingDao.findByClientAndPeriod(clientId, billingMonth, billingYear);
    }

    public void createReading(MeterReading reading) {
        meterReadingDao.insert(reading);
    }

    public void updateReading(MeterReading reading) {
        meterReadingDao.update(reading);
    }

    public void deleteReading(Long id) {
        meterReadingDao.deleteById(id);
    }
}
