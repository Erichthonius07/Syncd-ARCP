package com.syncd.syncd_backend.dto;

/**
 * DTO for the "invite" message sent FROM the client TO the server.
 */
public class GameInvite {

    private String toUser;   // The username of the friend to invite
    private String gameCode; // The lobby code (e.g., "ABCD")

    // --- Getters and Setters ---
    public String getToUser() {
        return toUser;
    }

    public void setToUser(String toUser) {
        this.toUser = toUser;
    }

    public String getGameCode() {
        return gameCode;
    }

    public void setGameCode(String gameCode) {
        this.gameCode = gameCode;
    }
}