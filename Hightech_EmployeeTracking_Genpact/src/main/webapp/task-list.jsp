<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Task List</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.15.3/css/all.min.css">
    <link rel="stylesheet" href="styles/gojoPalette.css">
    <style>
        body {
            font-family: 'Roboto', sans-serif;
            background: #f0f0f0;
            margin: 0;
            padding: 0;
        }
        .container {
            max-width: 1200px;
            margin: 20px auto;
            padding: 20px;
            background: #fff;
            box-shadow: 0 4px 8px rgba(0,0,0,0.1);
            border-radius: 8px;
        }
        h1 {
            text-align: center;
            color: #444;
        }
        table {
            width: 100%;
            border-collapse: collapse;
            margin-top: 20px;
        }
        table, th, td {
            border: 1px solid #ccc;
        }
        th, td {
            padding: 10px;
            text-align: left;
        }
        th {
            background: #444;
            color: #fff;
        }
    </style>
</head>
<body>

<div class="container">
    <h1>Task List</h1>
    
    <table>
        <thead>
            <tr>
                <th>Task ID</th>
                <th>User ID</th>
                <th>Project</th>
                <th>Date</th>
                <th>Start Time</th>
                <th>End Time</th>
                <th>Duration</th>
                <th>Task Category</th>
                <th>Description</th>
                <th>Action</th>
            </tr>
        </thead>
        <tbody>
            <c:forEach items="${tasks}" var="task">
                <tr>
                    <td>${task.taskId}</td>
                    <td>${task.userId}</td>
                    <td>${task.project}</td>
                    <td>${task.date}</td>
                    <td>${task.startTime1}</td>
                    <td>${task.endTime1}</td>
                    <td>${task.duration}</td>
                    <td>${task.taskCategory}</td>
                    <td>${task.description}</td>
                    <td>
                        <a href="TaskServlet?action=edit&taskId=${task.taskId}">Edit</a>
                        <a href="TaskServlet?action=delete&taskId=${task.taskId}">Delete</a>
                    </td>
                </tr>
            </c:forEach>
        </tbody>
    </table>
    
    <div style="text-align: center; margin-top: 20px;">
        <a href="adminDashboard.jsp" style="font-size: 16px;">Back to Admin Panel</a>
    </div>
</div>

</body>
</html>
