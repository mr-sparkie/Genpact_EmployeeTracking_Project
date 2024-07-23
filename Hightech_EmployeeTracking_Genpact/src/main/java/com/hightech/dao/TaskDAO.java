package com.hightech.dao;

import com.hightech.bean.Task;
import com.hightech.util.DbUtil;

import java.math.BigDecimal;
import java.sql.*;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.List;

public class TaskDAO {

    public String addTask(int userId, String project, String dateStr, String startTimeStr, String endTimeStr,
                          String taskCategory, String description) {

        SimpleDateFormat dateTimeFormat = new SimpleDateFormat("yyyy-MM-dd HH:mm");

        try {
            // Parse date and time strings
            java.util.Date parsedDate = dateTimeFormat.parse(dateStr + " " + startTimeStr);
            java.util.Date parsedEndDate = dateTimeFormat.parse(dateStr + " " + endTimeStr);

            // Calculate duration
            long durationInMillis = parsedEndDate.getTime() - parsedDate.getTime();
            BigDecimal duration = BigDecimal.valueOf(durationInMillis / (60.0 * 60.0 * 1000.0)); // Convert to hours

            // Check if duration exceeds 8 hours
            if (duration.compareTo(BigDecimal.valueOf(8)) > 0) {
                return "Cannot add task. Maximum duration exceeded (8 hours).";
            }

            try (Connection conn = DbUtil.getConnection();
                 PreparedStatement stmt = conn.prepareStatement(
                         "INSERT INTO tasks (user_id, project, date, start_time, end_time, duration, task_category, description) " +
                                 "VALUES (?, ?, ?, ?, ?, ?, ?, ?)")) {

                Timestamp startTimestamp = new Timestamp(parsedDate.getTime());
                Timestamp endTimestamp = new Timestamp(parsedEndDate.getTime());

                stmt.setInt(1, userId);
                stmt.setString(2, project);
                stmt.setDate(3, new java.sql.Date(parsedDate.getTime()));
                stmt.setTimestamp(4, startTimestamp);
                stmt.setTimestamp(5, endTimestamp);
                stmt.setBigDecimal(6, duration);
                stmt.setString(7, taskCategory);
                stmt.setString(8, description);

                int rowsInserted = stmt.executeUpdate();
                if (rowsInserted > 0) {
                    return "success";
                } else {
                    return "Failed to add task";
                }

            } catch (SQLException ex) {
                ex.printStackTrace();
                return "Database error: " + ex.getMessage();
            }

        } catch (ParseException ex) {
            ex.printStackTrace();
            return "Date/time format error: " + ex.getMessage();
        }
    }

    public List<Task> getAllTasks() {
        List<Task> taskList = new ArrayList<>();

        try (Connection conn = DbUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement("SELECT * FROM tasks");
             ResultSet rs = stmt.executeQuery()) {

            while (rs.next()) {
                Task task = new Task();
                task.setTaskId(rs.getInt("task_id"));
                task.setUserId(rs.getInt("user_id"));
                task.setProject(rs.getString("project"));
                task.setDate(rs.getTimestamp("date"));
                task.setStartTime(rs.getTimestamp("start_time"));
                task.setEndTime(rs.getTimestamp("end_time"));
                task.setDuration(rs.getBigDecimal("duration"));
                task.setTaskCategory(rs.getString("task_category"));
                task.setDescription(rs.getString("description"));

                taskList.add(task);
            }

        } catch (SQLException ex) {
            ex.printStackTrace();
        }

        return taskList;
    }

    public boolean updateTask(Task task) {
        try (Connection conn = DbUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(
                     "UPDATE tasks SET project = ?, date = ?, start_time = ?, end_time = ?, duration = ?, task_category = ?, description = ? " +
                             "WHERE task_id = ?")) {

            stmt.setString(1, task.getProject());
            stmt.setTimestamp(2, task.getDate());
            stmt.setTimestamp(3, task.getStartTime());
            stmt.setTimestamp(4, task.getEndTime());
            stmt.setBigDecimal(5, task.getDuration());
            stmt.setString(6, task.getTaskCategory());
            stmt.setString(7, task.getDescription());
            stmt.setInt(8, task.getTaskId());

            int rowsUpdated = stmt.executeUpdate();
            return rowsUpdated > 0;

        } catch (SQLException ex) {
            ex.printStackTrace();
            return false;
        }
    }

    public boolean deleteTask(int taskId) {
        try (Connection conn = DbUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement("DELETE FROM tasks WHERE task_id = ?")) {

            stmt.setInt(1, taskId);

            int rowsDeleted = stmt.executeUpdate();
            return rowsDeleted > 0;

        } catch (SQLException ex) {
            ex.printStackTrace();
            return false;
        }
    }

    public Task getTaskById(int taskId) {
        Task task = null;

        try (Connection conn = DbUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement("SELECT * FROM tasks WHERE task_id = ?")) {

            stmt.setInt(1, taskId);
            ResultSet rs = stmt.executeQuery();

            if (rs.next()) {
                task = new Task();
                task.setTaskId(rs.getInt("task_id"));
                task.setUserId(rs.getInt("user_id"));
                task.setProject(rs.getString("project"));
                task.setDate(rs.getTimestamp("date"));
                task.setStartTime(rs.getTimestamp("start_time"));
                task.setEndTime(rs.getTimestamp("end_time"));
                task.setDuration(rs.getBigDecimal("duration"));
                task.setTaskCategory(rs.getString("task_category"));
                task.setDescription(rs.getString("description"));
            }

        } catch (SQLException ex) {
            ex.printStackTrace();
        }

        return task;
    }
}
