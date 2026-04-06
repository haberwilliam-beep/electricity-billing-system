package com.electricity.model;

import lombok.Data;
import java.time.LocalDateTime;

@Data
public class AuditLog {
    private Long id;
    private Long userId;
    private String username;
    private String action;
    private String entityType;
    private Long entityId;
    private String description;
    private String ipAddress;
    private LocalDateTime createdAt;
}
