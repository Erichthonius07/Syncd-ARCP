package com.syncd.syncd_backend.controller;

import com.syncd.syncd_backend.model.Squad;
import com.syncd.syncd_backend.model.User;
import com.syncd.syncd_backend.repository.SquadRepository;
import com.syncd.syncd_backend.repository.UserRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;

import java.util.Optional;

@RestController
@RequestMapping("/api/squads")
public class SquadController {

    @Autowired
    private SquadRepository squadRepository;

    @Autowired
    private UserRepository userRepository;

    // POST /api/squads/create?name=MySquad&creatorId=user1
    @PostMapping("/create")
    public Squad createSquad(@RequestParam String name, @RequestParam String creatorId) {
        // 1. Create the squad
        Squad newSquad = new Squad(name, creatorId);
        
        // 2. Save squad to DB
        squadRepository.save(newSquad);

        // 3. Update the user to say they are in this squad
        Optional<User> userOpt = userRepository.findById(creatorId);
        if (userOpt.isPresent()) {
            User user = userOpt.get();
            user.setCurrentSquadId(newSquad.getId());
            userRepository.save(user);
        }

        return newSquad;
    }

    // GET /api/squads/{id}
    @GetMapping("/{id}")
    public Squad getSquad(@PathVariable String id) {
        return squadRepository.findById(id).orElse(null);
    }

    // POST /api/squads/{id}/join?userId=user2
    @PostMapping("/{id}/join")
    public Squad joinSquad(@PathVariable String id, @RequestParam String userId) {
        Optional<Squad> squadOpt = squadRepository.findById(id);
        Optional<User> userOpt = userRepository.findById(userId);

        if (squadOpt.isPresent() && userOpt.isPresent()) {
            Squad squad = squadOpt.get();
            User user = userOpt.get();

            // Logic: Add member
            squad.addMember(userId);
            squadRepository.save(squad);

            // Logic: Update user status
            user.setCurrentSquadId(squad.getId());
            userRepository.save(user);

            return squad;
        }
        throw new RuntimeException("Squad or User not found");
    }
    
    // DELETE /api/squads/{id}/leave?userId=user2
    @DeleteMapping("/{id}/leave")
    public String leaveSquad(@PathVariable String id, @RequestParam String userId) {
        Optional<Squad> squadOpt = squadRepository.findById(id);
        Optional<User> userOpt = userRepository.findById(userId);

        if (squadOpt.isPresent() && userOpt.isPresent()) {
            Squad squad = squadOpt.get();
            User user = userOpt.get();

            // Remove from squad list
            squad.removeMember(userId);
            
            // If squad is empty or creator leaves, logic can get complex. 
            // For now, if empty, delete squad.
            if (squad.getMemberIds().isEmpty()) {
                squadRepository.delete(squad);
            } else {
                squadRepository.save(squad);
            }

            // Update user
            user.setCurrentSquadId(null);
            userRepository.save(user);

            return "User left squad";
        }
        return "Error leaving squad";
    }
}