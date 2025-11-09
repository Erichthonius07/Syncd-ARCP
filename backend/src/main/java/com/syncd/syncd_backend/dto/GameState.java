package com.syncd.syncd_backend.dto;

/**
 * DTO for real-time game state snapshots (for sync/resync).
 */
public class GameState {

    private String gameCode; // The lobby code (e.g., "ABCD")
    private String stateData; // A complete game state snapshot (likely as a JSON string)

    // --- Getters and Setters ---
    public String getGameCode() {
        return gameCode;
    }

    public void setGameCode(String gameCode) {
        this.gameCode = gameCode;
    }

    public String getStateData() {
        return stateData;
    }

    public void setStateData(String stateData) {
        this.stateData = stateData;
    }
}