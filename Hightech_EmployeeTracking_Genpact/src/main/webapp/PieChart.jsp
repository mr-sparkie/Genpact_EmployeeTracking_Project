<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%@ page import="com.hightech.util.*" %>
<%@ page session="true" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Task Dashboard</title>
    <!-- Load Google Charts library -->
    <script type="text/javascript" src="https://www.gstatic.com/charts/loader.js"></script>
    <style>
        body {
            font-family: Arial, sans-serif;
            padding: 20px;
            text-align: center;
        }
        .pie-chart {
            width: 500px; 
            height: 500px; 
            margin: 0 auto; 
        }
        .legend {
            margin-top: 20px;
        }
        .legend-item {
            display: inline-block;
            margin-right: 10px;
        }
        .legend-color {
            display: inline-block;
            width: 20px;
            height: 20px;
            margin-right: 5px;
            border-radius: 50%;
        }
        .completed {
            background-color: #FF6384;
        }
        .not-completed {
            background-color: #36A2EB;
        }
        table {
            width: 100%;
            border-collapse: collapse;
            margin-top: 20px;
        }
        th, td {
            border: 1px solid #ddd;
            padding: 8px;
        }
        th {
            background-color: #f2f2f2;
        }
        tr:hover {
            background-color: #f5f5f5;
        }
        .logout-button {
            margin-top: 20px;
        }
    </style>
</head>
<body>
    <h2>Task Completion Status - Pie Chart</h2>
    
    <!-- Pie Chart -->
    <div id="piechart" class="pie-chart"></div>
    
    <!-- JavaScript to render the chart -->
    <script type="text/javascript">
        google.charts.load('current', {'packages':['corechart']});
        google.charts.setOnLoadCallback(drawChart);

        function drawChart() {
            var data = new google.visualization.DataTable();
            data.addColumn('string', 'Task Status');
            data.addColumn('number', 'Number of Tasks');
            
            <% 
            Connection conn = null;
            PreparedStatement stmt = null;
            ResultSet rs = null;
            int userId = (Integer) session.getAttribute("user_id");
            try {
                conn = DbUtil.getConnection(); // Replace with your method to get DB connection
                stmt = conn.prepareStatement("SELECT ts.is_completed, COUNT(*) AS count " +
                                             "FROM tasks t " +
                                             "INNER JOIN task_status ts ON t.task_id = ts.task_id " +
                                             "WHERE t.user_id = ? " +
                                             "GROUP BY ts.is_completed");
                stmt.setInt(1, userId);
                rs = stmt.executeQuery();
                while (rs.next()) {
                    String status = rs.getBoolean("is_completed") ? "Completed" : "Not Completed";
                    int count = rs.getInt("count");
            %>
                data.addRow(['<%= status %>', <%= count %>]);
            <% 
                } // End while loop
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
            
            var options = {
                title: 'Task Completion Status',
                pieHole: 0.4,
                sliceVisibilityThreshold: 0.1,
                legend: { position: 'top', alignment: 'center' },
                pieSliceText: 'label',
                colors: ['#FF6384', '#36A2EB']
            };

            var chart = new google.visualization.PieChart(document.getElementById('piechart'));
            chart.draw(data, options);
        }
    </script>

    <h2>Incomplete Tasks</h2>
    <table>
        <tr>
            <th>Project</th>
            <th>Task Category</th>
            <th>End Time</th>
        </tr>
        <% 
        try {
            conn = DbUtil.getConnection(); // Replace with your method to get DB connection
            stmt = conn.prepareStatement("SELECT t.project, t.task_category, t.end_time " +
                                         "FROM tasks t " +
                                         "INNER JOIN task_status ts ON t.task_id = ts.task_id " +
                                         "WHERE t.user_id = ? AND ts.is_completed = 0");
            stmt.setInt(1, userId);
            rs = stmt.executeQuery();
            while (rs.next()) {
                String project = rs.getString("project");
                String taskCategory = rs.getString("task_category");
                String endTime = rs.getString("end_time");
        %>
        <tr>
            <td><%= project %></td>
            <td><%= taskCategory %></td>
            <td><%= endTime %></td>
        </tr>
        <% 
            } // End while loop
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
    </table>

    <form action="LogoutServlet" method="post" class="logout-button">
        <input type="submit" value="Logout">
    </form>
</body>
</html>
