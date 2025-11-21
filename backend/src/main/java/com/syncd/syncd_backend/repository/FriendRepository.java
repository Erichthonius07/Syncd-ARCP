package com.syncd.syncd_backend.repository;

import com.syncd.syncd_backend.model.FriendRequest;
import org.springframework.data.jpa.repository.JpaRepository;

public interface FriendRepository extends JpaRepository<FriendRequest, Long> {
}