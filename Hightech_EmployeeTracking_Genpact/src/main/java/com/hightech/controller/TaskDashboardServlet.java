package com.hightech.controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.io.PrintWriter;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

import com.google.gson.Gson;
import com.hightech.util.DbUtil;

public class TaskDashboardServlet extends HttpServlet {

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        List<Category> categories = getTaskCategories();

        // Convert the data to JSON
        String json = new Gson().toJson(categories);

        response.setContentType("application/json");
        PrintWriter out = response.getWriter();
        out.print(json);
        out.flush();
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        int taskId = Integer.parseInt(request.getParameter("taskId"));
        boolean isCompleted = Boolean.parseBoolean(request.getParameter("isCompleted"));

        updateTaskStatus(taskId, isCompleted);

        // Return success response
        response.getWriter().write("Task status updated successfully");
    }

    private void updateTaskStatus(int taskId, boolean isCompleted) {
        try (Connection conn = DbUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(
                     "INSERT INTO task_status (task_id, is_completed) VALUES (?, ?) " +
                             "ON DUPLICATE KEY UPDATE is_completed = ?")) {
            stmt.setInt(1, taskId);
            stmt.setBoolean(2, isCompleted);
            stmt.setBoolean(3, isCompleted);
            stmt.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    private List<Category> getTaskCategories() {
        List<Category> categories = new ArrayList<>();
        try (Connection conn = DbUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(
                     "SELECT task_category, COUNT(*) as count FROM tasks GROUP BY task_category");
             ResultSet rs = stmt.executeQuery()) {
            while (rs.next()) {
                String name = rs.getString("task_category");
                int count = rs.getInt("count");
                categories.add(new Category(name, count));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return categories;
    }

    private class Category {
        private String name;
        private int count;

        public Category(String name, int count) {
            this.name = name;
            this.count = count;
        }

        public String getName() {
            return name;
        }

        public int getCount() {
            return count;
        }
    }
}
