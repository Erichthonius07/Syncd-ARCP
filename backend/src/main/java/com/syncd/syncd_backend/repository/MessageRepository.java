package com.syncd.syncd_backend.repository;

import com.syncd.syncd_backend.model.Message;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;

import java.util.List;

public interface MessageRepository extends JpaRepository<Message, Long> {

    // Find all messages between two users, in either direction
    @Query("SELECT m FROM Message m WHERE (m.senderUsername = ?1 AND m.receiverUsername = ?2) OR (m.senderUsername = ?2 AND m.receiverUsername = ?1) ORDER BY m.timestamp ASC")
    List<Message> findChatHistory(String user1, String user2);
}