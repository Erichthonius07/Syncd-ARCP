package com.syncd.syncd_backend.model;

import jakarta.persistence.*;
import java.util.ArrayList;
import java.util.List;
import java.util.UUID;

@Entity
@Table(name = "squads")
public class Squad {

    @Id
    private String id;

    private String name; // e.g., "The Boys"
    private String creatorId; // The ID of the squad leader

    @ElementCollection(fetch = FetchType.EAGER)
    private List<String> memberIds = new ArrayList<>();

    // --- CONSTRUCTOR ---
    public Squad() {
        this.id = UUID.randomUUID().toString();
    }

    public Squad(String name, String creatorId) {
        this.id = UUID.randomUUID().toString();
        this.name = name;
        this.creatorId = creatorId;
        this.memberIds.add(creatorId); // Creator is automatically a member
    }

    // --- GETTERS & SETTERS ---
    public String getId() { return id; }
    public void setId(String id) { this.id = id; }

    public String getName() { return name; }
    public void setName(String name) { this.name = name; }

    public String getCreatorId() { return creatorId; }
    public void setCreatorId(String creatorId) { this.creatorId = creatorId; }

    public List<String> getMemberIds() { return memberIds; }
    public void setMemberIds(List<String> memberIds) { this.memberIds = memberIds; }
    
    public void addMember(String userId) {
        if (!this.memberIds.contains(userId)) {
            this.memberIds.add(userId);
        }
    }

    public void removeMember(String userId) {
        this.memberIds.remove(userId);
    }
}