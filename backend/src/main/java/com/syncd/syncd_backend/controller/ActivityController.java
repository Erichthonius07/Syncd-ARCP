package com.syncd.syncd_backend.controller;

import com.syncd.syncd_backend.model.Activity;
import com.syncd.syncd_backend.service.ActivityService;
import org.springframework.web.bind.annotation.*;

import java.util.List;
@RestController
@RequestMapping("/api/activity")
@CrossOrigin(origins = "*")
public class ActivityController {
    private final ActivityService service;
    public ActivityController(ActivityService service) {
        this.service = service;
    }

    @GetMapping
    public List<Activity> getActivities(@RequestParam String username) {
        return service.getActivitiesForUser(username);
    }

    @PostMapping("/add")
    public Activity addActivity(@RequestParam String username, @RequestParam String message) {
        return service.addActivity(username, message);
    }

    @DeleteMapping("/all")
    public void clearActivities(@RequestParam String username) {
        service.clearActivities(username);
    }
}