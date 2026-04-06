package com.electricity.service.impl;

import com.electricity.dto.GridResponse;
import com.electricity.mapper.TranslationMapper;
import com.electricity.model.Translation;
import com.electricity.service.TranslationService;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;
import java.util.Map;

@Service
@RequiredArgsConstructor
public class TranslationServiceImpl implements TranslationService {

    private final TranslationMapper translationMapper;

    @Override
    public Translation findByKey(String key) { return translationMapper.findByKey(key); }

    @Override
    public List<Translation> findAll() { return translationMapper.findAll(); }

    @Override
    public Object getPagedTranslations(int page, int rows, String search) {
        int offset = (page - 1) * rows;
        long total = translationMapper.countAll(search);
        List<Translation> list = translationMapper.findAllPaged(offset, rows, search);
        return new GridResponse<>(page, rows, total, list);
    }

    @Override
    public Map<String, String> getAllAsMap(String lang) {
        return translationMapper.findAllAsMap(lang);
    }

    @Override
    @Transactional
    public void save(Translation translation) {
        translationMapper.upsert(translation);
    }

    @Override
    @Transactional
    public void delete(Long id) { translationMapper.deleteById(id); }
}
