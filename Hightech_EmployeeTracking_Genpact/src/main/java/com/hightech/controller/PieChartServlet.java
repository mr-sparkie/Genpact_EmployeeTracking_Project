package com.hightech.controller;

import java.io.IOException;
import java.io.PrintWriter;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

import com.google.gson.JsonObject;
import com.hightech.util.DbUtil;

import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

public class PieChartServlet extends HttpServlet {
    
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        response.setContentType("application/json");
        PrintWriter out = response.getWriter();

        Connection conn = null;
        PreparedStatement stmt = null;
        ResultSet rs = null;
        
        try {
            conn = DbUtil.getConnection(); // Replace with your method to get DB connection
            stmt = conn.prepareStatement("SELECT COUNT(*) AS count, is_completed FROM task_status GROUP BY is_completed");
            rs = stmt.executeQuery();
            
            // Create a JSON object to hold chart data
            JsonObject jsonObject = new JsonObject();
            
            while (rs.next()) {
                boolean completed = rs.getBoolean("is_completed");
                int count = rs.getInt("count");
                jsonObject.addProperty(completed ? "Completed" : "Not Completed", count);
            }
            
            out.println(jsonObject.toString());
            
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            // Close resources
            try {
                if (rs != null) rs.close();
                if (stmt != null) stmt.close();
                if (conn != null) conn.close();
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }
    }
}
