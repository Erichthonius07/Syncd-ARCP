package com.syncd.syncd_backend.controller;

import com.syncd.syncd_backend.model.User;
import com.syncd.syncd_backend.service.UserService;
import org.springframework.http.ResponseEntity; // 1. IMPORT
import org.springframework.web.bind.annotation.*;

@RestController
@RequestMapping("/api/auth")
@CrossOrigin(origins = "*")
public class AuthController {

    private final UserService userService;

    public AuthController(UserService userService) {
        this.userService = userService;
    }

    @PostMapping("/register")
    public String register(@RequestBody User user) {
        return userService.register(user);
    }

    /**
     * UPDATED: Now returns a JSON object with the token.
     */
    @PostMapping("/login")
    public ResponseEntity<?> login(@RequestBody User user) {
        String tokenOrError = userService.login(user.getUsername(), user.getPassword());

        // Check if the service returned a token or an error message
        if (tokenOrError.equals("Invalid password!") || tokenOrError.equals("User not found!")) {
            return ResponseEntity.status(401).body(tokenOrError);
        }

        // Return the token in a JSON object
        return ResponseEntity.ok(java.util.Collections.singletonMap("token", tokenOrError));
    }
}