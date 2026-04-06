package com.electricity.service.impl;

import com.electricity.dto.GridResponse;
import com.electricity.mapper.IssuanceMapper;
import com.electricity.model.Issuance;
import com.electricity.service.IssuanceService;
import lombok.RequiredArgsConstructor;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;

@Service
@RequiredArgsConstructor
public class IssuanceServiceImpl implements IssuanceService {

    private final IssuanceMapper issuanceMapper;

    @Override
    public Issuance findById(Long id) { return issuanceMapper.findById(id); }

    @Override
    public List<Issuance> findAll() { return issuanceMapper.findAll(); }

    @Override
    public Object getPagedIssuances(int page, int rows) {
        int offset = (page - 1) * rows;
        long total = issuanceMapper.countAll();
        List<Issuance> list = issuanceMapper.findAllPaged(offset, rows);
        return new GridResponse<>(page, rows, total, list);
    }

    @Override
    @Transactional
    public void createIssuance(Issuance issuance) {
        issuance.setStatus("DRAFT");
        issuanceMapper.insert(issuance);
    }

    @Override
    @Transactional
    public void updateIssuance(Issuance issuance) { issuanceMapper.update(issuance); }

    @Override
    @Transactional
    public void deleteIssuance(Long id) { issuanceMapper.deleteById(id); }

    @Override
    @Transactional
    public void finalize(Long id) {
        issuanceMapper.updateStatus(id, "FINAL");
    }
}
