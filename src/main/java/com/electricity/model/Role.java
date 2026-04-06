package com.electricity.model;

import lombok.Data;
import java.time.LocalDateTime;

@Data
public class Role {
    private Long id;
    private String name;
    private String description;
    private LocalDateTime createdAt;
}
