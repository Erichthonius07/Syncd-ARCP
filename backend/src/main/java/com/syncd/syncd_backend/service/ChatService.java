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
        // The repository query handles finding messages in both directions
        return messageRepository.findChatHistory(loggedInUsername, friendUsername);
    }

    /**
     * Saves a new message to the database.
     * This is called by the GameController.
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