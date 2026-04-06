package com.electricity.service;

import com.electricity.model.User;
import java.util.List;

public interface UserService {
    User findById(Long id);
    User findByUsername(String username);
    List<User> findAll();
    Object getPagedUsers(int page, int rows, String search);
    void createUser(User user);
    void updateUser(User user);
    void deleteUser(Long id);
}
