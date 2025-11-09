package com.syncd.syncd_backend.model;

import jakarta.persistence.*;
import java.util.HashSet;
import java.util.Set;

@Entity
@Table(name = "lobbies")
public class Lobby {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Column(unique = true, nullable = false, length = 6)
    private String gameCode; // e.g., "ABCD"

    @Column(nullable = false)
    private String hostUsername;

    @ElementCollection(fetch = FetchType.EAGER)
    private Set<String> participants = new HashSet<>();

    private boolean isGameStarted = false;

    // --- Constructors ---
    public Lobby() {}

    public Lobby(Long id, String gameCode, String hostUsername, Set<String> participants, boolean isGameStarted) {
        this.id = id;
        this.gameCode = gameCode;
        this.hostUsername = hostUsername;
        this.participants = participants;
        this.isGameStarted = isGameStarted;
    }

    // --- Getters ---
    public Long getId() { return id; }
    public String getGameCode() { return gameCode; }
    public String getHostUsername() { return hostUsername; }
    public Set<String> getParticipants() { return participants; }
    public boolean isGameStarted() { return isGameStarted; }

    // --- Setters ---
    public void setId(Long id) { this.id = id; }
    public void setGameCode(String gameCode) { this.gameCode = gameCode; }
    public void setHostUsername(String hostUsername) { this.hostUsername = hostUsername; }
    public void setParticipants(Set<String> participants) { this.participants = participants; }
    public void setGameStarted(boolean gameStarted) { isGameStarted = gameStarted; }
}