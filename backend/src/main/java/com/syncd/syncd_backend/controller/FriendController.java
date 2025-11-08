package com.syncd.syncd_backend.controller;

import com.syncd.syncd_backend.model.FriendRequest;
import com.syncd.syncd_backend.service.FriendService;
import org.springframework.web.bind.annotation.*;
import java.util.List;

@RestController
@RequestMapping("/api/friends")
@CrossOrigin(origins = "*")
public class FriendController {

    private final FriendService friendService;

    public FriendController(FriendService friendService) {
        this.friendService = friendService;
    }

    @PostMapping("/add")
    public FriendRequest sendRequest(
            @RequestParam String sender,
            @RequestParam String receiver) {
        return friendService.sendRequest(sender, receiver);
    }

    @GetMapping
    public List<FriendRequest> getFriends(@RequestParam String username) {
        return friendService.getFriends(username);
    }

    @GetMapping("/requests")
    public List<FriendRequest> getFriendRequests(@RequestParam String username) {
        return friendService.getFriendRequests(username);
    }

    @PostMapping("/accept/{id}")
    public String acceptRequest(@PathVariable Long id) {
        return friendService.acceptRequest(id);
    }

    @PostMapping("/decline/{id}")
    public String declineRequest(@PathVariable Long id) {
        return friendService.declineRequest(id);
    }
}
