package com.syncd.syncd_backend.config;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.annotation.Configuration;
import org.springframework.messaging.simp.config.ChannelRegistration;
import org.springframework.messaging.simp.config.MessageBrokerRegistry;
import org.springframework.web.socket.config.annotation.EnableWebSocketMessageBroker;
import org.springframework.web.socket.config.annotation.StompEndpointRegistry;
import org.springframework.web.socket.config.annotation.WebSocketMessageBrokerConfigurer;

@Configuration
@EnableWebSocketMessageBroker
public class WebSocketConfig implements WebSocketMessageBrokerConfigurer {

    @Autowired
    private WebSocketAuthInterceptor authInterceptor; // Inject our new security guard

    @Override
    public void configureMessageBroker(MessageBrokerRegistry config) {
        // Enable simple broker for both public topics (squads) and private queues (DMs)
        config.enableSimpleBroker("/topic", "/queue");
        
        // Application destination prefix (messages sent from client to server)
        config.setApplicationDestinationPrefixes("/app");
    }

    @Override
    public void registerStompEndpoints(StompEndpointRegistry registry) {
        // This is the endpoint the client connects to
        registry.addEndpoint("/ws-sync")
                .setAllowedOriginPatterns("*") // Allow all origins for dev
                .withSockJS(); // Enable SockJS fallback
    }

    // --- NEW: Register the Auth Interceptor ---
    @Override
    public void configureClientInboundChannel(ChannelRegistration registration) {
        // This adds our interceptor to the "pipe" of incoming messages
        // It checks the JWT token before the message is processed
        registration.interceptors(authInterceptor);
    }
}