package com.electricity.mapper;

import com.electricity.model.Role;
import org.apache.ibatis.annotations.Mapper;
import java.util.List;

@Mapper
public interface RoleMapper {
    List<Role> findAll();
    Role findById(Long id);
    Role findByName(String name);
}
