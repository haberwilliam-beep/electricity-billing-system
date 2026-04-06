package com.electricity.service;

import com.electricity.model.Issuance;
import java.util.List;

public interface IssuanceService {
    Issuance findById(Long id);
    List<Issuance> findAll();
    Object getPagedIssuances(int page, int rows);
    void createIssuance(Issuance issuance);
    void updateIssuance(Issuance issuance);
    void deleteIssuance(Long id);
    void finalize(Long id);
}
