package com.syncd.syncd_backend.model;

import jakarta.persistence.*;
import java.time.LocalDateTime;

@Entity
@Table(name = "activities")
public class Activity {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;
    private String username;
    private String message;
    private LocalDateTime timestamp;

    // --- Constructors ---
    public Activity() {}

    public Activity(Long id, String username, String message, LocalDateTime timestamp) {
        this.id = id;
        this.username = username;
        this.message = message;
        this.timestamp = timestamp;
    }

    // --- Getters ---
    public Long getId() { return id; }
    public String getUsername() { return username; }
    public String getMessage() { return message; }
    public LocalDateTime getTimestamp() { return timestamp; }

    // --- Setters ---
    public void setId(Long id) { this.id = id; }
    public void setUsername(String username) { this.username = username; }
    public void setMessage(String message) { this.message = message; }
    public void setTimestamp(LocalDateTime timestamp) { this.timestamp = timestamp; }
}