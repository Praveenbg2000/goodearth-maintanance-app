package com.example.demo.repository;

import java.util.List;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import com.example.demo.model.TaskStep;

@Repository
public interface TaskStepRepository extends JpaRepository<TaskStep, Long> {

    // Fetch all steps for a given task
    List<TaskStep> findByTask_TaskId(Long taskId);
    void deleteByTask_TaskId(Long taskId);
}
