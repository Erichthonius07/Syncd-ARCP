package com.syncd.syncd_backend.config;

import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.security.config.annotation.web.builders.HttpSecurity;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.security.web.SecurityFilterChain;
import org.springframework.security.config.http.SessionCreationPolicy;

@Configuration
public class SecurityConfig {

    @Bean
    public SecurityFilterChain filterChain(HttpSecurity http) throws Exception {
        http
            // Disable CSRF (common for REST APIs)
            .csrf(csrf -> csrf.disable())
            
            // Configure URL permissions
            .authorizeHttpRequests(auth -> auth
                // Allow everyone to access Login/Register
                .requestMatchers("/api/auth/**").permitAll()
                // Allow WebSocket handshake
                .requestMatchers("/ws-sync/**").permitAll()
                // Require auth for everything else
                .anyRequest().authenticated()
            )
            
            // Use Stateless session (JWT style)
            .sessionManagement(session -> session
                .sessionCreationPolicy(SessionCreationPolicy.STATELESS)
            );

        return http.build();
    }

    @Bean
    public BCryptPasswordEncoder passwordEncoder() {
        return new BCryptPasswordEncoder();
    }
}