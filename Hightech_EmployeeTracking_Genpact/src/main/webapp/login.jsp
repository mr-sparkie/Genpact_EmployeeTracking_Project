<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Bank Login</title>
    <style>
        body {
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            background: linear-gradient(135deg, #FFAFBD, #ffc3a0);
            display: flex;
            justify-content: center;
            align-items: center;
            height: 100vh;
            margin: 0;
            overflow: hidden;
        }

        .container {
            position: relative;
            background-color: rgba(255, 255, 255, 0.8);
            border-radius: 15px;
            padding: 40px;
            box-shadow: 0 4px 30px rgba(0, 0, 0, 0.2);
            width: 400px;
            max-width: 90%;
            text-align: center;
            overflow: hidden;
        }

        .brand {
            font-size: 2.5em;
            font-weight: bold;
            color: #333;
            margin-bottom: 20px;
            text-shadow: 2px 2px 4px rgba(0, 0, 0, 0.2);
        }

        .form-group {
            margin-bottom: 20px;
            text-align: left;
        }

        .form-group label {
            display: block;
            font-size: 1.1em;
            font-weight: bold;
            margin-bottom: 5px;
            color: #333;
        }

        .form-group input {
            width: calc(100% - 40px);
            padding: 10px;
            font-size: 1em;
            border: none;
            border-radius: 5px;
            background-color: rgba(255, 255, 255, 0.9);
            box-shadow: 0 2px 10px rgba(0, 0, 0, 0.1);
            transition: box-shadow 0.3s, background-color 0.3s;
        }

        .form-group input:focus {
            outline: none;
            box-shadow: 0 0 20px rgba(255, 95, 109, 0.4);
            background-color: rgba(255, 255, 255, 1);
        }

        .form-group button {
            width: 100%;
            padding: 12px;
            font-size: 1.1em;
            border: none;
            border-radius: 5px;
            background-color: #FF6B6B;
            color: white;
            cursor: pointer;
            transition: background-color 0.3s;
            margin-top: 10px;
        }

        .form-group button:hover {
            background-color: #FF8C8C;
        }

        .error-message {
            color: #FF6B6B;
            
            font-size: 0.9em;
            margin-top: 10px;
            text-align: center;
        }

        .bottom-text {
            margin-top: 20px;
            font-size: 0.9em;
            color: #555;
        }

        .bottom-text a {
            color: #FF6B6B;
            text-decoration: none;
            transition: color 0.3s;
        }

        .bottom-text a:hover {
            color: #FF8C8C;
        }

        /* Popup Styles */
        .popup {
            display: none;
            position: fixed;
            top: 50%;
            left: 50%;
            transform: translate(-50%, -50%);
            background-color: rgba(0, 0, 0, 0.8);
            padding: 20px;
            border-radius: 10px;
            z-index: 2;
            width: 300px;
            text-align: center;
            color: white;
        }

        .popup .input-group {
            margin-bottom: 10px;
            text-align: left;
        }

        .popup button {
            background-color: #FF6B6B;
            margin-top: 10px;
            color: white;
            border: none;
            padding: 10px 20px;
            border-radius: 5px;
            cursor: pointer;
            transition: background-color 0.3s;
        }

        .popup button:hover {
            background-color: #FF8C8C;
        }

        .popup-overlay {
            position: fixed;
            top: 0;
            left: 0;
            width: 100%;
            height: 100%;
            background-color: rgba(0, 0, 0, 0.5);
            backdrop-filter: blur(5px);
            z-index: 1;
            display: none;
        }

        .popup .close-button {
            position: absolute;
            top: 10px;
            right: 10px;
            font-size: 1.2em;
            color: #FF6B6B;
            cursor: pointer;
            transition: color 0.3s;
        }

        .popup .close-button:hover {
            color: #FF8C8C;
        }
    </style>
</head>
<body>
    <div class="container">
        <div class="brand">Login</div>
        <form action="login" method="post" class="login-form">
            <input type="hidden" name="action" value="login">
            <div class="form-group">
                <label for="username">Account Number</label>
                <input type="text" id="username" name="username" required>
            </div>
            <div class="form-group">
                <label for="password">Password</label>
                <input type="password" id="password" name="password" required>
            </div>
            <button type="submit">Login</button>
            <%-- Display error message if login fails --%>
            <% if (request.getAttribute("errorMessage") != null) { %>
                <div class="error-message"><%= request.getAttribute("errorMessage") %></div>
            <% } %>
        </form>
        <div class="bottom-text">
            Forgot your password?
            <a href="#" style="color: #FF6B6B;" onclick="showPopup('passwordUpdatePopup')">Reset here</a>
        </div>
    </div>

    <!-- Password Update Popup -->
    <div class="popup" id="passwordUpdatePopup">
        <div class="popup-overlay" onclick="hidePopup('passwordUpdatePopup')"></div>
        <div class="popup-content">
            <span class="close-button" onclick="hidePopup('passwordUpdatePopup')">&times;</span>
            <form action="updatePassword" method="post">
                <input type="hidden" name="action" value="updatePassword">
                <div class="input-group">
                    <label for="acc_no" style="color: #FF6B6B;">Account Number</label>
                    <input type="text" id="acc_no" name="accno" required>
                </div>
                <div class="input-group">
                    <label for="oldPassword" style="color: #FF6B6B;">Old Password</label>
                    <input type="password" id="oldPassword" name="oldPassword" required>
                </div>
                <div class="input-group">
                    <label for="newPassword" style="color: #FF6B6B;">New Password</label>
                    <input type="password" id="newPassword" name="newPassword" required>
                </div>
                <div class="input-group">
                    <label for="confirmPassword" style="color: #FF6B6B;">Confirm New Password</label>
                    <input type="password" id="confirmPassword" name="confirmPassword" required>
                </div>
                <button type="submit">Change Password</button>
            </form>
        </div>
    </div>

    <script>
        function showPopup(popupId) {
            document.getElementById(popupId).style.display = 'block';
            document.body.style.overflow = 'hidden'; // Prevent scrolling when popup is open
        }

        function hidePopup(popupId) {
            document.getElementById(popupId).style.display = 'none';
            document.body.style.overflow = 'auto'; // Enable scrolling when popup is closed
        }
    </script>
</body>
</html>
