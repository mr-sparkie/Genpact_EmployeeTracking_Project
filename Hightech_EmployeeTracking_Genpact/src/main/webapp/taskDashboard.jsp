<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*, jakarta.servlet.http.HttpSession" %>
<%@ page import="com.hightech.util.DbUtil" %>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Task Dashboard</title>
    <style>
        /* Exact CSS styles for the tasks table */
        body {
            font-family: Arial, sans-serif;
            padding: 20px;
        }
        h2 {
            text-align: center;
            margin-bottom: 20px;
        }
        table {
            width: 100%;
            border-collapse: collapse;
            margin-top: 20px;
        }
        table, th, td {
            border: 1px solid #ddd;
        }
        th, td {
            padding: 12px;
            text-align: left;
        }
        th {
            background-color: #f2f2f2;
            color: #333;
        }
        .completed {
            text-decoration: line-through; /* Style for completed tasks */
            color: #888;
        }
        .toggle-button {
            padding: 6px 12px;
            background-color: #007bff;
            color: #fff;
            border: none;
            border-radius: 3px;
            cursor: pointer;
        }
        .toggle-button.completed {
            background-color: #6c757d;
        }
        button {
            padding: 10px 20px;
            background-color: #007bff;
            color: #fff;
            border: none;
            border-radius: 5px;
            cursor: pointer;
            margin-bottom: 20px;
        }
    </style>
</head>
<body>
    <h2>Task Dashboard</h2>
    
    <!-- Tasks Table -->
    <table>
        <thead>
            <tr>
                <th>Task ID</th>
                <th>Project</th>
                <th>Date</th>
                <th>Start Time</th>
                <th>End Time</th>
                <th>Duration (hrs)</th>
                <th>Task Category</th>
                <th>Description</th>
                <th>Completion Status</th>
            </tr>
        </thead>
        <tbody id="taskTableBody">
            <% 
            Connection conn = null;
            PreparedStatement stmt = null;
            ResultSet rs = null;
            try {
                conn = DbUtil.getConnection(); // Replace with your method to get DB connection
                stmt = conn.prepareStatement("SELECT t.task_id, t.project, t.date, t.start_time, t.end_time, t.duration, t.task_category, t.description, ts.is_completed " +
                                             "FROM tasks t " +
                                             "INNER JOIN task_status ts ON t.task_id = ts.task_id " +
                                             "WHERE t.user_id = ?");
                stmt.setInt(1, (int) session.getAttribute("user_id"));
                
                rs = stmt.executeQuery();
                while (rs.next()) {
                    int taskId = rs.getInt("task_id");
                    String project = rs.getString("project");
                    Date date = rs.getDate("date");
                    Time startTime = rs.getTime("start_time");
                    Time endTime = rs.getTime("end_time");
                    double duration = rs.getDouble("duration");
                    String taskCategory = rs.getString("task_category");
                    String description = rs.getString("description");
                    boolean completed = rs.getBoolean("is_completed");

                    %>
                    <tr>
                        <td><%= taskId %></td>
                        <td><%= project %></td>
                        <td><%= date %></td>
                        <td><%= startTime %></td>
                        <td><%= endTime %></td>
                        <td><%= duration %></td>
                        <td><%= taskCategory %></td>
                        <td><%= description %></td>
                        <td>
                            <button id="toggle_<%= taskId %>" class="toggle-button <%= completed ? "completed" : "" %>"
                                    onclick="toggleCompletion(<%= taskId %>, <%= completed %>)">
                                <%= completed ? "Completed" : "Not Completed" %>
                            </button>
                        </td>
                    </tr>
                    <%
                }
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
            %>
        </tbody>
    </table>
    
    <!-- Button to View Pie Chart -->
    <button onclick="viewPieChart()">View Pie Chart</button>
    
    <!-- JavaScript for Toggle Completion -->
    <script>
        // Function to toggle task completion status
        function toggleCompletion(taskId, completed) {
            var toggleButton = document.getElementById('toggle_' + taskId);
            var newCompletedState = !completed; // Toggle the current state
            
            // Ajax call to update completion status in task_status table
            var xhttp = new XMLHttpRequest();
            xhttp.onreadystatechange = function() {
                if (this.readyState == 4 && this.status == 200) {
                    // Update button text and class based on new state
                    toggleButton.textContent = newCompletedState ? 'Completed' : 'Not Completed';
                    toggleButton.classList.toggle('completed', newCompletedState);
                }
            };
            xhttp.open("POST", "TaskDashboardServlet", true);
            xhttp.setRequestHeader("Content-type", "application/x-www-form-urlencoded");
            xhttp.send("taskId=" + taskId + "&isCompleted=" + newCompletedState);
        }

        // Function to redirect to Pie Chart view page
        function viewPieChart() {
            window.location.href = "PieChart.jsp"; // Replace with actual path to PieChart.jsp
        }
    </script>
</body>
</html>
