package com.hightech.controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;

import com.hightech.services.UserService;

//@WebServlet("/updatePassword")
public class UpdatePasswordServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private UserService userService;

    public UpdatePasswordServlet() {
        this.userService = new UserService();
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            // Get parameters from request
            String accNoStr = request.getParameter("accno");
            String oldPassword = request.getParameter("oldPassword");
            String newPassword = request.getParameter("newPassword");
            String confirmPassword = request.getParameter("confirmPassword");

            // Validate inputs
            if (accNoStr == null || oldPassword == null || newPassword == null || confirmPassword == null ||
                accNoStr.isEmpty() || oldPassword.isEmpty() || newPassword.isEmpty() || confirmPassword.isEmpty()) {
                request.setAttribute("errorMessage", "All fields are required.");
                request.getRequestDispatcher("login.jsp").forward(request, response);
                return;
            }

            int userId = Integer.parseInt(accNoStr);

            // Check if newPassword matches confirmPassword
            if (!newPassword.equals(confirmPassword)) {
                request.setAttribute("errorMessage", "Passwords do not match.");
                request.getRequestDispatcher("login.jsp").forward(request, response);
                return;
            }

            // Verify old password before updating
            boolean isOldPasswordCorrect = userService.verifyOldPassword(userId, oldPassword);

            if (!isOldPasswordCorrect) {
                request.setAttribute("errorMessage", "Incorrect old password.");
                request.getRequestDispatcher("login.jsp").forward(request, response);
                return;
            }

            // Update password in database
            boolean isUpdated = userService.updatePassword(userId, oldPassword, newPassword);

            if (isUpdated) {
                request.setAttribute("successMessage", "Password updated successfully.");
                request.getRequestDispatcher("login.jsp").forward(request, response);
            } else {
                request.setAttribute("errorMessage", "Failed to update password.");
                request.getRequestDispatcher("login.jsp").forward(request, response);
            }
        } catch (NumberFormatException e) {
            // Handle invalid number format for accno parameter
            request.setAttribute("errorMessage", "Invalid account number format.");
            request.getRequestDispatcher("login.jsp").forward(request, response);
        } catch (Exception e) {
            // Handle other exceptions
            e.printStackTrace(); // Log the exception for debugging
            request.setAttribute("errorMessage", "An error occurred.");
            request.getRequestDispatcher("login.jsp").forward(request, response);
        }
    }
}
