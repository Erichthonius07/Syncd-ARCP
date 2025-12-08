package com.syncd.syncd_backend.controller;

import com.syncd.syncd_backend.dto.AuthRequest;
import com.syncd.syncd_backend.dto.AuthResponse;
import com.syncd.syncd_backend.model.User;
import com.syncd.syncd_backend.service.UserService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.UUID;

@RestController
@RequestMapping("/api/auth")
@CrossOrigin(origins = "*") // Allow Flutter to connect from anywhere (localhost, emulator, etc.)
public class AuthController {

    @Autowired
    private UserService userService;

    /**
     * REGISTER Endpoint
     * Accepts JSON: { "username": "...", "password": "...", "email": "...", "avatarIcon": "..." }
     */
    @PostMapping("/register")
    public ResponseEntity<AuthResponse> register(@RequestBody AuthRequest request) {
        
        // 1. Create a new User Entity from the Request DTO
        User newUser = new User(
                UUID.randomUUID().toString(), // Generate a unique ID
                request.getUsername(),
                request.getEmail(),
                request.getPassword(), // Service will hash this
                request.getAvatarIcon()
        );

        // 2. Call Service to save user
        String result = userService.register(newUser);

        // 3. Return response
        if (result.contains("successfully")) {
            return ResponseEntity.ok(new AuthResponse(null, result));
        } else {
            // If "Username exists" or "Email exists"
            return ResponseEntity.badRequest().body(new AuthResponse(null, result));
        }
    }

    /**
     * LOGIN Endpoint
     * Accepts JSON: { "username": "...", "password": "..." }
     * Returns JSON: { "token": "ey...", "message": "Login Successful" }
     */
    @PostMapping("/login")
    public ResponseEntity<AuthResponse> login(@RequestBody AuthRequest request) {
        
        // 1. Call Service (returns Token OR Error Message)
        String tokenOrError = userService.login(request.getUsername(), request.getPassword());

        // 2. Check if it's a valid JWT (JWTs start with "ey")
        if (tokenOrError.startsWith("ey")) {
            return ResponseEntity.ok(new AuthResponse(tokenOrError, "Login Successful"));
        } else {
            // 3. Return 401 Unauthorized if login failed
            return ResponseEntity.status(401).body(new AuthResponse(null, tokenOrError));
        }
    }
}