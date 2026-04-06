package com.electricity.service;

import com.electricity.model.AuditLog;
import javax.servlet.http.HttpServletRequest;

public interface AuditLogService {
    void log(String action, String entityType, Long entityId, String description,
             HttpServletRequest request);
    Object getPagedLogs(int page, int rows, String search);
}
