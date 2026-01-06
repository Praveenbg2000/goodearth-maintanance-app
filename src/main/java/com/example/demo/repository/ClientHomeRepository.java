package com.example.demo.repository;

import java.util.List;

import javax.transaction.Transactional;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Modifying;

import com.example.demo.model.ClientHome;

public interface ClientHomeRepository extends JpaRepository<ClientHome, Long> {
    List<ClientHome> findByUserId(Long userId);
    boolean existsByUserIdAndHomeNameIgnoreCase(Long userId, String homeName);
    
    @Modifying
    @Transactional
    void deleteByHomeName(String homeName);
}

