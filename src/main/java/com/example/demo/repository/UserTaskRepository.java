package com.example.demo.repository;
import java.util.List;
import java.util.Optional;

import javax.transaction.Transactional;

import org.springframework.data.jpa.repository.JpaRepository;

import com.example.demo.model.UserTask;

public interface UserTaskRepository extends JpaRepository<UserTask, Long> {
    List<UserTask> findByUserIdAndHomeName(Long userId, String homeName);
    List<UserTask> findByAddedUserIdAndHomeName(Long addedUserId, String homeName);

    Optional<UserTask> findByTaskNameAndUserIdAndHomeName(String taskName, Long userId, String homeName);
    Optional<UserTask> findByTaskNameAndAddedUserIdAndHomeName(String taskName, Long addedUserId, String homeName);

    void deleteByTaskNameAndUserIdAndHomeName(String taskName, Long userId, String homeName);
    void deleteByTaskNameAndAddedUserIdAndHomeName(String taskName, Long addedUserId, String homeName);
    @Transactional
    void deleteByUserIdAndHomeNameAndTaskName(Long userId, String homeName, String taskName);
    @Transactional
    void deleteByAddedUserIdAndHomeNameAndTaskName(Long addedUserId, String homeName, String taskName);


}