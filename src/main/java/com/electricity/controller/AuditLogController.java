package com.electricity.controller;

import com.electricity.service.AuditLogService;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.*;

@Controller
@RequestMapping("/audit")
@RequiredArgsConstructor
public class AuditLogController {

    private final AuditLogService auditLogService;

    @GetMapping
    public String list() {
        return "audit/list";
    }

    @GetMapping("/data")
    @ResponseBody
    public Object getData(@RequestParam(defaultValue="1") int page,
                          @RequestParam(defaultValue="10") int rows,
                          @RequestParam(defaultValue="") String search) {
        return auditLogService.getPagedLogs(page, rows, search);
    }
}
