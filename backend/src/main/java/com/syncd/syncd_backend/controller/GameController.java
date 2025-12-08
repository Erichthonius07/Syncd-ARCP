package com.syncd.syncd_backend.controller;

import com.syncd.syncd_backend.dto.*;
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

    // --- 1. REAL-TIME CHAT ---
    @MessageMapping("/chat/send")
    public void sendChatMessage(@Payload ChatMessage chatMessage, Principal principal) {
        String fromUser = principal.getName();
        // Save to DB
        chatService.saveMessage(fromUser, chatMessage.getTo(), chatMessage.getText());
        // Forward to Recipient
        messagingTemplate.convertAndSendToUser(
                chatMessage.getTo(), "/queue/messages", chatMessage
        );
    }

    // --- 2. GAME INPUTS (VIRTUAL CONTROLLER) ---
    @MessageMapping("/game/input")
    public void handleGameInput(@Payload GameInput gameInput, Principal principal) {
        // Broadcast input to the specific lobby topic
        String destination = "/topic/game/" + gameInput.getGameCode();
        System.out.println("🎮 Input Received: " + gameInput.getInputData() + " for Lobby: " + gameInput.getGameCode());
        messagingTemplate.convertAndSend(destination, gameInput);
    }

    // --- 3. WEBRTC SIGNALING ---
    @MessageMapping("/game/signal/sdp")
    public void forwardSdpSignal(@Payload SdpSignal signal, Principal principal) {
        signal.setFromUser(principal.getName());
        messagingTemplate.convertAndSendToUser(
                signal.getToUser(), "/queue/webrtc/sdp", signal
        );
    }

    @MessageMapping("/game/signal/ice")
    public void forwardIceCandidate(@Payload IceCandidateSignal signal, Principal principal) {
        signal.setFromUser(principal.getName());
        messagingTemplate.convertAndSendToUser(
                signal.getToUser(), "/queue/webrtc/ice", signal
        );
    }
    
    // --- 4. INVITES ---
    @MessageMapping("/game/invite")
    public void sendGameInvite(@Payload GameInvite invite, Principal principal) {
        String fromUser = principal.getName();
        GameInviteNotification notification = new GameInviteNotification(fromUser, invite.getGameCode());
        messagingTemplate.convertAndSendToUser(invite.getToUser(), "/queue/invites", notification);
    }
    
    // --- 5. STATE SYNC ---
    @MessageMapping("/game/state")
    public void handleGameState(@Payload GameState gameState) {
        String destination = "/topic/game/" + gameState.getGameCode();
        messagingTemplate.convertAndSend(destination, gameState);
    }
}