package com.example.demo.repository;

import java.util.Optional;

import javax.transaction.Transactional;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Modifying;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;

import com.example.demo.model.User;

public interface UserRepository extends JpaRepository<User, Long> {
    Optional<User> findByEmail(String email);
    
    @Modifying
    @Transactional
    @Query("update User u set u.suspended = :status where u.email = :email")
    void updateSuspendStatus(@Param("email") String email,
                             @Param("status") boolean status);
}
