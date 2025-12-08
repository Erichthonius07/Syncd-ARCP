package com.syncd.syncd_backend.repository;

import com.syncd.syncd_backend.model.Squad;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface SquadRepository extends JpaRepository<Squad, String> {
    // Find squads created by a specific user
    List<Squad> findByCreatorId(String creatorId);
}