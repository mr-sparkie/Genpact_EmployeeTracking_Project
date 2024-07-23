package com.hightech.dao;

import com.hightech.bean.Task;
import com.hightech.dao.exception.CustomDAOException;
import com.hightech.util.DbUtil;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class TaskDAOImpl implements TaskDAO {

    @Override
    public List<Task> getAllTasks() throws SQLException {
        List<Task> tasks = new ArrayList<>();
        String query = "SELECT * FROM tasks";

        try (Connection connection = DbUtil.getConnection();
             Statement statement = connection.createStatement();
             ResultSet rs = statement.executeQuery(query)) {

            while (rs.next()) {
                Task task = new Task();
                task.setTaskId(rs.getInt("task_id"));
                task.setUserId(rs.getInt("user_id"));
                task.setProject(rs.getString("project"));
                task.setDate(rs.getDate("date"));
                task.setStartTime(rs.getTime("start_time"));
                task.setEndTime(rs.getTime("end_time"));
                task.setDuration(rs.getDouble("duration"));
                task.setTaskCategory(rs.getString("task_category"));
                task.setDescription(rs.getString("description"));
                tasks.add(task);
            }
        }

        return tasks;
    }

    @Override
    public boolean addTask(Task task) throws SQLException {
        String query = "INSERT INTO tasks (user_id, project, date, start_time, end_time, duration, task_category, description) VALUES (?, ?, ?, ?, ?, ?, ?, ?)";

        try (Connection connection = DbUtil.getConnection();
             PreparedStatement ps = connection.prepareStatement(query)) {

            ps.setInt(1, task.getUserId());
            ps.setString(2, task.getProject());
            ps.setDate(3, task.getDate());
            ps.setTime(4, task.getStartTime());
            ps.setTime(5, task.getEndTime());
            ps.setDouble(6, task.getDuration());
            ps.setString(7, task.getTaskCategory());
            ps.setString(8, task.getDescription());
            ps.executeUpdate();
        }
		return false;
    }

    @Override
    public void updateTask(Task task) throws SQLException {
        String query = "UPDATE tasks SET user_id = ?, project = ?, date = ?, start_time = ?, end_time = ?, duration = ?, task_category = ?, description = ? WHERE task_id = ?";

        try (Connection connection = DbUtil.getConnection();
             PreparedStatement ps = connection.prepareStatement(query)) {

            ps.setInt(1, task.getUserId());
            ps.setString(2, task.getProject());
            ps.setDate(3, task.getDate());
            ps.setTime(4, task.getStartTime());
            ps.setTime(5, task.getEndTime());
            ps.setDouble(6, task.getDuration());
            ps.setString(7, task.getTaskCategory());
            ps.setString(8, task.getDescription());
            ps.setInt(9, task.getTaskId());
            ps.executeUpdate();
        }
    }

    @Override
    public boolean deleteTask(int taskId) throws SQLException {
        String query = "DELETE FROM tasks WHERE task_id = ?";

        try (Connection connection = DbUtil.getConnection();
             PreparedStatement ps = connection.prepareStatement(query)) {

            ps.setInt(1, taskId);
            ps.executeUpdate();
        }
		return false;
    }

    @Override
    public boolean isTimeOverlap(Task task) throws SQLException {
        String query = "SELECT COUNT(*) FROM tasks WHERE user_id = ? AND date = ? AND ((start_time BETWEEN ? AND ?) OR (end_time BETWEEN ? AND ?) OR (? BETWEEN start_time AND end_time) OR (? BETWEEN start_time AND end_time))";

        try (Connection connection = DbUtil.getConnection();
             PreparedStatement ps = connection.prepareStatement(query)) {

            ps.setInt(1, task.getUserId());
            ps.setDate(2, task.getDate());
            ps.setTime(3, task.getStartTime());
            ps.setTime(4, task.getEndTime());
            ps.setTime(5, task.getStartTime());
            ps.setTime(6, task.getEndTime());
            ps.setTime(7, task.getStartTime());
            ps.setTime(8, task.getEndTime());

            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt(1) > 0;
                }
            }
        }

        return false;
    }

	@Override
	public Task getTaskById(int taskId) throws CustomDAOException {
		// TODO Auto-generated method stub
		return null;
	}

	@Override
	public List<Task> getTasksByUserId(int userId) throws CustomDAOException {
		// TODO Auto-generated method stub
		return null;
	}
}
