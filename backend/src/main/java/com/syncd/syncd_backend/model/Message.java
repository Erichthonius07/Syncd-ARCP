package com.syncd.syncd_backend.model;

import jakarta.persistence.*;
import java.time.LocalDateTime;

@Entity
@Table(name = "messages")
public class Message {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Column(nullable = false)
    private String senderUsername;

    @Column(nullable = false)
    private String receiverUsername;

    @Column(nullable = false)
    private String content;

    @Column(nullable = false)
    private LocalDateTime timestamp;

    // --- Constructors ---
    public Message() {}

    public Message(Long id, String senderUsername, String receiverUsername, String content, LocalDateTime timestamp) {
        this.id = id;
        this.senderUsername = senderUsername;
        this.receiverUsername = receiverUsername;
        this.content = content;
        this.timestamp = timestamp;
    }

    // --- Getters ---
    public Long getId() { return id; }
    public String getSenderUsername() { return senderUsername; }
    public String getReceiverUsername() { return receiverUsername; }
    public String getContent() { return content; }
    public LocalDateTime getTimestamp() { return timestamp; }

    // --- Setters ---
    public void setId(Long id) { this.id = id; }
    public void setSenderUsername(String senderUsername) { this.senderUsername = senderUsername; }
    public void setReceiverUsername(String receiverUsername) { this.receiverUsername = receiverUsername; }
    public void setContent(String content) { this.content = content; }
    public void setTimestamp(LocalDateTime timestamp) { this.timestamp = timestamp; }
}