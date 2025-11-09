package com.syncd.syncd_backend.controller;

import com.syncd.syncd_backend.model.Lobby;
import com.syncd.syncd_backend.service.LobbyService;
import org.springframework.web.bind.annotation.*;

@RestController
@RequestMapping("/api/lobby")
@CrossOrigin(origins = "*")
public class LobbyController {

    private final LobbyService lobbyService;

    public LobbyController(LobbyService lobbyService) {
        this.lobbyService = lobbyService;
    }

    @PostMapping("/create")
    public Lobby createLobby(@RequestParam String hostUsername) {
        return lobbyService.createLobby(hostUsername);
    }

    @PostMapping("/join")
    public Lobby joinLobby(@RequestParam String gameCode, @RequestParam String participantUsername) {
        return lobbyService.joinLobby(gameCode, participantUsername);
    }
}