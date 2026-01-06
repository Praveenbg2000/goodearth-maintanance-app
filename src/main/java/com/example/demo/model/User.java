package com.example.demo.model;


import java.util.List;

import javax.persistence.CascadeType;
import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.GeneratedValue;
import javax.persistence.GenerationType;
import javax.persistence.Id;
import javax.persistence.OneToMany;
import javax.persistence.Table;

@Entity
@Table(name = "users")
public class User {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    private String username;
    private String community;
    private String homeName;
    
    private boolean suspended = false;

    public boolean isSuspended() {
		return suspended;
	}
	public void setSuspended(boolean suspended) {
		this.suspended = suspended;
	}
	@Column(unique = true)
    private String email;

    private String phone;

    // ✅ Profile photo stored as byte[] in DB
    @Column(name = "profile_photo")
    private String profilePhoto; // store only the filename


    public void setProfilePhoto(String profilePhoto) {
		this.profilePhoto = profilePhoto;
	}
	@OneToMany(mappedBy = "owner", cascade = CascadeType.ALL, orphanRemoval = true)
    private List<AddedUser> addedUsers;
	
	@OneToMany(mappedBy = "user", cascade = CascadeType.ALL, orphanRemoval = true)
	private List<ClientHome> clientHomes;

	public List<ClientHome> getClientHomes() { return clientHomes; }
	public void setClientHomes(List<ClientHome> clientHomes) { this.clientHomes = clientHomes; }


    public User() {}

    // Getters & setters
    public Long getId() { return id; }
    public void setId(Long id) { this.id = id; }

    public String getUsername() { return username; }
    public void setUsername(String username) { this.username = username; }

    public String getCommunity() { return community; }
    public void setCommunity(String community) { this.community = community; }

    public String getHomeName() { return homeName; }
    public void setHomeName(String homeName) { this.homeName = homeName; }

    public String getEmail() { return email; }
    public void setEmail(String email) { this.email = email; }

    public String getPhone() { return phone; }
    public void setPhone(String phone) { this.phone = phone; }

    public String getProfilePhoto() { return profilePhoto; }

    public List<AddedUser> getAddedUsers() { return addedUsers; }
    public void setAddedUsers(List<AddedUser> addedUsers) { this.addedUsers = addedUsers; }
}