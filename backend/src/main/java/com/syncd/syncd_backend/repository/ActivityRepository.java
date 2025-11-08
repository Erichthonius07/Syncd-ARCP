package com.syncd.syncd_backend.repository;

import com.syncd.syncd_backend.model.ActivityItem;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;
import java.util.List;

@Repository
public interface ActivityRepository extends JpaRepository<ActivityItem, Long> {
    List<ActivityItem> findByUsernameOrderByTimestampDesc(String username);
}
