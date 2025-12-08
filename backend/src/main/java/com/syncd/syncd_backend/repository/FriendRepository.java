package com.syncd.syncd_backend.repository;

import com.syncd.syncd_backend.model.FriendRequest;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Optional;

@Repository
public interface FriendRepository extends JpaRepository<FriendRequest, String> {
    // Check if a request already exists between two people
    Optional<FriendRequest> findBySenderIdAndReceiverId(String senderId, String receiverId);
    
    // Find pending requests FOR me (Receiver)
    List<FriendRequest> findByReceiverIdAndStatus(String receiverId, String status);
    
    // Find my friends (Accepted requests where I am sender OR receiver)
    // This is a bit complex in pure JPA method names, might need @Query usually, 
    // but for v1 we can fetch lists and filter. Or keep it simple:
    List<FriendRequest> findBySenderIdAndStatus(String senderId, String status);
}