package com.electricity.model;

import lombok.Data;
import java.time.LocalDateTime;

@Data
public class Zone {
    private Long id;
    private String name;
    private String description;
    private Boolean active;
    private LocalDateTime createdAt;
    private LocalDateTime updatedAt;
}
