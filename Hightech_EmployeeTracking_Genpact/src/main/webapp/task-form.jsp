<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Task Form</title>
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
            max-width: 600px;
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
        .form-group {
            margin-bottom: 15px;
        }
        .form-group label {
            display: block;
            margin-bottom: 5px;
            font-weight: bold;
        }
        .form-group input, .form-group select, .form-group textarea {
            width: 100%;
            padding: 10px;
            border: 1px solid #ccc;
            border-radius: 4px;
        }
        .form-group button {
            padding: 10px 15px;
            background: #444;
            color: #fff;
            border: none;
            border-radius: 4px;
            cursor: pointer;
            transition: background 0.3s;
        }
        .form-group button:hover {
            background: #333;
        }
    </style>
</head>
<body>

<div class="container">
    <h1>Task Form</h1>
    
    <form action="TaskServlet" method="post">
        <input type="hidden" name="action" value="${empty task.taskId ? 'add' : 'update'}">
        <c:if test="${!empty task.taskId}">
            <input type="hidden" name="taskId" value="${task.taskId}">
        </c:if>
        
        <div class="form-group">
            <label for="user_id">User ID:</label>
            <input type="number" id="user_id" name="user_id" value="${empty task.userId ? '' : task.userId}" required>
        </div>
        
        <div class="form-group">
            <label for="project">Project:</label>
            <input type="text" id="project" name="project" value="${empty task.project ? '' : task.project}" required>
        </div>
        
        <div class="form-group">
            <label for="date">Date:</label>
            <input type="date" id="date" name="date" value="${empty task.date ? '' : task.date}" required>
        </div>
        
        <div class="form-group">
            <label for="start_time">Start Time:</label>
            <input type="time" id="start_time" name="start_time" value="${empty task.startTime1 ? '' : task.startTime1}" required>
        </div>
        
        <div class="form-group">
            <label for="end_time">End Time:</label>
            <input type="time" id="end_time" name="end_time" value="${empty task.endTime1 ? '' : task.endTime1}" required>
        </div>
        
        <div class="form-group">
            <label for="duration">Duration:</label>
            <input type="number" step="0.01" id="duration" name="duration" value="${empty task.duration ? '' : task.duration}" required>
        </div>
        
        <div class="form-group">
            <label for="task_category">Task Category:</label>
            <input type="text" id="task_category" name="task_category" value="${empty task.taskCategory ? '' : task.taskCategory}" required>
        </div>
        
        <div class="form-group">
            <label for="description">Description:</label>
            <textarea id="description" name="description" required>${empty task.description ? '' : task.description}</textarea>
        </div>
        
        <div class="form-group">
            <button type="submit">${empty task.taskId ? 'Add Task' : 'Update Task'}</button>
        </div>
    </form>
    
    <div style="text-align: center; margin-top: 20px;">
        <a href="adminDashboard.jsp" style="font-size: 16px;">Back to Admin Panel</a>
    </div>
</div>

</body>
</html>
