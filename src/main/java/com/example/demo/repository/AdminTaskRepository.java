package com.example.demo.repository;

import org.springframework.data.jpa.repository.JpaRepository;

import com.example.demo.model.AdminTask;

public interface AdminTaskRepository extends JpaRepository<AdminTask, Long> {
}
