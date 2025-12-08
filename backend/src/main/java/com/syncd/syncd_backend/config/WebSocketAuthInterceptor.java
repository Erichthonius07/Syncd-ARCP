package com.syncd.syncd_backend.config;

import com.syncd.syncd_backend.service.UserService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.messaging.Message;
import org.springframework.messaging.MessageChannel;
import org.springframework.messaging.simp.stomp.StompCommand;
import org.springframework.messaging.simp.stomp.StompHeaderAccessor;
import org.springframework.messaging.support.ChannelInterceptor;
import org.springframework.messaging.support.MessageHeaderAccessor;
import org.springframework.security.authentication.UsernamePasswordAuthenticationToken;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.stereotype.Component;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

@Component
public class WebSocketAuthInterceptor implements ChannelInterceptor {

    private static final Logger logger = LoggerFactory.getLogger(WebSocketAuthInterceptor.class);

    @Autowired
    private JwtTokenProvider tokenProvider;

    @Autowired
    private UserService userService;

    @Override
    public Message<?> preSend(Message<?> message, MessageChannel channel) {
        StompHeaderAccessor accessor =
                MessageHeaderAccessor.getAccessor(message, StompHeaderAccessor.class);

        if (accessor != null && StompCommand.CONNECT.equals(accessor.getCommand())) {
            
            // 1. Get the "Authorization" header from the STOMP CONNECT message
            String authHeader = accessor.getFirstNativeHeader("Authorization");
            logger.info("🔍 WebSocket CONNECT attempt - Authorization header: {}", authHeader != null ? "Present" : "Missing");
            
            if (authHeader != null && authHeader.startsWith("Bearer ")) {
                try {
                    String jwt = authHeader.substring(7);
                    logger.info("🔐 Validating JWT token...");

                    // 2. Validate the token
                    if (tokenProvider.validateToken(jwt)) {
                        
                        String username = tokenProvider.getUsernameFromJWT(jwt);
                        logger.info("👤 Token belongs to user: {}", username);
                        
                        // Load user details from DB to ensure user still exists
                        UserDetails userDetails = userService.loadUserByUsername(username);

                        // 3. Set the authenticated user in the security context
                        UsernamePasswordAuthenticationToken authentication =
                                new UsernamePasswordAuthenticationToken(
                                        userDetails, null, userDetails.getAuthorities());
                        
                        SecurityContextHolder.getContext().setAuthentication(authentication);

                        // 4. Associate the user with the WebSocket session
                        accessor.setUser(authentication);
                        logger.info("✅ WebSocket authentication successful for user: {}", username);
                        
                    } else {
                        logger.warn("❌ Token validation failed");
                    }
                } catch (Exception e) {
                    logger.error("❌ Error during WebSocket authentication: {}", e.getMessage(), e);
                }
            } else {
                logger.warn("❌ No valid Authorization header found in STOMP CONNECT");
            }
        }
        return message;
    }
}