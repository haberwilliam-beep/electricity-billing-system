package com.electricity.mapper;

import com.electricity.model.Translation;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;
import java.util.List;
import java.util.Map;

@Mapper
public interface TranslationMapper {
    Translation findByKey(String msgKey);
    List<Translation> findAll();
    List<Translation> findAllPaged(@Param("offset") int offset, @Param("limit") int limit,
                                   @Param("search") String search);
    long countAll(@Param("search") String search);
    Map<String, String> findAllAsMap(@Param("lang") String lang);
    int insert(Translation translation);
    int update(Translation translation);
    int upsert(Translation translation);
    int deleteById(Long id);
}
