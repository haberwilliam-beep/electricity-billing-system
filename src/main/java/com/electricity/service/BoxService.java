package com.electricity.service;

import com.electricity.model.Box;
import java.util.List;

public interface BoxService {
    Box findById(Long id);
    List<Box> findAll();
    List<Box> findAllActive();
    List<Box> findByZoneId(Long zoneId);
    Object getPagedBoxes(int page, int rows, String search, Long zoneId);
    void createBox(Box box);
    void updateBox(Box box);
    void deleteBox(Long id);
}
