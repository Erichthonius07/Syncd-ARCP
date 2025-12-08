package com.syncd.syncd_backend.dto;

/**
 * Data Transfer Object (DTO) for standardizing authentication responses (Login/Register).
 * Contains the JWT token on success and a message for status/errors.
 */
public class AuthResponse {
    private String token;
    private String message;

    public AuthResponse(String token, String message) {
        this.token = token;
        this.message = message;
    }

    // Getters & Setters
    public String getToken() { 
        return token; 
    }
    public void setToken(String token) { 
        this.token = token; 
    }

    public String getMessage() { 
        return message; 
    }
    public void setMessage(String message) { 
        this.message = message; 
    }
}