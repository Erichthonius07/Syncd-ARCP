package com.syncd.syncd_backend.dto;

/**
 * DTO for WebRTC Session Description Protocol (SDP) signals.
 * This is used to send the "offer" and "answer"
 * between peers.
 */
public class SdpSignal {

    private String gameCode;  // The lobby
    private String peerId;    // The peer identifier (guest_1, guest_2, etc. or host)
    private String toUser;    // Legacy: The specific user this signal is for
    private String fromUser;  // The user who sent this signal
    private String sdp;       // The actual SDP payload (the offer/answer)

    // --- Getters and Setters ---
    public String getGameCode() {
        return gameCode;
    }

    public void setGameCode(String gameCode) {
        this.gameCode = gameCode;
    }

    public String getPeerId() {
        return peerId;
    }

    public void setPeerId(String peerId) {
        this.peerId = peerId;
    }

    public String getToUser() {
        return toUser;
    }

    public void setToUser(String toUser) {
        this.toUser = toUser;
    }

    public String getFromUser() {
        return fromUser;
    }

    public void setFromUser(String fromUser) {
        this.fromUser = fromUser;
    }

    public String getSdp() {
        return sdp;
    }

    public void setSdp(String sdp) {
        this.sdp = sdp;
    }
}