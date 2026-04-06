package com.electricity.service.impl;

import com.electricity.dto.GridResponse;
import com.electricity.mapper.AuditLogMapper;
import com.electricity.model.AuditLog;
import com.electricity.service.AuditLogService;
import lombok.RequiredArgsConstructor;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.stereotype.Service;

import javax.servlet.http.HttpServletRequest;
import java.util.List;

@Service
@RequiredArgsConstructor
public class AuditLogServiceImpl implements AuditLogService {

    private final AuditLogMapper auditLogMapper;

    @Override
    public void log(String action, String entityType, Long entityId,
                    String description, HttpServletRequest request) {
        Authentication auth = SecurityContextHolder.getContext().getAuthentication();
        AuditLog log = new AuditLog();
        if (auth != null && auth.isAuthenticated()) {
            log.setUsername(auth.getName());
        }
        log.setAction(action);
        log.setEntityType(entityType);
        log.setEntityId(entityId);
        log.setDescription(description);
        if (request != null) {
            log.setIpAddress(request.getRemoteAddr());
        }
        auditLogMapper.insert(log);
    }

    @Override
    public Object getPagedLogs(int page, int rows, String search) {
        int offset = (page - 1) * rows;
        long total = auditLogMapper.countAll(search);
        List<AuditLog> list = auditLogMapper.findAllPaged(offset, rows, search);
        return new GridResponse<>(page, rows, total, list);
    }
}
