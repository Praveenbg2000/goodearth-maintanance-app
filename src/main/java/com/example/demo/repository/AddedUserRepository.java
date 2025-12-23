package com.example.demo.repository;

import java.util.List;
import java.util.Optional;

import org.springframework.data.jpa.repository.JpaRepository;

import com.example.demo.model.AddedUser;
import com.example.demo.model.User;

public interface AddedUserRepository extends JpaRepository<AddedUser, Long> {
    Optional<AddedUser> findByEmail(String email);
    List<AddedUser> findByOwner(User owner); // ✅ FIXED
}
