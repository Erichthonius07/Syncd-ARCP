package com.syncd.syncd_backend.controller;

// Import all DTOs for the game controller
import com.syncd.syncd_backend.dto.GameInvite;
import com.syncd.syncd_backend.dto.GameInviteNotification;
import com.syncd.syncd_backend.dto.GameInput;
import com.syncd.syncd_backend.dto.GameState;
import com.syncd.syncd_backend.dto.SdpSignal;           // <-- NEW IMPORT
import com.syncd.syncd_backend.dto.IceCandidateSignal;  // <-- NEW IMPORT

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

    /**
     * This method is triggered when a client sends a message to "/app/game/invite".
     */
    @MessageMapping("/game/invite")
    public void sendGameInvite(@Payload GameInvite invite, Principal principal) {

        // 1. Get the sender's username from the 'principal'
        String fromUser = principal.getName();

        // 2. Create the notification payload to send to the recipient
        GameInviteNotification notification = new GameInviteNotification(
                fromUser,
                invite.getGameCode()
        );

        // 3. Send the notification to the specific user's private queue
        // We'll create a new, dedicated queue called "/queue/invites"
        messagingTemplate.convertAndSendToUser(
                invite.getToUser(),       // The recipient's username
                "/queue/invites",         // The private destination for invites
                notification              // The notification payload
        );
    }
    /**
     * This method is triggered when a client sends a game input to "/app/game/input".
     * It broadcasts the input to all other clients in the same lobby.
     */
    @MessageMapping("/game/input")
    public void handleGameInput(@Payload GameInput gameInput, Principal principal) {

        // 1. Get the username of the person who sent the input
        String fromUser = principal.getName();

        // 2. Define the public topic for this specific game lobby
        String destination = "/topic/game/" + gameInput.getGameCode();

        // 3. Broadcast the input to everyone subscribed to that topic.
        //    The frontend app will be responsible for making sure it
        //    doesn't process its own sent messages.
        messagingTemplate.convertAndSend(destination, gameInput);
    }

    /**
     * This method is triggered when a host sends a full state snapshot
     * to "/app/game/state".
     * It broadcasts the state to all other clients in the same lobby
     * for synchronization.
     */
    @MessageMapping("/game/state")
    public void handleGameState(@Payload GameState gameState) {

        // 1. Define the public topic for this specific game lobby
        String destination = "/topic/game/" + gameState.getGameCode();

        // 2. Broadcast the full state to everyone subscribed to that topic.
        messagingTemplate.convertAndSend(destination, gameState);
    }

    // ---
    // --- NEW METHODS FOR WEBRTC VIDEO SIGNALING ---
    // ---

    /**
     * Handles forwarding the WebRTC SDP (Offer/Answer) signals
     * from one peer to the specified recipient.
     */
    @MessageMapping("/game/signal/sdp")
    public void forwardSdpSignal(@Payload SdpSignal signal) {
        
        // Log the signal for debugging
        System.out.println("Forwarding SDP from " + signal.getFromUser() + " to " + signal.getToUser());

        // Send the SDP signal to the specific user's private queue
        messagingTemplate.convertAndSendToUser(
                signal.getToUser(),       // The recipient's username
                "/queue/webrtc/sdp",      // The private destination for SDP signals
                signal                    // The full SdpSignal object
        );
    }

    /**
     * Handles forwarding the WebRTC ICE Candidate signals
     * from one peer to the specified recipient.
     */
    @MessageMapping("/game/signal/ice")
    public void forwardIceCandidate(@Payload IceCandidateSignal signal) {

        // Log the signal for debugging
        System.out.println("Forwarding ICE from " + signal.getFromUser() + " to " + signal.getToUser());

        // Send the ICE candidate to the specific user's private queue
        messagingTemplate.convertAndSendToUser(
                signal.getToUser(),       // The recipient's username
                "/queue/webrtc/ice",      // The private destination for ICE signals
                signal                    // The full IceCandidateSignal object
        );
    }
}