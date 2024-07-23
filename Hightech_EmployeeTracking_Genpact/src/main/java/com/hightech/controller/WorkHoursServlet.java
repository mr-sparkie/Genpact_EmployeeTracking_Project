package com.hightech.controller;

import java.io.IOException;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

/**
 * Servlet implementation class AnalyzeTaskServlet
 */
@WebServlet("/barchart")
public class WorkHoursServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        Connection con = null;
        try {
            Class.forName("com.mysql.cj.jdbc.Driver"); // Updated driver class
        } catch (ClassNotFoundException e) {
            e.printStackTrace();
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Driver not found");
            return;
        }

        try {
            //HttpSession session = request.getSession();
            //int userId = (int) session.getAttribute("user_id");
            String id = request.getParameter("id");

            // Establish a connection
            con = DriverManager.getConnection("jdbc:mysql://localhost:3306/tracking", "root", "frozen");
            int id1 = Integer.parseInt(id);
            // SQL query updated for `tasks` table
            String sql = "SELECT MONTH(date) as month  , sum(duration) as duration from tasks GROUP BY date; ";
            PreparedStatement ps = con.prepareStatement(sql);
            //ps.setInt(1, id1);
            ResultSet rs = ps.executeQuery();

            List<List<Object>> taskList = new ArrayList<>();

            while (rs.next()) {
                int taskTitle = rs.getInt("month");
                double duration = rs.getDouble("duration");

                List<Object> taskData = new ArrayList<>();
                taskData.add(taskTitle);
                taskData.add(duration ); // Convert minutes to hours

                taskList.add(taskData);
            }

            // Set the attribute and forward to JSP
            System.out.print(taskList);
            request.setAttribute("tasklist", taskList);
            request.getRequestDispatcher("barchart.jsp").forward(request, response);

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
}
