<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List" %>
<%@ page import="com.google.gson.Gson" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Task Dashboard</title>
    <link rel="stylesheet" type="text/css" href="styles.css">
    <script type="text/javascript" src="https://www.gstatic.com/charts/loader.js"></script>
    <script type="text/javascript">
        google.charts.load('current', {'packages':['corechart', 'bar']});
        google.charts.setOnLoadCallback(drawCharts);

        function drawCharts() {
            // Convert server-side data to JSON for JavaScript
            const monthlyData = <%= new Gson().toJson((List<List<Object>>) request.getAttribute("monthlyData")) %>;
            const weeklyData = <%= new Gson().toJson((List<List<Object>>) request.getAttribute("weeklyData")) %>;

            // Draw charts if data is available
            if (monthlyData && monthlyData.length > 0) {
                drawBarChart('columnchart_monthly', 'Monthly Task Duration', monthlyData, 'Month');
            }
            if (weeklyData && weeklyData.length > 0) {
                drawBarChart('columnchart_weekly', 'Weekly Task Duration', weeklyData, 'Week');
            }
        }

        function drawBarChart(elementId, title, dataList, periodLabel) {
            // Convert dataList to a format suitable for Google Charts
            var data = new google.visualization.DataTable();
            data.addColumn('string', periodLabel);
            data.addColumn('number', 'Duration (hours)');
            data.addRows(dataList.map(row => [row[0].toString(), row[1]]));

            var options = {
                title: title,
                chartArea: {width: '50%'},
                hAxis: {
                	title: periodLabel                	
                },
                vAxis: {
                    title: 'Total Duration (hours)',
                    minValue: 0
                }
            };

            var chart = new google.charts.Bar(document.getElementById(elementId));
            chart.draw(data, google.charts.Bar.convertOptions(options));
        }
    </script>
    <style>
        body {
            font-family: Arial, sans-serif;
            padding: 20px;
            text-align: center;
        }
        .chart {
            width: 800px;
            height: 500px;
            margin: 0 auto;
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
    <h2>Task Dashboard</h2>
    
    <!-- Form to input user ID -->
    <form action="analyzeTasks" method="post">
        <label for="userId">Enter User ID:</label>
        <input type="number" id="userId" name="id" required>
        <button type="submit">Fetch Data</button>
    </form>

    <!-- Charts -->
    <div id="columnchart_monthly" class="chart"></div>
    <div id="columnchart_weekly" class="chart"></div>

    <h2>Incomplete Tasks</h2>
    <table>
        <tr>
            <th>Project</th>
            <th>Task Category</th>
             <th>date</th>
            <th>End Time</th>
        </tr>
        <% 
            List<List<Object>> incompleteTasks = (List<List<Object>>) request.getAttribute("incompleteTasks");
            if (incompleteTasks != null) {
                for (List<Object> task : incompleteTasks) {
                    String project = (String) task.get(0);
                    String taskCategory = (String) task.get(1);
                    String date = (String) task.get(3);
                    String endTime = (String) task.get(2);
                    
        %>
            <tr>
                <td><%= project %></td>
                <td><%= taskCategory %></td>
                 <td><%= date %></td>
                <td><%= endTime %></td>
            </tr>
        <% 
                }
            }
        %>
    </table>

    <a href="logout.jsp" class="logout-button">Logout</a>
</body>
</html>
