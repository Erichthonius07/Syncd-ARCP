package com.syncd.syncd_backend.controller;

import com.syncd.syncd_backend.model.User;
import com.syncd.syncd_backend.repository.UserRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.Authentication;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.bind.annotation.*;

import java.util.ArrayList;
import java.util.List;
import java.util.Map;
import java.util.Optional;

@RestController
@RequestMapping("/api/user")
@CrossOrigin(origins = "*")
public class UserController {

    @Autowired
    private UserRepository userRepository;

    /**
     * GET /api/user/me
     * Returns the currently logged-in user's profile (Username, Avatar, Library).
     * This is called by the frontend on startup to "remember" and display the synced games.
     */
    @GetMapping("/me")
    public ResponseEntity<?> getMyProfile(Authentication authentication) {
        String username = authentication.getName(); // Get username from JWT
        Optional<User> userOpt = userRepository.findByUsername(username);

        if (userOpt.isPresent()) {
            User user = userOpt.get();
            // Important: Remove password before sending to frontend
            user.setPassword(null); 
            
            // Log for debugging: Confirm that the backend is actually sending the remembered games
            System.out.println("📤 Fetching profile for " + username + ". Games remembered: " + user.getGameLibrary());
            
            return ResponseEntity.ok(user);
        }
        return ResponseEntity.status(404).body("User not found");
    }

    /**
     * PUT /api/user/me/avatar
     * Updates the user's avatar icon (emoji).
     * Payload: { "icon": "👽" }
     */
    @PutMapping("/me/avatar")
    @Transactional
    public ResponseEntity<?> updateAvatar(@RequestBody Map<String, String> payload, Authentication authentication) {
        String username = authentication.getName();
        String newIcon = payload.get("icon");
        
        Optional<User> userOpt = userRepository.findByUsername(username);

        if (userOpt.isPresent() && newIcon != null) {
            User user = userOpt.get();
            user.setAvatarIcon(newIcon);
            userRepository.save(user);
            return ResponseEntity.ok("Avatar updated to " + newIcon);
        }
        return ResponseEntity.badRequest().body("Invalid request or user not found.");
    }
    
    /**
     * PUT /api/user/library/sync
     * Persists the user's selected game library to the database.
     * This ensures games added from "On Device" are remembered and showcased in "Sync'd Space".
     */
    @PutMapping("/library/sync")
    @Transactional
    public ResponseEntity<?> syncGameLibrary(@RequestBody List<String> games, Authentication authentication) {
        String username = authentication.getName();
        Optional<User> userOpt = userRepository.findByUsername(username);

        if (userOpt.isPresent()) {
            User user = userOpt.get();
            
            // Explicitly create a new list and set it to ensure Hibernate updates the collection
            List<String> newLibrary = new ArrayList<>(games != null ? games : new ArrayList<>());
            user.setGameLibrary(newLibrary);
            
            // Critical Fix: saveAndFlush forces the DB write immediately so it is remembered
            userRepository.saveAndFlush(user);
            
            System.out.println("✅ SAVED Library for " + username + ": " + newLibrary);
            return ResponseEntity.ok("Library updated. Count: " + user.getGameLibrary().size());
        }
        return ResponseEntity.status(404).body("User not found");
    }
    
    // NOTE: Additional endpoints like PUT /api/user/me/name can be added here if profile name editing is required.
}