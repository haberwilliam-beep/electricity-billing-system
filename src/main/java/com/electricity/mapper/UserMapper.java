package com.electricity.mapper;

import com.electricity.model.User;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;
import java.util.List;

@Mapper
public interface UserMapper {
    User findById(Long id);
    User findByUsername(String username);
    List<User> findAll();
    List<User> findAllPaged(@Param("offset") int offset, @Param("limit") int limit,
                            @Param("search") String search);
    long countAll(@Param("search") String search);
    int insert(User user);
    int update(User user);
    int deleteById(Long id);
}
