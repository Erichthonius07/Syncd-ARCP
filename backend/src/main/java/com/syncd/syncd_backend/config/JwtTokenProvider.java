package com.syncd.syncd_backend.config;

import io.jsonwebtoken.*;
import io.jsonwebtoken.security.Keys;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.stereotype.Component;

import java.security.Key;
import java.util.Date;

@Component
public class JwtTokenProvider {

    // In production, store this in application.properties!
    // It must be at least 32 characters long for HS256.
    private static final String JWT_SECRET = "SyncdSecretKeyForGameAuthenticationV2Point1";

    // Token validity: 7 days (in milliseconds)
    private static final int JWT_EXPIRATION_MS = 604800000; 

    private final Key key = Keys.hmacShaKeyFor(JWT_SECRET.getBytes());

    // --- 1. GENERATE TOKEN ---
    public String generateToken(UserDetails userDetails) {
        Date now = new Date();
        Date expiryDate = new Date(now.getTime() + JWT_EXPIRATION_MS);

        return Jwts.builder()
                .setSubject(userDetails.getUsername())
                .setIssuedAt(new Date())
                .setExpiration(expiryDate)
                .signWith(key, SignatureAlgorithm.HS256)
                .compact();
    }

    // --- 2. GET USERNAME FROM TOKEN ---
    public String getUsernameFromJWT(String token) {
        Claims claims = Jwts.parserBuilder()
                .setSigningKey(key)
                .build()
                .parseClaimsJws(token)
                .getBody();

        return claims.getSubject();
    }

    // --- 3. VALIDATE TOKEN ---
    public boolean validateToken(String authToken) {
        try {
            Jwts.parserBuilder().setSigningKey(key).build().parseClaimsJws(authToken);
            return true;
        } catch (JwtException | IllegalArgumentException e) {
            // Invalid token
        }
        return false;
    }
}