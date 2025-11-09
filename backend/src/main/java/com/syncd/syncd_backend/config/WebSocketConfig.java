package com.syncd.syncd_backend.config;

import org.springframework.context.annotation.Configuration;
import org.springframework.messaging.simp.config.MessageBrokerRegistry;
import org.springframework.web.socket.config.annotation.EnableWebSocketMessageBroker;
import org.springframework.web.socket.config.annotation.StompEndpointRegistry;
import org.springframework.web.socket.config.annotation.WebSocketMessageBrokerConfigurer;

@Configuration
@EnableWebSocketMessageBroker // This enables WebSocket message handling
public class WebSocketConfig implements WebSocketMessageBrokerConfigurer {

    @Override
    public void configureMessageBroker(MessageBrokerRegistry config) {
        // Defines prefixes for messages that are "routed" by the broker.
        // The client will subscribe to destinations like "/topic/..." or "/queue/..."
        config.enableSimpleBroker("/topic", "/queue");

        // Defines the prefix for messages that are "sent" by the client.
        // The client will send messages to destinations like "/app/chat"
        config.setApplicationDestinationPrefixes("/app");
    }

    @Override
    public void registerStompEndpoints(StompEndpointRegistry registry) {
        // This is the endpoint the client (Flutter app) will connect to.
        // e.g., ws://<your-server>/ws-sync
        // We allow all origins for now ("*") - can be locked down later.
        registry.addEndpoint("/ws-sync").setAllowedOriginPatterns("*").withSockJS();
    }
}