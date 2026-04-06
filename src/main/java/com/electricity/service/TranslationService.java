package com.electricity.service;

import com.electricity.model.Translation;
import java.util.List;
import java.util.Map;

public interface TranslationService {
    Translation findByKey(String key);
    List<Translation> findAll();
    Object getPagedTranslations(int page, int rows, String search);
    Map<String, String> getAllAsMap(String lang);
    void save(Translation translation);
    void delete(Long id);
}
