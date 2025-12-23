package com.example.demo.model;

import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.FetchType;
import javax.persistence.GeneratedValue;
import javax.persistence.GenerationType;
import javax.persistence.Id;
import javax.persistence.JoinColumn;
import javax.persistence.ManyToOne;
import javax.persistence.Table;

@Entity
@Table(name = "client_homes")
public class ClientHome {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Column(name = "home_name", nullable = false)
    private String homeName;


    @Column(name = "is_primary_home")
    private boolean primaryHome = false; // to mark one as main home

    // ✅ Relationship: Many Homes → One User
    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "user_id", nullable = false)
    private User user;

    public ClientHome() {}

    public ClientHome(String homeName, User user) {
        this.homeName = homeName;
        this.user = user;
    }

    // Getters and Setters
    public Long getId() { return id; }

    public String getHomeName() { return homeName; }
    public void setHomeName(String homeName) { this.homeName = homeName; }


    public boolean isPrimaryHome() { return primaryHome; }
    public void setPrimaryHome(boolean primaryHome) { this.primaryHome = primaryHome; }

    public User getUser() { return user; }
    public void setUser(User user) { this.user = user; }
}
