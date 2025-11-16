package com.syncd.syncd_backend.service;

import com.syncd.syncd_backend.config.JwtTokenProvider; // 1. IMPORT
import com.syncd.syncd_backend.model.User;
import com.syncd.syncd_backend.repository.UserRepository;
import org.springframework.beans.factory.annotation.Autowired; // 2. IMPORT
import org.springframework.security.core.userdetails.UserDetails; // 3. IMPORT
import org.springframework.security.core.userdetails.UserDetailsService; // 4. IMPORT
import org.springframework.security.core.userdetails.UsernameNotFoundException; // 5. IMPORT
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.stereotype.Service;
import java.util.ArrayList; // 6. IMPORT
import java.util.Optional;

@Service
// 7. IMPLEMENT UserDetailsService
public class UserService implements UserDetailsService {

    @Autowired // 8. INJECT JwtTokenProvider
    private JwtTokenProvider tokenProvider;

    private final UserRepository userRepository;
    private final BCryptPasswordEncoder passwordEncoder;

    public UserService(UserRepository userRepository) {
        this.userRepository = userRepository;
        this.passwordEncoder = new BCryptPasswordEncoder();
    }

    public String register(User user) {
        // ... (this method is unchanged)
        if (userRepository.existsByUsername(user.getUsername())) {
            return "Username already exists!";
        }
        if (userRepository.existsByEmail(user.getEmail())) {
            return "Email already registered!";
        }

        user.setPassword(passwordEncoder.encode(user.getPassword()));
        userRepository.save(user);
        return "User registered successfully!";
    }

    /**
     * UPDATED: Now returns a JWT Token on successful login.
     */
    public String login(String username, String password) {
        Optional<User> existingUser = userRepository.findByUsername(username);
        if (existingUser.isPresent()) {
            if (passwordEncoder.matches(password, existingUser.get().getPassword())) {
                
                // 9. CREATE UserDetails for token generation
                UserDetails userDetails = loadUserByUsername(username);
                
                // 10. RETURN the token
                return tokenProvider.generateToken(userDetails);
            } else {
                return "Invalid password!";
            }
        }
        return "User not found!";
    }
    
    /**
     * NEW: Required by UserDetailsService.
     * This method loads a user for Spring Security.
     */
    @Override
    public UserDetails loadUserByUsername(String username) throws UsernameNotFoundException {
        User user = userRepository.findByUsername(username)
                .orElseThrow(() -> new UsernameNotFoundException("User not found: " + username));

        return new org.springframework.security.core.userdetails.User(
                user.getUsername(),
                user.getPassword(),
                new ArrayList<>() // No roles for now
        );
    }
}