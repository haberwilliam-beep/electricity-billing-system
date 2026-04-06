package com.electricity.model;

import lombok.Data;
import java.time.LocalDateTime;

@Data
public class Translation {
    private Long id;
    private String msgKey;
    private String enValue;
    private String arValue;
    private Long updatedBy;
    private LocalDateTime updatedAt;

    private String updatedByUsername;
}
