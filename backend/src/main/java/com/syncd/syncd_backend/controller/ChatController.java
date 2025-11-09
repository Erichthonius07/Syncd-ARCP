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

    /**
     * Endpoint to fetch chat history.
     * We assume the logged-in user's name will be sent,
     * perhaps from a JWT token in the future. For now, we pass it as a param.
     */
    @GetMapping("/{friendUsername}")
    public List<Message> getChatHistory(
            @RequestParam String loggedInUsername,
            @PathVariable String friendUsername) {
        return chatService.getChatHistory(loggedInUsername, friendUsername);
    }
}