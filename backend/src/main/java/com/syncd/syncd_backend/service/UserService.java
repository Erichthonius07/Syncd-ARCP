package com.syncd.syncd_backend.service;

import com.syncd.syncd_backend.config.JwtTokenProvider;
import com.syncd.syncd_backend.model.User;
import com.syncd.syncd_backend.repository.UserRepository;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.security.core.userdetails.UserDetailsService;
import org.springframework.security.core.userdetails.UsernameNotFoundException;
import org.springframework.security.crypto.password.PasswordEncoder; // Necessary Import
import org.springframework.stereotype.Service;
import java.util.ArrayList;
import java.util.Optional;

@Service
public class UserService implements UserDetailsService {

    private final JwtTokenProvider tokenProvider;
    private final UserRepository userRepository;
    private final PasswordEncoder passwordEncoder; // Injected Encoder (NO manual instantiation!)

    // CORRECTED CONSTRUCTOR: Spring automatically supplies the beans needed here
    public UserService(UserRepository userRepository, JwtTokenProvider tokenProvider, PasswordEncoder passwordEncoder) {
        this.userRepository = userRepository;
        this.tokenProvider = tokenProvider;
        this.passwordEncoder = passwordEncoder; 
    }
    
    // Updated register method: Hashing is done correctly here
    public String register(User user) {
        if (userRepository.existsByUsername(user.getUsername())) {
            return "Username already exists!";
        }
        if (userRepository.existsByEmail(user.getEmail())) {
            return "Email already registered!";
        }

        // HASH PASSWORD before saving using the injected encoder
        user.setPassword(passwordEncoder.encode(user.getPassword()));
        userRepository.save(user);
        return "User registered successfully!";
    }

    /**
     * UPDATED: Login logic using passwordEncoder.matches() for comparison.
     */
    public String login(String username, String password) {
        Optional<User> existingUserOpt = userRepository.findByUsername(username);
        
        if (existingUserOpt.isPresent()) {
            User existingUser = existingUserOpt.get();
            
            // CRITICAL STEP: COMPARE raw password against stored hash using the injected encoder
            if (passwordEncoder.matches(password, existingUser.getPassword())) {
                
                UserDetails userDetails = loadUserByUsername(username);
                
                // RETURN the JWT token
                return tokenProvider.generateToken(userDetails);
            } else {
                return "Invalid password!"; // Failure: Password mismatch
            }
        }
        return "User not found!"; // Failure: User not found
    }
    
    
    @Override
    public UserDetails loadUserByUsername(String username) throws UsernameNotFoundException {
        User user = userRepository.findByUsername(username)
                .orElseThrow(() -> new UsernameNotFoundException("User not found: " + username));

        return new org.springframework.security.core.userdetails.User(
                user.getUsername(),
                user.getPassword(), // The stored hash (already hashed by register/initializer)
                new ArrayList<>() 
        );
    }
}