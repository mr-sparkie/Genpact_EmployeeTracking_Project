package com.hightech.bean;

import java.math.BigDecimal;
import java.sql.Timestamp;

public class Task {
    private int taskId;
    private int userId;
    private String project;
    private Timestamp date;
    private Timestamp startTime;
    private Timestamp endTime;
    private BigDecimal duration;
    private String taskCategory;
    private String description;

    // Constructors, getters, and setters
    public Task() {
    }

    public Task(int taskId, int userId, String project, Timestamp date, Timestamp startTime, Timestamp endTime, BigDecimal duration, String taskCategory, String description) {
        this.taskId = taskId;
        this.userId = userId;
        this.project = project;
        this.date = date;
        this.startTime = startTime;
        this.endTime = endTime;
        this.duration = duration;
        this.taskCategory = taskCategory;
        this.description = description;
    }

    public int getTaskId() {
        return taskId;
    }

    public void setTaskId(int taskId) {
        this.taskId = taskId;
    }

    public int getUserId() {
        return userId;
    }

    public void setUserId(int userId) {
        this.userId = userId;
    }

    public String getProject() {
        return project;
    }

    public void setProject(String project) {
        this.project = project;
    }

    public Timestamp getDate() {
        return date;
    }

    public void setDate(Timestamp date) {
        this.date = date;
    }

    public Timestamp getStartTime() {
        return startTime;
    }

    public void setStartTime(Timestamp startTime) {
        this.startTime = startTime;
    }

    public Timestamp getEndTime() {
        return endTime;
    }

    public void setEndTime(Timestamp endTime) {
        this.endTime = endTime;
    }

    public BigDecimal getDuration() {
        return duration;
    }

    public void setDuration(BigDecimal duration) {
        this.duration = duration;
    }

    public String getTaskCategory() {
        return taskCategory;
    }

    public void setTaskCategory(String taskCategory) {
        this.taskCategory = taskCategory;
    }

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }

    @Override
    public String toString() {
        return "Task{" +
                "taskId=" + taskId +
                ", userId=" + userId +
                ", project='" + project + '\'' +
                ", date=" + date +
                ", startTime=" + startTime +
                ", endTime=" + endTime +
                ", duration=" + duration +
                ", taskCategory='" + taskCategory + '\'' +
                ", description='" + description + '\'' +
                '}';
    }
}
