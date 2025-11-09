package com.syncd.syncd_backend.dto;

/**
 * DTO for real-time game inputs broadcast over WebSocket.
 */
public class GameInput {

    private String gameCode; // The lobby code (e.g., "ABCD")
    private String inputData; // The actual input (e.g., "BTN_A_PRESS", "AXIS_X_0.85")

    // --- Getters and Setters ---
    public String getGameCode() {
        return gameCode;
    }

    public void setGameCode(String gameCode) {
        this.gameCode = gameCode;
    }

    public String getInputData() {
        return inputData;
    }

    public void setInputData(String inputData) {
        this.inputData = inputData;
    }
}