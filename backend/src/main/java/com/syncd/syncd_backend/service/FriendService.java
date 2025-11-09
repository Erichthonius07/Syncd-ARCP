package com.syncd.syncd_backend.service;

import com.syncd.syncd_backend.model.FriendRequest;
import com.syncd.syncd_backend.repository.FriendRepository;
import org.springframework.stereotype.Service;
import java.util.List;
@Service
public class FriendService {
    private final FriendRepository friendRepo;
    public FriendService(FriendRepository friendRepo) {
        this.friendRepo = friendRepo;
    }

    public FriendRequest sendRequest(String sender, String receiver) {
        FriendRequest request = new FriendRequest();
        request.setSender(sender);
        request.setReceiver(receiver);
        request.setStatus("PENDING");
        return friendRepo.save(request);
    }

    public FriendRequest acceptRequest(Long id) {
        FriendRequest req = friendRepo.findById(id)
                .orElseThrow(() -> new IllegalArgumentException("Invalid request ID"));
        req.setStatus("ACCEPTED");
        return friendRepo.save(req);
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

    public FriendRequest declineRequest(Long id) {
        FriendRequest req = friendRepo.findById(id)
                .orElseThrow(() -> new IllegalArgumentException("Invalid request ID"));
        req.setStatus("DECLINED");
        return friendRepo.save(req);
    }

}