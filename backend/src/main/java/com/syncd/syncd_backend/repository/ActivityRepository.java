package com.syncd.syncd_backend.repository;

import com.syncd.syncd_backend.model.Activity;
import org.springframework.data.jpa.repository.JpaRepository;
import java.util.List;

public interface ActivityRepository extends JpaRepository<Activity, Long> {
    List<Activity> findByUsername(String username);
    void deleteByUsername(String username);
}
