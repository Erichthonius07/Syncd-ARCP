package com.syncd.syncd_backend.dto;

/**
 * Data Transfer Object (DTO) for a chat message sent over WebSocket.
 */
public class ChatMessage {

    private String to; // The username of the recipient
    private String text; // The content of the message
    // 'from' will be handled by the authenticated session, so we don't need it here.

    // --- Getters and Setters ---

    public String getTo() {
        return to;
    }

    public void setTo(String to) {
        this.to = to;
    }

    public String getText() {
        return text;
    }

    public void setText(String text) {
        this.text = text;
    }
}