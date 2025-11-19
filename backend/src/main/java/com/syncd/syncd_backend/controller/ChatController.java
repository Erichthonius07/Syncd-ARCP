package com.syncd.syncd_backend.controller;

import com.syncd.syncd_backend.dto.ChatMessage;
import com.syncd.syncd_backend.model.Message;
import com.syncd.syncd_backend.service.ChatService;
import org.springframework.messaging.handler.annotation.MessageMapping;
import org.springframework.messaging.simp.SimpMessagingTemplate;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/api/chat")
@CrossOrigin(origins = "*")
public class ChatController {

    private final ChatService chatService;
    private final SimpMessagingTemplate messagingTemplate;

    public ChatController(ChatService chatService, SimpMessagingTemplate messagingTemplate) {
        this.chatService = chatService;
        this.messagingTemplate = messagingTemplate;
    }

    @MessageMapping("/chat")
    public void receiveMessage(ChatMessage chatMessage) {
        // Get sender from authenticated session
        Authentication auth = SecurityContextHolder.getContext().getAuthentication();
        String sender = auth != null ? auth.getName() : "anonymous";
        
        chatService.saveMessage(sender, chatMessage.getTo(), chatMessage.getText());
        messagingTemplate.convertAndSendToUser(
                chatMessage.getTo(),
                "/queue/messages",
                chatMessage
        );
    }

    @GetMapping("/{friendUsername}")
    public List<Message> getChatHistory(
            @RequestParam String loggedInUsername,
            @PathVariable String friendUsername) {
        return chatService.getChatHistory(loggedInUsername, friendUsername);
    }
}
