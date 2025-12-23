package com.example.demo.model;

import java.time.LocalDateTime;

import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.GeneratedValue;
import javax.persistence.GenerationType;
import javax.persistence.Id;
import javax.persistence.PrePersist;
import javax.persistence.Table;

@Entity
@Table(name = "user_tasks")
public class UserTask {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Column(name = "task_name")
    private String taskName;

    @Column(name = "home_name")
    private String homeName;

    @Column(name = "user_id")
    private Long userId;

    @Column(name = "added_user_id")
    private Long addedUserId;

    // 🆕 New column for task completion timestamp
    @Column(name = "task_done_date", columnDefinition = "DATETIME DEFAULT CURRENT_TIMESTAMP")
    private LocalDateTime taskDoneDate;
    
    @Column(name = "task_month")
    private String taskMonth;

    @Column(name = "task_year")
    private Integer taskYear;


    public String getTaskMonth() {
		return taskMonth;
	}

	public void setTaskMonth(String taskMonth) {
		this.taskMonth = taskMonth;
	}

	public Integer getTaskYear() {
		return taskYear;
	}

	public void setTaskYear(Integer taskYear) {
		this.taskYear = taskYear;
	}

	// ✅ Automatically set current timestamp when new task is created
    @PrePersist
    protected void onCreate() {
        this.taskDoneDate = LocalDateTime.now();
    }

    // ---------- Getters and Setters ----------

    public Long getId() {
        return id;
    }

    public void setId(Long id) {
        this.id = id;
    }

    public String getTaskName() {
        return taskName;
    }

    public void setTaskName(String taskName) {
        this.taskName = taskName;
    }

    public String getHomeName() {
        return homeName;
    }

    public void setHomeName(String homeName) {
        this.homeName = homeName;
    }

    public Long getUserId() {
        return userId;
    }

    public void setUserId(Long userId) {
        this.userId = userId;
    }

    public Long getAddedUserId() {
        return addedUserId;
    }

    public void setAddedUserId(Long addedUserId) {
        this.addedUserId = addedUserId;
    }

    public LocalDateTime getTaskDoneDate() {
        return taskDoneDate;
    }

    public void setTaskDoneDate(LocalDateTime taskDoneDate) {
        this.taskDoneDate = taskDoneDate;
    }
}
