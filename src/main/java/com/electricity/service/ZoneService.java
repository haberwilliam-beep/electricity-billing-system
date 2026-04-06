package com.electricity.service;

import com.electricity.model.Zone;
import java.util.List;

public interface ZoneService {
    Zone findById(Long id);
    List<Zone> findAll();
    List<Zone> findAllActive();
    Object getPagedZones(int page, int rows, String search);
    void createZone(Zone zone);
    void updateZone(Zone zone);
    void deleteZone(Long id);
}
