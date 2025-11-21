package com.syncd.syncd_backend.dto;

/**
 * DTO for the notification message sent FROM the server TO the recipient.
 */
public class GameInviteNotification {

    private String fromUser; // The user who sent the invite
    private String gameCode; // The lobby code

    // Constructor to make it easy to create
    public GameInviteNotification(String fromUser, String gameCode) {
        this.fromUser = fromUser;
        this.gameCode = gameCode;
    }

    // --- Getters and Setters ---
    public String getFromUser() {
        return fromUser;
    }

    public void setFromUser(String fromUser) {
        this.fromUser = fromUser;
    }

    public String getGameCode() {
        return gameCode;
    }

    public void setGameCode(String gameCode) {
        this.gameCode = gameCode;
    }
}