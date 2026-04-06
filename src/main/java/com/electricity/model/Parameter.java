package com.electricity.model;

import lombok.Data;
import java.time.LocalDateTime;

@Data
public class Parameter {
    private Long id;
    private String paramKey;
    private String paramValue;
    private String description;
    private Long updatedBy;
    private LocalDateTime updatedAt;

    // join
    private String updatedByUsername;
}
