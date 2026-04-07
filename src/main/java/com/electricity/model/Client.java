package com.electricity.model;

import java.time.LocalDateTime;

public class Client {

    public enum ClientType {
        METER_BASED, AMPER_BASED
    }

    public enum AmpereCapacity {
        FIVE(5), TEN(10);

        private final int value;
        AmpereCapacity(int value) { this.value = value; }
        public int getValue() { return value; }
    }

    private Long id;
    private String name;
    private String address;
    private String phone;
    private String email;
    private ClientType clientType;
    private Integer ampereCapacity;
    private String accountNumber;
    private boolean active;
    private String zoneName;
    private LocalDateTime createdAt;
    private LocalDateTime updatedAt;

    public Client() {}

    public Long getId() { return id; }
    public void setId(Long id) { this.id = id; }

    public String getName() { return name; }
    public void setName(String name) { this.name = name; }

    public String getAddress() { return address; }
    public void setAddress(String address) { this.address = address; }

    public String getPhone() { return phone; }
    public void setPhone(String phone) { this.phone = phone; }

    public String getEmail() { return email; }
    public void setEmail(String email) { this.email = email; }

    public ClientType getClientType() { return clientType; }
    public void setClientType(ClientType clientType) { this.clientType = clientType; }

    public Integer getAmpereCapacity() { return ampereCapacity; }
    public void setAmpereCapacity(Integer ampereCapacity) { this.ampereCapacity = ampereCapacity; }

    public String getAccountNumber() { return accountNumber; }
    public void setAccountNumber(String accountNumber) { this.accountNumber = accountNumber; }

    public boolean isActive() { return active; }
    /** Alias for {@link #isActive()} — satisfies frameworks that call getActive() on boolean properties. */
    public boolean getActive() { return active; }
    public void setActive(boolean active) { this.active = active; }

    public String getZoneName() { return zoneName; }
    public void setZoneName(String zoneName) { this.zoneName = zoneName; }

    public LocalDateTime getCreatedAt() { return createdAt; }
    public void setCreatedAt(LocalDateTime createdAt) { this.createdAt = createdAt; }

    public LocalDateTime getUpdatedAt() { return updatedAt; }
    public void setUpdatedAt(LocalDateTime updatedAt) { this.updatedAt = updatedAt; }
}
