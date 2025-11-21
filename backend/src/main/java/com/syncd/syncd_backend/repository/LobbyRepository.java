package com.syncd.syncd_backend.repository;

import com.syncd.syncd_backend.model.Lobby;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.Optional;

public interface LobbyRepository extends JpaRepository<Lobby, Long> {
    Optional<Lobby> findByGameCode(String gameCode);
    boolean existsByGameCode(String gameCode);
}