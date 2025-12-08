package com.syncd.syncd_backend.model;

import jakarta.persistence.*;
import java.util.ArrayList;
import java.util.List;

@Entity
@Table(name = "users")
public class User {

    @Id
    private String id; // Username or UUID

    private String username;
    
    // --- NEW FIELD ---
    private String email; 
    
    private String password; // In a real app, this should be hashed
    private boolean isOnline;

    // --- NEW v2.1 FIELDS ---
    private String avatarIcon; // Stores emoji like "👾"
    private String currentSquadId; // Null if not in a squad

    @ElementCollection(fetch = FetchType.EAGER)
    private List<String> gameLibrary = new ArrayList<>(); // Games owned by user

    // --- CONSTRUCTORS ---
    public User() {}

    // Updated constructor to include email
    public User(String id, String username, String email, String password, String avatarIcon) {
        this.id = id;
        this.username = username;
        this.email = email;
        this.password = password;
        this.avatarIcon = avatarIcon;
        this.isOnline = true;
    }

    // --- GETTERS & SETTERS ---
    public String getId() { return id; }
    public void setId(String id) { this.id = id; }

    public String getUsername() { return username; }
    public void setUsername(String username) { this.username = username; }

    public String getEmail() { return email; }
    public void setEmail(String email) { this.email = email; }

    public String getPassword() { return password; }
    public void setPassword(String password) { this.password = password; }

    public boolean isOnline() { return isOnline; }
    public void setOnline(boolean online) { isOnline = online; }

    public String getAvatarIcon() { return avatarIcon; }
    public void setAvatarIcon(String avatarIcon) { this.avatarIcon = avatarIcon; }

    public String getCurrentSquadId() { return currentSquadId; }
    public void setCurrentSquadId(String currentSquadId) { this.currentSquadId = currentSquadId; }

    public List<String> getGameLibrary() { return gameLibrary; }
    public void setGameLibrary(List<String> gameLibrary) { this.gameLibrary = gameLibrary; }
}