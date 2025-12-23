package com.example.demo.model;

import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.GeneratedValue;
import javax.persistence.GenerationType;
import javax.persistence.Id;
import javax.persistence.JoinColumn;
import javax.persistence.ManyToOne;
import javax.persistence.Table;

@Entity
@Table(name = "added_users")
public class AddedUser {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    private String name;
    private String email;
    private String phone;
    private String relationship;

    @Column(name = "profile_photo")
    private String profilePhoto;

    @ManyToOne
    @JoinColumn(name = "owner_id")
    private User owner;

    public AddedUser() {}

    public AddedUser(Long id, String name, String email, String phone, String relationship, String profilePhoto, User owner) {
        this.id = id;
        this.name = name;
        this.email = email;
        this.phone = phone;
        this.relationship = relationship;
        this.profilePhoto = profilePhoto;
        this.owner = owner;
    }

    // ✅ Getters and Setters
    public Long getId() { return id; }
    public void setId(Long id) { this.id = id; }

    public String getName() { return name; }
    public void setName(String name) { this.name = name; }

    public String getEmail() { return email; }
    public void setEmail(String email) { this.email = email; }

    public String getPhone() { return phone; }
    public void setPhone(String phone) { this.phone = phone; }

    public String getRelationship() { return relationship; }
    public void setRelationship(String relationship) { this.relationship = relationship; }

    public String getProfilePhoto() { return profilePhoto; }
    public void setProfilePhoto(String profilePhoto) { this.profilePhoto = profilePhoto; }

    public User getOwner() { return owner; }
    public void setOwner(User owner) { this.owner = owner; }

    // ✅ Correct implementation to get the owner’s ID safely
    public Long getOwnerId() {
        return (owner != null) ? owner.getId() : null;
    }

    @Override
    public String toString() {
        return "AddedUser{" +
                "id=" + id +
                ", name='" + name + '\'' +
                ", email='" + email + '\'' +
                ", phone='" + phone + '\'' +
                ", relationship='" + relationship + '\'' +
                ", profilePhoto='" + profilePhoto + '\'' +
                ", owner=" + (owner != null ? owner.getId() : "null") +
                '}';
    }
}
