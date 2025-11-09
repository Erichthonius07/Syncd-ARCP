package com.syncd.syncd_backend.service;

import com.syncd.syncd_backend.model.Activity;
import com.syncd.syncd_backend.repository.ActivityRepository;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional; // <-- 1. Import this

import java.time.LocalDateTime;
import java.util.List;

@Service
public class ActivityService {
    private final ActivityRepository activityRepository;

    public ActivityService(ActivityRepository activityRepository) {
        this.activityRepository = activityRepository;
    }

    public List<Activity> getActivitiesForUser(String username) {
        return activityRepository.findByUsername(username);
    }

    public Activity addActivity(String username, String message) {
        Activity activity = new Activity();
        activity.setUsername(username);
        activity.setMessage(message);
        activity.setTimestamp(LocalDateTime.now());
        return activityRepository.save(activity);
    }

    @Transactional // <-- 2. Add this annotation
    public void clearActivities(String username) {
        activityRepository.deleteByUsername(username);
    }
}