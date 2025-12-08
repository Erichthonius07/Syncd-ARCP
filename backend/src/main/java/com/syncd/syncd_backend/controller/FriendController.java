package com.syncd.syncd_backend.controller;

import com.syncd.syncd_backend.model.FriendRequest;
import com.syncd.syncd_backend.model.User;
import com.syncd.syncd_backend.repository.UserRepository;
import com.syncd.syncd_backend.service.FriendService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.Authentication;
import org.springframework.web.bind.annotation.*;

import java.util.ArrayList;
import java.util.List;
import java.util.Optional;

@RestController
@RequestMapping("/api/friends")
@CrossOrigin(origins = "*")
public class FriendController {

    @Autowired
    private FriendService friendService;

    @Autowired
    private UserRepository userRepository;

    // POST /api/friends/request/{username}
    @PostMapping("/request/{username}")
    public ResponseEntity<?> sendFriendRequest(@PathVariable String username, Authentication authentication) {
        String myUsername = authentication.getName();
        
        Optional<User> me = userRepository.findByUsername(myUsername);
        if (me.isEmpty()) return ResponseEntity.status(401).body("Unauthorized");

        try {
            friendService.sendRequest(me.get().getId(), username);
            return ResponseEntity.ok("Friend request sent to " + username);
        } catch (IllegalArgumentException e) {
            return ResponseEntity.badRequest().body(e.getMessage());
        }
    }

    // GET /api/friends/search?query=alex
    @GetMapping("/search")
    public ResponseEntity<List<User>> searchUsers(@RequestParam String query) {
        List<User> results = friendService.searchUsers(query);
        
        results.forEach(u -> u.setPassword(null));
        
        return ResponseEntity.ok(results);
    }

    // GET /api/friends/requests (Pending Incoming)
    @GetMapping("/requests")
    public ResponseEntity<List<User>> getPendingRequests(Authentication authentication) {
        String myUsername = authentication.getName();
        User me = userRepository.findByUsername(myUsername).get();

        List<FriendRequest> requests = friendService.getFriendRequests(me.getId());
        
        List<User> senders = new ArrayList<>();
        for (FriendRequest req : requests) {
            userRepository.findById(req.getSenderId()).ifPresent(u -> {
                u.setPassword(null); // Hide password
                senders.add(u);
            });
        }

        return ResponseEntity.ok(senders);
    }

    // PUT /api/friends/respond (Accept/Decline)
    @PutMapping("/respond")
    public ResponseEntity<?> respondToRequest(@RequestBody RespondRequest body, Authentication authentication) {
        String myUsername = authentication.getName();
        
        try {
            // Find the ID of the receiver (myself)
            User receiver = userRepository.findByUsername(myUsername).orElseThrow(() -> new IllegalStateException("Receiver not found"));

            // Find the ID of the sender
            User sender = userRepository.findByUsername(body.senderUsername)
                    .orElseThrow(() -> new IllegalArgumentException("Sender not found"));

            // Use the service to find and update the request by IDs
            if (body.accept) {
                // If accepting, the service needs the Request ID
                Optional<FriendRequest> req = friendService.findRequest(sender.getId(), receiver.getId());
                if (req.isEmpty()) throw new IllegalArgumentException("Request not found");
                
                friendService.acceptRequest(req.get().getId());
                return ResponseEntity.ok("Friend Accepted!");
            } else {
                // If declining, the service needs the Request ID
                 Optional<FriendRequest> req = friendService.findRequest(sender.getId(), receiver.getId());
                 if (req.isEmpty()) throw new IllegalArgumentException("Request not found");
                 
                friendService.declineRequest(req.get().getId());
                return ResponseEntity.ok("Friend Declined.");
            }
            
        } catch (IllegalStateException | IllegalArgumentException e) {
            return ResponseEntity.badRequest().body(e.getMessage());
        } catch (Exception e) {
             return ResponseEntity.status(500).body("Internal error during response.");
        }
    }
    
    // DTO Class for the response body
    static class RespondRequest {
        public String senderUsername;
        public boolean accept;
    }
    
    // GET /api/friends (List my friends)
    @GetMapping
    public ResponseEntity<List<User>> getMyFriends(Authentication authentication) {
        String myUsername = authentication.getName();
        User me = userRepository.findByUsername(myUsername).get();

        List<FriendRequest> friendships = friendService.getFriends(me.getId());
        
        List<User> friends = new ArrayList<>();
        for (FriendRequest req : friendships) {
            String friendId = req.getSenderId().equals(me.getId()) ? req.getReceiverId() : req.getSenderId();
            userRepository.findById(friendId).ifPresent(u -> {
                u.setPassword(null);
                friends.add(u);
            });
        }

        return ResponseEntity.ok(friends);
    }
}