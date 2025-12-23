package com.example.demo.dto;

public class TaskDto {
    private String taskName;
    private String taskMonth;
    private Integer taskYear;

    public TaskDto(String taskName, String taskMonth, Integer taskYear) {
        this.taskName = taskName;
        this.taskMonth = taskMonth;
        this.taskYear = taskYear;
    }

    public String getTaskName() {
        return taskName;
    }

    public String getTaskMonth() {
        return taskMonth;
    }

    public Integer getTaskYear() {
        return taskYear;
    }
}
