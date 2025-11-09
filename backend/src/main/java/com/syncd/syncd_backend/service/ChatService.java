package com.syncd.syncd_backend.service;

import com.syncd.syncd_backend.model.Message;
import com.syncd.syncd_backend.repository.MessageRepository;
import org.springframework.stereotype.Service;

import java.time.LocalDateTime;
import java.util.List;

@Service
public class ChatService {

    private final MessageRepository messageRepository;

    public ChatService(MessageRepository messageRepository) {
        this.messageRepository = messageRepository;
    }

    /**
     * Fetches the full chat history between two users.
     */
    public List<Message> getChatHistory(String loggedInUsername, String friendUsername) {
        // ---- TEMPORARY TEST CODE ----
        // This adds a new message every time you call the API.
        // REMOVE THIS after testing.
        saveMessage(loggedInUsername, friendUsername, "This is a test message!");
        // ---- END OF TEST CODE ----
        // The repository query handles finding messages in both directions
        return messageRepository.findChatHistory(loggedInUsername, friendUsername);
    }

    /**
     * Saves a new message to the database.
     * This will be called by Developer B's WebSocket server.
     */
    public Message saveMessage(String sender, String receiver, String content) {
        Message message = new Message();
        message.setSenderUsername(sender);
        message.setReceiverUsername(receiver);
        message.setContent(content);
        message.setTimestamp(LocalDateTime.now());
        return messageRepository.save(message);
    }
}