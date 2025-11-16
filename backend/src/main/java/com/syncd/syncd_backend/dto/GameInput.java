package com.syncd.syncd_backend.dto;

/**
 * DTO for real-time game inputs broadcast over WebSocket.
 * This DTO now includes a playerSlot to identify which "virtual controller"
 * sent the input.
 */
public class GameInput {

    private String gameCode; // The lobby code (e.g., "ABCD")
    
    // --- THIS IS THE NEW, CRITICAL FIELD ---
    private int playerSlot;  // The player's assigned number (e.g., 1, 2, 3, 4)
    
    private String inputData; // The actual input (e.g., "BTN_A_PRESS", "AXIS_X_0.85")

    // --- Getters and Setters ---
    public String getGameCode() {
        return gameCode;
    }

    public void setGameCode(String gameCode) {
        this.gameCode = gameCode;
    }

    public int getPlayerSlot() {
        return playerSlot;
    }

    public void setPlayerSlot(int playerSlot) {
        this.playerSlot = playerSlot;
    }

    public String getInputData() {
        return inputData;
    }

    public void setInputData(String inputData) {
        this.inputData = inputData;
    }
}