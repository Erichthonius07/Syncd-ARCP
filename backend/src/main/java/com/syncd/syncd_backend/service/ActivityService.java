package com.syncd.syncd_backend.service;

import com.syncd.syncd_backend.model.ActivityItem;
import com.syncd.syncd_backend.repository.ActivityRepository;
import org.springframework.stereotype.Service;
import java.util.List;

@Service
public class ActivityService {
    private final ActivityRepository repo;

    public ActivityService(ActivityRepository repo) {
        this.repo = repo;
    }

    public List<ActivityItem> getActivities(String username) {
        return repo.findByUsernameOrderByTimestampDesc(username);
    }

    public ActivityItem addActivity(String username, String message) {
        ActivityItem a = new ActivityItem(username, message);
        return repo.save(a);
    }

    public void clearAll(String username) {
        List<ActivityItem> items = repo.findByUsernameOrderByTimestampDesc(username);
        repo.deleteAll(items);
    }
}
