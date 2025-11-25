package com.syncd.syncd_backend.controller;

import com.syncd.syncd_backend.model.Message;
import com.syncd.syncd_backend.service.ChatService;
import org.springframework.web.bind.annotation.*;
import java.util.List;

@RestController
@RequestMapping("/api/chat")
@CrossOrigin(origins = "*")
public class ChatController {

    private final ChatService chatService;

    public ChatController(ChatService chatService) {
        this.chatService = chatService;
    }

    @GetMapping("/{friendUsername}")
    public List<Message> getChatHistory(
            @RequestParam String loggedInUsername,
            @PathVariable String friendUsername) {
        return chatService.getChatHistory(loggedInUsername, friendUsername);
    }
}