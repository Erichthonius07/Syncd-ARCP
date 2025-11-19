package com.syncd.syncd_backend.controller;

// Import all DTOs for the game controller
import com.syncd.syncd_backend.dto.ChatMessage;
import com.syncd.syncd_backend.dto.GameInvite;
import com.syncd.syncd_backend.dto.GameInviteNotification;
import com.syncd.syncd_backend.dto.GameInput;
import com.syncd.syncd_backend.dto.GameState;
import com.syncd.syncd_backend.dto.SdpSignal;
import com.syncd.syncd_backend.dto.IceCandidateSignal;
import com.syncd.syncd_backend.service.ChatService;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.messaging.handler.annotation.MessageMapping;
import org.springframework.messaging.handler.annotation.Payload;
import org.springframework.messaging.simp.SimpMessagingTemplate;
import org.springframework.stereotype.Controller;

import java.security.Principal;

@Controller
public class GameController {

    @Autowired
    private SimpMessagingTemplate messagingTemplate;

    @Autowired
    private ChatService chatService; 

    /**
     * This method is triggered when a client sends a message to "/app/chat/send".
     * It saves the message and forwards it to the recipient.
     */
    @MessageMapping("/chat/send")
    public void sendChatMessage(@Payload ChatMessage chatMessage, Principal principal) {
        // 1. Get the sender's username from the authenticated principal
        String fromUser = principal.getName();
        // 2. Save the message to the database
        chatService.saveMessage(
                fromUser,
                chatMessage.getTo(),
                chatMessage.getText()
        );
        // 3. Send the message to the specific recipient's private queue
        messagingTemplate.convertAndSendToUser(
                chatMessage.getTo(),      // The recipient's username
                "/queue/messages",        // The private destination for messages
                chatMessage               // The ChatMessage payload
        );
    }


    /**
     * This method is triggered when a client sends a message to "/app/game/invite".
     */
    @MessageMapping("/game/invite")
    public void sendGameInvite(@Payload GameInvite invite, Principal principal) {
        String fromUser = principal.getName();
        GameInviteNotification notification = new GameInviteNotification(
                fromUser,
                invite.getGameCode()
        );
        messagingTemplate.convertAndSendToUser(
                invite.getToUser(),
                "/queue/invites",
                notification
        );
    }
    
    /**
     * This method is triggered when a client sends a game input to "/app/game/input".
     * It broadcasts the input to all other clients in the same lobby.
     */
    @MessageMapping("/game/input")
    public void handleGameInput(@Payload GameInput gameInput, Principal principal) {
        String fromUser = principal.getName();
        // Here you could add logic to check if 'fromUser' matches the 'playerSlot'
        String destination = "/topic/game/" + gameInput.getGameCode();
        messagingTemplate.convertAndSend(destination, gameInput);
    }

    /**
     * This method is triggered when a host sends a full state snapshot
     * to "/app/game/state".
     */
    @MessageMapping("/game/state")
    public void handleGameState(@Payload GameState gameState) {
        String destination = "/topic/game/" + gameState.getGameCode();
        messagingTemplate.convertAndSend(destination, gameState);
    }

    // --- NEW METHODS FOR WEBRTC VIDEO SIGNALING ---

    /**
     * Handles forwarding the WebRTC SDP (Offer/Answer) signals
     */
    @MessageMapping("/game/signal/sdp")
    public void forwardSdpSignal(@Payload SdpSignal signal, Principal principal) {
        
        // Set the 'fromUser' based on the authenticated sender
        signal.setFromUser(principal.getName());
        
        System.out.println("Forwarding SDP from " + signal.getFromUser() + " to " + signal.getToUser());
        
        messagingTemplate.convertAndSendToUser(
                signal.getToUser(),       // The recipient's username
                "/queue/webrtc/sdp",      // The private destination for SDP signals
                signal                    // The full SdpSignal object
        );
    }

    /**
     * Handles forwarding the WebRTC ICE Candidate signals
     */
    @MessageMapping("/game/signal/ice")
    public void forwardIceCandidate(@Payload IceCandidateSignal signal, Principal principal) {

        // Set the 'fromUser' based on the authenticated sender
        signal.setFromUser(principal.getName());

        System.out.println("Forwarding ICE from " + signal.getFromUser() + " to " + signal.getToUser());
        
        messagingTemplate.convertAndSendToUser(
                signal.getToUser(),       // The recipient's username
                "/queue/webrtc/ice",      // The private destination for ICE signals
                signal                    // The full IceCandidateSignal object
        );
    }
}