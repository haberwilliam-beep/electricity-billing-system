package com.electricity.controller;

import com.electricity.dto.ApiResponse;
import com.electricity.mapper.RoleMapper;
import com.electricity.model.User;
import com.electricity.service.AuditLogService;
import com.electricity.service.UserService;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

import javax.servlet.http.HttpServletRequest;

@Controller
@RequestMapping("/users")
@RequiredArgsConstructor
@PreAuthorize("hasRole('ADMIN')")
public class UserController {

    private final UserService userService;
    private final RoleMapper roleMapper;
    private final AuditLogService auditLogService;

    @GetMapping
    public String list(Model model) {
        model.addAttribute("roles", roleMapper.findAll());
        return "user/list";
    }

    @GetMapping("/data")
    @ResponseBody
    public Object getData(@RequestParam(defaultValue="1") int page,
                          @RequestParam(defaultValue="10") int rows,
                          @RequestParam(defaultValue="") String search) {
        return userService.getPagedUsers(page, rows, search);
    }

    @GetMapping("/{id}")
    @ResponseBody
    public User getById(@PathVariable Long id) {
        return userService.findById(id);
    }

    @PostMapping
    @ResponseBody
    public ResponseEntity<ApiResponse> create(@RequestBody User user,
                                               HttpServletRequest request) {
        userService.createUser(user);
        auditLogService.log("CREATE", "User", user.getId(), "Created user: " + user.getUsername(), request);
        return ResponseEntity.ok(ApiResponse.ok("User created successfully"));
    }

    @PutMapping("/{id}")
    @ResponseBody
    public ResponseEntity<ApiResponse> update(@PathVariable Long id,
                                               @RequestBody User user,
                                               HttpServletRequest request) {
        user.setId(id);
        userService.updateUser(user);
        auditLogService.log("UPDATE", "User", id, "Updated user: " + user.getUsername(), request);
        return ResponseEntity.ok(ApiResponse.ok("User updated successfully"));
    }

    @DeleteMapping("/{id}")
    @ResponseBody
    public ResponseEntity<ApiResponse> delete(@PathVariable Long id,
                                               HttpServletRequest request) {
        User u = userService.findById(id);
        userService.deleteUser(id);
        auditLogService.log("DELETE", "User", id,
                "Deleted user: " + (u != null ? u.getUsername() : id), request);
        return ResponseEntity.ok(ApiResponse.ok("User deleted successfully"));
    }
}
