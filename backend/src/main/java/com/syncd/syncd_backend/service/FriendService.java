package com.syncd.syncd_backend.service;

import com.syncd.syncd_backend.model.FriendRequest;
import com.syncd.syncd_backend.model.User;
import com.syncd.syncd_backend.repository.FriendRepository;
import com.syncd.syncd_backend.repository.UserRepository;
import org.springframework.stereotype.Service;
import java.util.List;
import java.util.Optional;

@Service
public class FriendService {
    private final FriendRepository friendRepo;
    private final UserRepository userRepo; // Need this to check user existence

    public FriendService(FriendRepository friendRepo, UserRepository userRepo) {
        this.friendRepo = friendRepo;
        this.userRepo = userRepo;
    }

    public FriendRequest sendRequest(String senderId, String receiverUsername) {
        // 1. Check if receiver exists
        User receiver = userRepo.findByUsername(receiverUsername)
                .orElseThrow(() -> new IllegalArgumentException("User not found: " + receiverUsername));

        // 2. Prevent self-request
        if (receiver.getId().equals(senderId)) {
            throw new IllegalArgumentException("You cannot add yourself as a friend.");
        }

        // 3. Check if request already exists (or if they are already friends)
        Optional<FriendRequest> existing = friendRepo.findBySenderIdAndReceiverId(senderId, receiver.getId());
        if (existing.isPresent()) {
            throw new IllegalArgumentException("Request already sent or friendship exists.");
        }
        
        // Also check reverse direction (if they sent me a request)
        Optional<FriendRequest> reverse = friendRepo.findBySenderIdAndReceiverId(receiver.getId(), senderId);
        if (reverse.isPresent()) {
             throw new IllegalArgumentException("They already sent you a request! Check your inbox.");
        }

        // 4. Create Request
        FriendRequest request = new FriendRequest();
        request.setSenderId(senderId);
        request.setReceiverId(receiver.getId()); // Use the ID we found
        request.setStatus("PENDING");
        return friendRepo.save(request);
    }

    public FriendRequest acceptRequest(String id) {
        FriendRequest req = friendRepo.findById(id)
                .orElseThrow(() -> new IllegalArgumentException("Invalid request ID"));
        req.setStatus("ACCEPTED");
        return friendRepo.save(req);
    }

    public List<FriendRequest> getFriends(String userId) {
        return friendRepo.findAll().stream()
                .filter(req -> req.getStatus().equals("ACCEPTED") &&
                        (req.getSenderId().equals(userId) || req.getReceiverId().equals(userId)))
                .toList();
    }

    public List<FriendRequest> getFriendRequests(String userId) {
        return friendRepo.findByReceiverIdAndStatus(userId, "PENDING");
    }

    public FriendRequest declineRequest(String id) {
        FriendRequest req = friendRepo.findById(id)
                .orElseThrow(() -> new IllegalArgumentException("Invalid request ID"));
        req.setStatus("DECLINED");
        return friendRepo.save(req);
    }

    public Optional<FriendRequest> findRequest(String senderId, String receiverId) {
        return friendRepo.findBySenderIdAndReceiverId(senderId, receiverId);
    }

    // --- NEW: Search Method ---
    public List<User> searchUsers(String query) {
        if (query == null || query.trim().isEmpty()) {
            return List.of();
        }
        // Find users containing the query string
        return userRepo.findByUsernameContainingIgnoreCase(query);
    }
}