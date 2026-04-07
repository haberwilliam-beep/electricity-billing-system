package com.electricity.dao;

import com.electricity.model.User;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import java.util.List;

@Mapper
public interface UserDao {

    User findById(Long id);

    User findByUsername(String username);

    List<User> findAll();

    int insert(User user);

    int update(User user);

    int deleteById(Long id);

    int countByUsername(@Param("username") String username);
}
