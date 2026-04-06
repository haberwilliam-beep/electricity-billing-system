package com.electricity.model;

import lombok.Data;
import java.math.BigDecimal;
import java.time.LocalDateTime;

@Data
public class Customer {
    private Long id;
    private String name;
    private String phone;
    private String address;
    private Long boxId;
    private String billingType; // METER or AMPER
    private BigDecimal amperCapacity;
    private String meterNumber;
    private Boolean active;
    private LocalDateTime createdAt;
    private LocalDateTime updatedAt;

    // joins
    private String boxName;
    private String zoneName;
    private Long zoneId;
}
