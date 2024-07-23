<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List" %>
<%@ page import="java.util.ArrayList" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Task Analysis</title>
    <script type="text/javascript" src="https://www.gstatic.com/charts/loader.js"></script>
    <script type="text/javascript">
        google.charts.load('current', {'packages':['bar']});
        google.charts.setOnLoadCallback(drawChart);

        function drawChart() {
            var data = google.visualization.arrayToDataTable([
                ['Task Title', 'Duration (hours)'],
                <% 
                    List<List<Object>> taskList = (List<List<Object>>) request.getAttribute("tasklist");
                    if (taskList != null) {
                        for (List<Object> task : taskList) {
                            String taskTitle = (String) task.get(0);
                            double duration = (Double) task.get(1);
                            out.print("['" + taskTitle + "', " + duration + "],");
                        }
                    }
                %>
            ]);

            var options = {
                chart: {
                    title: 'Task Duration by Category',
                    subtitle: 'Total duration of tasks in hours'
                }
            };

            var chart = new google.charts.Bar(document.getElementById('task_chart'));
            chart.draw(data, google.charts.Bar.convertOptions(options));
        }
    </script>
</head>
<body>
    <h1>Task Analysis</h1>
    
    <div id="task_chart" style="width: 900px; height: 500px;"></div>

    <br>
    <button onclick="location.reload();">Refresh Chart</button>
</body>
</html>
