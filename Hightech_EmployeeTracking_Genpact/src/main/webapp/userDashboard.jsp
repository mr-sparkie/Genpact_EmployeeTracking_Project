<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List" %>
<%@ page import="com.hightech.bean.Task" %>
<%@ page import="java.sql.Connection, java.sql.PreparedStatement, java.sql.ResultSet, java.sql.SQLException,java.sql.Date,java.sql.Time" %>
<%@ page import="com.hightech.util.*" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>User Page</title>
    <style>
        body {
            font-family: Arial, sans-serif;
        }

        table {
            width: 100%;
            border-collapse: collapse;
            margin: 20px 0;
        }

        th, td {
            border: 1px solid #ccc;
            padding: 10px;
            text-align: left;
        }

        th {
            background-color: #f2f2f2;
        }

        .task.pending {
            background-color: #f9f9f9;
        }

        .task.completed {
            background-color: #d4edda;
        }

        .toggle-button {
            padding: 5px 10px;
            cursor: pointer;
            border: none;
            border-radius: 3px;
        }

        .toggle-button.pending {
            background-color: #f0ad4e;
            color: white;
        }

        .toggle-button.completed {
            background-color: #5cb85c;
            color: white;
        }
    </style>
</head>
<body>
    <h2>My Tasks</h2>
    <table id="taskTable">
       <thead>
        <tr>
            <th>Task ID</th>
            <th>Task</th>
            <th>Date</th>
            <th>Start Time</th>
            <th>End Time</th>
            <th>Total Duration</th>
            <th>Task Category</th>
            <th>Description</th>
        </tr>
        </thead>
        <tbody>
        <% 
        Connection conn = null;
        PreparedStatement stmt = null;
        ResultSet rs = null;

        try {
            conn = DbUtil.getConnection();

            String query = "SELECT * FROM tasks where user_id = ? "; // Assuming 'user_id' is used to filter tasks
            stmt = conn.prepareStatement(query);
            rs = stmt.executeQuery();

            boolean tasksFound = false;
            while (rs.next()) {
                tasksFound = true;
                int taskId = rs.getInt("task_id");
                int userId = rs.getInt("user_id");
                String project = rs.getString("project");
                Date date = rs.getDate("date");
                Time startTime = rs.getTime("start_time");
                Time endTime = rs.getTime("end_time");
                float duration = rs.getFloat("duration");
                String taskCategory = rs.getString("task_category");
                String description = rs.getString("description");

                // Displaying task details in table rows
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
                </tr>
        <% 
            }

            if (!tasksFound) {
        %>
                <tr>
                    <td colspan="9">No tasks found.</td>
                </tr>
        <% 
            }

        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            // Close resources in finally block
            try {
                if (rs != null) rs.close();
                if (stmt != null) stmt.close();
                if (conn != null) conn.close();
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }
        %>
            <!-- Task rows will be injected here by JavaScript -->
        </tbody>
    </table>
    <script>
        document.addEventListener('DOMContentLoaded', () => {
            fetch('tasks')
                .then(response => response.json())
                .then(tasks => {
                    const taskTableBody = document.querySelector('#taskTable tbody');

                    tasks.forEach(task => {
                        const taskRow = document.createElement('tr');
                        taskRow.className = `task ${task.status}`;
                        taskRow.dataset.id = task.id;

                        const idCell = document.createElement('td');
                        idCell.textContent = task.id;
                        taskRow.appendChild(idCell);

                        const taskCell = document.createElement('td');
                        taskCell.textContent = task.task;
                        taskRow.appendChild(taskCell);

                        const statusCell = document.createElement('td');
                        statusCell.textContent = task.status;
                        taskRow.appendChild(statusCell);

                        const actionCell = document.createElement('td');
                        const toggleButton = document.createElement('button');
                        toggleButton.className = `toggle-button ${task.status}`;
                        toggleButton.textContent = task.status === 'pending' ? 'Mark as Completed' : 'Mark as Pending';
                        toggleButton.addEventListener('click', () => toggleStatus(task.id));
                        actionCell.appendChild(toggleButton);
                        taskRow.appendChild(actionCell);

                        taskTableBody.appendChild(taskRow);
                    });
                })
                .catch(error => console.error('Error fetching tasks:', error));
        });

        function toggleStatus(taskId) {
            const taskRow = document.querySelector(`.task[data-id='${taskId}']`);
            const statusCell = taskRow.querySelector('td:nth-child(3)');
            const button = taskRow.querySelector('.toggle-button');

            if (taskRow.classList.contains('pending')) {
                taskRow.classList.remove('pending');
                taskRow.classList.add('completed');
                statusCell.textContent = 'completed';
                button.classList.remove('pending');
                button.classList.add('completed');
                button.textContent = 'Mark as Pending';
            } else {
                taskRow.classList.remove('completed');
                taskRow.classList.add('pending');
                statusCell.textContent = 'pending';
                button.classList.remove('completed');
                button.classList.add('pending');
                button.textContent = 'Mark as Completed';
            }
        }
    </script>                      
</body>
</html>
