package com.syncd.syncd_backend.controller;

import com.syncd.syncd_backend.model.ActivityItem;
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
    public List<ActivityItem> getActivities(@RequestParam("username") String username) {
        return service.getActivities(username);
    }

    @PostMapping("/add")
    public ActivityItem add(@RequestParam("username") String username,
                            @RequestParam("message") String message) {
        return service.addActivity(username, message);
    }

    @DeleteMapping("/all")
    public String clearAll(@RequestParam("username") String username) {
        service.clearAll(username);
        return "Cleared all activity items";
    }
}
