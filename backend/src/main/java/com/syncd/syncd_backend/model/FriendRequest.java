package com.syncd.syncd_backend.model;

import jakarta.persistence.*;

@Entity
@Table(name = "friend_requests")
public class FriendRequest {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Column(nullable = false)
    private String sender;

    @Column(nullable = false)
    private String receiver;

    @Column(nullable = false)
    private String status; // PENDING, ACCEPTED, DECLINED

    public FriendRequest() {}

    public FriendRequest(String sender, String receiver, String status) {
        this.sender = sender;
        this.receiver = receiver;
        this.status = status;
    }

    public Long getId() { return id; }
    public String getSender() { return sender; }
    public String getReceiver() { return receiver; }
    public String getStatus() { return status; }

    public void setId(Long id) { this.id = id; }
    public void setSender(String sender) { this.sender = sender; }
    public void setReceiver(String receiver) { this.receiver = receiver; }
    public void setStatus(String status) { this.status = status; }
}
