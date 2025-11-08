package com.syncd.syncd_backend.service;

import com.syncd.syncd_backend.model.FriendRequest;
import com.syncd.syncd_backend.repository.FriendRequestRepository;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.Optional;

@Service
public class FriendService {

    private final FriendRequestRepository friendRepo;

    public FriendService(FriendRequestRepository friendRepo) {
        this.friendRepo = friendRepo;
    }

    // ✅ Send a new friend request
    public FriendRequest sendRequest(String sender, String receiver) {
        if (sender == null || receiver == null || sender.equals(receiver)) {
            throw new IllegalArgumentException("Invalid sender or receiver");
        }

        FriendRequest request = new FriendRequest();
        request.setSender(sender);
        request.setReceiver(receiver);
        request.setStatus("PENDING");
        return friendRepo.save(request);
    }

    // ✅ Get all pending requests for a user
    public List<FriendRequest> getFriendRequests(String username) {
        return friendRepo.findByReceiverAndStatus(username, "PENDING");
    }

    // ✅ Get all accepted friends for a user
    public List<FriendRequest> getFriends(String username) {
        return friendRepo.findBySenderOrReceiverAndStatus(username, username, "ACCEPTED");
    }

    // ✅ Accept a friend request
    public String acceptRequest(Long id) {
        Optional<FriendRequest> requestOpt = friendRepo.findById(id);
        if (requestOpt.isEmpty()) {
            return "Friend request not found";
        }

        FriendRequest request = requestOpt.get();
        request.setStatus("ACCEPTED");
        friendRepo.save(request);
        return "Friend request accepted successfully";
    }

    // ✅ Decline a friend request
    public String declineRequest(Long id) {
        Optional<FriendRequest> requestOpt = friendRepo.findById(id);
        if (requestOpt.isEmpty()) {
            return "Friend request not found";
        }

        FriendRequest request = requestOpt.get();
        request.setStatus("DECLINED");
        friendRepo.save(request);
        return "Friend request declined successfully";
    }
}
