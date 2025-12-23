package com.example.demo.repository;

import java.util.List;

import org.springframework.data.jpa.repository.JpaRepository;

import com.example.demo.model.UserTaskProgress;

public interface UserTaskProgressRepository extends JpaRepository<UserTaskProgress, Long> {
    List<UserTaskProgress> findByUserIdAndHomeName(Long userId, String homeName);
    UserTaskProgress findByUserIdAndHomeNameAndTaskId(Long userId, String homeName, Long taskId);
}
