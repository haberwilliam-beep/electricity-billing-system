package com.electricity.model;

import java.math.BigDecimal;
import java.time.LocalDate;
import java.time.LocalDateTime;

public class MeterReading {

    private Long id;
    private Long clientId;
    private String clientName;
    private LocalDate readingDate;
    private BigDecimal startReading;
    private BigDecimal endReading;
    private BigDecimal consumption;
    private Integer billingMonth;
    private Integer billingYear;
    private String notes;
    private LocalDateTime createdAt;
    private LocalDateTime updatedAt;

    public MeterReading() {}

    public Long getId() { return id; }
    public void setId(Long id) { this.id = id; }

    public Long getClientId() { return clientId; }
    public void setClientId(Long clientId) { this.clientId = clientId; }

    public String getClientName() { return clientName; }
    public void setClientName(String clientName) { this.clientName = clientName; }

    public LocalDate getReadingDate() { return readingDate; }
    public void setReadingDate(LocalDate readingDate) { this.readingDate = readingDate; }

    public BigDecimal getStartReading() { return startReading; }
    public void setStartReading(BigDecimal startReading) { this.startReading = startReading; }

    public BigDecimal getEndReading() { return endReading; }
    public void setEndReading(BigDecimal endReading) { this.endReading = endReading; }

    public BigDecimal getConsumption() { return consumption; }
    public void setConsumption(BigDecimal consumption) { this.consumption = consumption; }

    public Integer getBillingMonth() { return billingMonth; }
    public void setBillingMonth(Integer billingMonth) { this.billingMonth = billingMonth; }

    public Integer getBillingYear() { return billingYear; }
    public void setBillingYear(Integer billingYear) { this.billingYear = billingYear; }

    public String getNotes() { return notes; }
    public void setNotes(String notes) { this.notes = notes; }

    public LocalDateTime getCreatedAt() { return createdAt; }
    public void setCreatedAt(LocalDateTime createdAt) { this.createdAt = createdAt; }

    public LocalDateTime getUpdatedAt() { return updatedAt; }
    public void setUpdatedAt(LocalDateTime updatedAt) { this.updatedAt = updatedAt; }
}
