package com.syncd.syncd_backend.service;

import com.syncd.syncd_backend.model.Lobby;
import com.syncd.syncd_backend.repository.LobbyRepository;
import org.apache.commons.lang3.RandomStringUtils;
import org.springframework.stereotype.Service;

@Service
public class LobbyService {

    private final LobbyRepository lobbyRepository;

    public LobbyService(LobbyRepository lobbyRepository) {
        this.lobbyRepository = lobbyRepository;
    }

    /**
     * Creates a new lobby and generates a unique game code.
     */
    public Lobby createLobby(String hostUsername) {
        Lobby lobby = new Lobby();
        lobby.setHostUsername(hostUsername);
        lobby.getParticipants().add(hostUsername);
        lobby.setGameCode(generateUniqueGameCode());
        return lobbyRepository.save(lobby);
    }

    /**
     * Allows a user to join an existing lobby.
     */
    public Lobby joinLobby(String gameCode, String participantUsername) {
        Lobby lobby = lobbyRepository.findByGameCode(gameCode)
                .orElseThrow(() -> new IllegalArgumentException("Lobby not found"));

        if (lobby.isGameStarted()) {
            throw new IllegalStateException("Game has already started");
        }

        lobby.getParticipants().add(participantUsername);
        return lobbyRepository.save(lobby);
    }

    /**
     * Generates a unique 4-character alphanumeric code.
     */
    private String generateUniqueGameCode() {
        String code;
        do {
            code = RandomStringUtils.randomAlphanumeric(4).toUpperCase();
        } while (lobbyRepository.existsByGameCode(code));
        return code;
    }
}