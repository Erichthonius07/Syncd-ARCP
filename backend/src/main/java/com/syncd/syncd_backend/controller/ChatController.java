package com.syncd.syncd_backend.controller;

import com.syncd.syncd_backend.dto.ChatMessage;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.messaging.handler.annotation.MessageMapping;
import org.springframework.messaging.handler.annotation.Payload;
import org.springframework.messaging.simp.SimpMessagingTemplate;
import org.springframework.stereotype.Controller;

import java.security.Principal;

@Controller
public class ChatController {

    // This is Spring's magic tool for sending messages.
    // Think of it as our personal "postman" for WebSockets.
    @Autowired
    private SimpMessagingTemplate messagingTemplate;

    /**
     * This method is triggered when a client sends a message to "/app/chat".
     *
     * @param message   The message payload (our ChatMessage object)
     * @param principal A special object Spring gives us that holds the
     * authenticated user's details (like their username).
     */
    @MessageMapping("/chat")
    public void processMessage(@Payload ChatMessage message, Principal principal) {

        // This is the core logic.
        // We use our "postman" (messagingTemplate) to send the message
        // to a specific user.
        //
        // The destination "/queue/messages" is a private queue for the recipient.
        // The client app will need to subscribe to this destination to receive messages.
        //
        // Example: If 'message.getTo()' is "jane_doe", Spring sends this
        // message to a private channel only "jane_doe" is subscribed to.

        messagingTemplate.convertAndSendToUser(
                message.getTo(),           // The recipient's username
                "/queue/messages",         // The private destination
                message                    // The message payload
        );
    }
}