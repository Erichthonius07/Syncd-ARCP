package com.syncd.syncd_backend.repository;

import com.syncd.syncd_backend.model.User;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Optional;

@Repository
public interface UserRepository extends JpaRepository<User, String> {

    // Used for Login
    Optional<User> findByUsername(String username);

    // Used for Registration checks
    Boolean existsByUsername(String username);
    Boolean existsByEmail(String email);

    // NEW: Search for users by partial username (case-insensitive is better UX)
    List<User> findByUsernameContainingIgnoreCase(String query);
}