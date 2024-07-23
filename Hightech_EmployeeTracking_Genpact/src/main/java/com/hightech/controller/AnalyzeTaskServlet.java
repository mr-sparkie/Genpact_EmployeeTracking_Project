package com.hightech.controller;

import java.io.IOException;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

import com.google.gson.JsonObject;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

//@WebServlet("/analyzeTasks")
public class AnalyzeTaskServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        Connection con = null;
        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
        } catch (ClassNotFoundException e) {
            e.printStackTrace();
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Database driver not found");
            return;
        }

        try {
            String id = request.getParameter("id");
            int userId = Integer.parseInt(id);

            con = DriverManager.getConnection("jdbc:mysql://localhost:3306/tracking", "root", "frozen");

            List<List<Object>> monthlyData = getTaskData(con, userId, "MONTH");
            List<List<Object>> weeklyData = getTaskData(con, userId, "WEEK");
            JsonObject pieData = getPieChartData(con, userId);
            List<List<Object>> incompleteTasks = getIncompleteTasks(con, userId);

            request.setAttribute("monthlyData", monthlyData);
            request.setAttribute("weeklyData", weeklyData);
            request.setAttribute("pieData", pieData);
            request.setAttribute("incompleteTasks", incompleteTasks);
            request.getRequestDispatcher("chart.jsp").forward(request, response);

        } catch (SQLException e) {
            e.printStackTrace();
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Database error");
        } finally {
            if (con != null) {
                try {
                    con.close();
                } catch (SQLException e) {
                    e.printStackTrace();
                }
            }
        }
    }

    private List<List<Object>> getTaskData(Connection con, int userId, String periodType) throws SQLException {
        String sql;
        if (periodType.equals("MONTH")) {
            sql = "SELECT DATE_FORMAT(date, '%Y-%m') as period, SUM(duration) as duration " +
                  "FROM tasks WHERE user_id = ? GROUP BY DATE_FORMAT(date, '%Y-%m')";
        } else {
            sql = "SELECT DATE_FORMAT(date, '%Y-%u') as period, SUM(duration) as duration " +
                  "FROM tasks WHERE user_id = ? GROUP BY DATE_FORMAT(date, '%Y-%u')";
        }

        try (PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, userId);
            try (ResultSet rs = ps.executeQuery()) {
                List<List<Object>> taskList = new ArrayList<>();
                while (rs.next()) {
                    List<Object> taskData = new ArrayList<>();
                    taskData.add(rs.getString("period")); // period in 'YYYY-MM' or 'YYYY-WW'
                    taskData.add(rs.getDouble("duration"));
                    taskList.add(taskData);
                }
                return taskList;
            }
        }
    }

    private JsonObject getPieChartData(Connection con, int userId) throws SQLException {
        String sql = "SELECT COUNT(*) AS count, is_completed FROM tasks t " +
                     "INNER JOIN task_status ts ON t.task_id = ts.task_id " +
                     "WHERE t.user_id = ? GROUP BY ts.is_completed";
        try (PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, userId);
            try (ResultSet rs = ps.executeQuery()) {
                JsonObject jsonObject = new JsonObject();
                while (rs.next()) {
                    boolean completed = rs.getBoolean("is_completed");
                    int count = rs.getInt("count");
                    jsonObject.addProperty(completed ? "Completed" : "Not Completed", count);
                }
                return jsonObject;
            }
        }
    }

    private List<List<Object>> getIncompleteTasks(Connection con, int userId) throws SQLException {
        String sql = "SELECT t.project, t.task_category, t.end_time, t.date " +
                     "FROM tasks t " +
                     "INNER JOIN task_status ts ON t.task_id = ts.task_id " +
                     "WHERE t.user_id = ? AND ts.is_completed = 0";
        try (PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, userId);
            try (ResultSet rs = ps.executeQuery()) {
                List<List<Object>> tasks = new ArrayList<>();
                while (rs.next()) {
                    List<Object> taskData = new ArrayList<>();
                    taskData.add(rs.getString("project"));
                    taskData.add(rs.getString("task_category"));
                    taskData.add(rs.getString("end_time"));
                    taskData.add(rs.getString("date"));
                    tasks.add(taskData);
                }
                return tasks;
            }
        }
    }
}
