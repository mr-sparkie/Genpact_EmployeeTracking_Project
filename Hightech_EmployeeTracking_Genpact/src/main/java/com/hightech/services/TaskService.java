package com.hightech.services;

import com.hightech.bean.Task;
import com.hightech.dao.TaskDAO;
import java.util.List;

public class TaskService {

    private TaskDAO taskDAO;

    public TaskService() {
        this.taskDAO = new TaskDAO();
    }

    public String addTask(int userId, String project, String dateStr, String startTimeStr, String endTimeStr,
                          String taskCategory, String description) {
        return taskDAO.addTask(userId, project, dateStr, startTimeStr, endTimeStr, taskCategory, description);
    }

    public List<Task> getAllTasks() {
        return taskDAO.getAllTasks();
    }

    public boolean updateTask(Task task) {
        return taskDAO.updateTask(task);
    }

    public boolean deleteTask(int taskId) {
        return taskDAO.deleteTask(taskId);
    }

    public Task getTaskById(int taskId) {
        return taskDAO.getTaskById(taskId);
    }
}
