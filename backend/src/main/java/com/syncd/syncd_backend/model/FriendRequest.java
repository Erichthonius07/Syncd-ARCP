package com.syncd.syncd_backend.model;

import jakarta.persistence.*;
import java.util.UUID;

@Entity
@Table(name = "friend_requests")
public class FriendRequest {

    @Id
    private String id;

    private String senderId;
    private String receiverId;
    
    // "PENDING", "ACCEPTED", "DECLINED"
    private String status; 

    public FriendRequest() {
        this.id = UUID.randomUUID().toString();
        this.status = "PENDING";
    }

    public FriendRequest(String senderId, String receiverId) {
        this.id = UUID.randomUUID().toString();
        this.senderId = senderId;
        this.receiverId = receiverId;
        this.status = "PENDING";
    }

    // Getters & Setters
    public String getId() { return id; }
    public void setId(String id) { this.id = id; }

    public String getSenderId() { return senderId; }
    public void setSenderId(String senderId) { this.senderId = senderId; }

    public String getReceiverId() { return receiverId; }
    public void setReceiverId(String receiverId) { this.receiverId = receiverId; }

    public String getStatus() { return status; }
    public void setStatus(String status) { this.status = status; }
}