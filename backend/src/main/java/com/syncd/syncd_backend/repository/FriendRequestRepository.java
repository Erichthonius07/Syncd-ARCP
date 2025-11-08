package com.syncd.syncd_backend.repository;

import com.syncd.syncd_backend.model.FriendRequest;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface FriendRequestRepository extends JpaRepository<FriendRequest, Long> {
    List<FriendRequest> findByReceiverAndStatus(String receiver, String status);
    List<FriendRequest> findBySenderOrReceiverAndStatus(String sender, String receiver, String status);
}
