package com.electricity.model;

import java.time.LocalDateTime;

public class Translation {

    private Long id;
    private String msgKey;
    private String locale;
    private String message;
    private LocalDateTime createdAt;
    private LocalDateTime updatedAt;

    public Translation() {}

    public Long getId() { return id; }
    public void setId(Long id) { this.id = id; }

    public String getMsgKey() { return msgKey; }
    public void setMsgKey(String msgKey) { this.msgKey = msgKey; }

    public String getLocale() { return locale; }
    public void setLocale(String locale) { this.locale = locale; }

    public String getMessage() { return message; }
    public void setMessage(String message) { this.message = message; }

    public LocalDateTime getCreatedAt() { return createdAt; }
    public void setCreatedAt(LocalDateTime createdAt) { this.createdAt = createdAt; }

    public LocalDateTime getUpdatedAt() { return updatedAt; }
    public void setUpdatedAt(LocalDateTime updatedAt) { this.updatedAt = updatedAt; }
}
