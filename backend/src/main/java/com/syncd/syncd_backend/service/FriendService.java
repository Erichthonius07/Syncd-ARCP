package com.syncd.syncd_backend.service;

import com.syncd.syncd_backend.model.FriendRequest;
import com.syncd.syncd_backend.repository.FriendRequestRepository;
import org.springframework.stereotype.Service;
import java.util.List;
import java.util.Optional;

@Service
public class FriendService {

    private final FriendRequestRepository friendRepo;
    private final ActivityService activityService; // ✅ Injected ActivityService

    public FriendService(FriendRequestRepository friendRepo, ActivityService activityService) {
        this.friendRepo = friendRepo;
        this.activityService = activityService;
    }

    // ✅ Send Friend Request
    public FriendRequest sendRequest(String sender, String receiver) {
        if (sender == null || receiver == null || sender.equals(receiver)) {
            throw new IllegalArgumentException("Invalid sender or receiver");
        }

        FriendRequest request = new FriendRequest(sender, receiver, "PENDING");
        friendRepo.save(request);

        // 🔥 Log activity automatically
        activityService.addActivity(sender, "Sent a friend request to " + receiver);
        activityService.addActivity(receiver, "Received a friend request from " + sender);

        return request;
    }

    // ✅ Accept Friend Request
    public String acceptRequest(Long id) {
        Optional<FriendRequest> requestOpt = friendRepo.findById(id);
        if (requestOpt.isEmpty()) return "Friend request not found";

        FriendRequest req = requestOpt.get();
        req.setStatus("ACCEPTED");
        friendRepo.save(req);

        // 🔥 Log both users’ activity
        activityService.addActivity(req.getSender(), "Friend request accepted by " + req.getReceiver());
        activityService.addActivity(req.getReceiver(), "You are now friends with " + req.getSender());

        return "Friend request accepted successfully";
    }

    // ✅ Decline Friend Request
    public String declineRequest(Long id) {
        Optional<FriendRequest> requestOpt = friendRepo.findById(id);
        if (requestOpt.isEmpty()) return "Friend request not found";

        FriendRequest req = requestOpt.get();
        req.setStatus("DECLINED");
        friendRepo.save(req);

        // 🔥 Log decline activity
        activityService.addActivity(req.getSender(), "Friend request was declined by " + req.getReceiver());
        activityService.addActivity(req.getReceiver(), "You declined a friend request from " + req.getSender());

        return "Friend request declined successfully";
    }

    // ✅ Fetch all requests
    public List<FriendRequest> getAllRequests() {
        return friendRepo.findAll();
    }

    public List<FriendRequest> getFriends(String username) {
        return friendRepo.findAll().stream()
            .filter(req -> req.getStatus().equals("ACCEPTED") &&
                    (req.getSender().equals(username) || req.getReceiver().equals(username)))
            .toList();
    }

    public List<FriendRequest> getFriendRequests(String username) {
        return friendRepo.findAll().stream()
            .filter(req -> req.getReceiver().equals(username) && req.getStatus().equals("PENDING"))
            .toList();
    }

}
