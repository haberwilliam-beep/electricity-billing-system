package com.electricity.service.impl;

import com.electricity.dto.GridResponse;
import com.electricity.mapper.BoxMapper;
import com.electricity.model.Box;
import com.electricity.service.BoxService;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;

@Service
@RequiredArgsConstructor
public class BoxServiceImpl implements BoxService {

    private final BoxMapper boxMapper;

    @Override
    public Box findById(Long id) { return boxMapper.findById(id); }

    @Override
    public List<Box> findAll() { return boxMapper.findAll(); }

    @Override
    public List<Box> findAllActive() { return boxMapper.findAllActive(); }

    @Override
    public List<Box> findByZoneId(Long zoneId) { return boxMapper.findByZoneId(zoneId); }

    @Override
    public Object getPagedBoxes(int page, int rows, String search, Long zoneId) {
        int offset = (page - 1) * rows;
        long total = boxMapper.countAll(search, zoneId);
        List<Box> list = boxMapper.findAllPaged(offset, rows, search, zoneId);
        return new GridResponse<>(page, rows, total, list);
    }

    @Override
    @Transactional
    public void createBox(Box box) {
        if (box.getActive() == null) box.setActive(true);
        boxMapper.insert(box);
    }

    @Override
    @Transactional
    public void updateBox(Box box) { boxMapper.update(box); }

    @Override
    @Transactional
    public void deleteBox(Long id) { boxMapper.deleteById(id); }
}
