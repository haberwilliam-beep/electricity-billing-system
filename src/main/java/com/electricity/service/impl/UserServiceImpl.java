package com.electricity.service.impl;

import com.electricity.dto.GridResponse;
import com.electricity.mapper.UserMapper;
import com.electricity.model.User;
import com.electricity.service.UserService;
import lombok.RequiredArgsConstructor;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;

@Service
@RequiredArgsConstructor
public class UserServiceImpl implements UserService {

    private final UserMapper userMapper;
    private final PasswordEncoder passwordEncoder;

    @Override
    public User findById(Long id) {
        return userMapper.findById(id);
    }

    @Override
    public User findByUsername(String username) {
        return userMapper.findByUsername(username);
    }

    @Override
    public List<User> findAll() {
        return userMapper.findAll();
    }

    @Override
    public Object getPagedUsers(int page, int rows, String search) {
        int offset = (page - 1) * rows;
        long total = userMapper.countAll(search);
        List<User> list = userMapper.findAllPaged(offset, rows, search);
        return new GridResponse<>(page, rows, total, list);
    }

    @Override
    @Transactional
    public void createUser(User user) {
        if (user.getPassword() != null && !user.getPassword().isEmpty()) {
            user.setPassword(passwordEncoder.encode(user.getPassword()));
        }
        if (user.getEnabled() == null) {
            user.setEnabled(true);
        }
        userMapper.insert(user);
    }

    @Override
    @Transactional
    public void updateUser(User user) {
        if (user.getPassword() != null && !user.getPassword().isEmpty()) {
            user.setPassword(passwordEncoder.encode(user.getPassword()));
        } else {
            user.setPassword(null);
        }
        userMapper.update(user);
    }

    @Override
    @Transactional
    public void deleteUser(Long id) {
        userMapper.deleteById(id);
    }
}
