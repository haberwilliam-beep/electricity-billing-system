package com.electricity.model;

import lombok.Data;
import java.time.LocalDateTime;

@Data
public class Box {
    private Long id;
    private String name;
    private Long zoneId;
    private String description;
    private Boolean active;
    private LocalDateTime createdAt;
    private LocalDateTime updatedAt;

    // join
    private String zoneName;
}
