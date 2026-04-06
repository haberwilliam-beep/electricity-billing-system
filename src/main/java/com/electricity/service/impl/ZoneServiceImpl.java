package com.electricity.service.impl;

import com.electricity.dto.GridResponse;
import com.electricity.mapper.ZoneMapper;
import com.electricity.model.Zone;
import com.electricity.service.ZoneService;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;

@Service
@RequiredArgsConstructor
public class ZoneServiceImpl implements ZoneService {

    private final ZoneMapper zoneMapper;

    @Override
    public Zone findById(Long id) { return zoneMapper.findById(id); }

    @Override
    public List<Zone> findAll() { return zoneMapper.findAll(); }

    @Override
    public List<Zone> findAllActive() { return zoneMapper.findAllActive(); }

    @Override
    public Object getPagedZones(int page, int rows, String search) {
        int offset = (page - 1) * rows;
        long total = zoneMapper.countAll(search);
        List<Zone> list = zoneMapper.findAllPaged(offset, rows, search);
        return new GridResponse<>(page, rows, total, list);
    }

    @Override
    @Transactional
    public void createZone(Zone zone) {
        if (zone.getActive() == null) zone.setActive(true);
        zoneMapper.insert(zone);
    }

    @Override
    @Transactional
    public void updateZone(Zone zone) { zoneMapper.update(zone); }

    @Override
    @Transactional
    public void deleteZone(Long id) { zoneMapper.deleteById(id); }
}
