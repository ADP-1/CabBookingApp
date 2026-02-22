<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.cab.model.User" %>
<%
    User currentUser = (User) session.getAttribute("user");
    if (currentUser == null) {
        response.sendRedirect("login.jsp");
        return;
    }
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Profile - Cab Booking System</title>
    <link rel="stylesheet" href="css/style.css">
</head>
<body>
    <!-- Navigation Bar -->
    <nav class="navbar">
        <div class="nav-container">
            <div class="nav-brand">🚖 Cab Booking</div>
            <div class="nav-menu">
                <a href="dashboard.jsp" class="nav-link">Dashboard</a>
                <a href="ride?action=search" class="nav-link">Search Rides</a>
                <a href="booking?action=myBookings" class="nav-link">My Bookings</a>
                <a href="ride?action=myRides" class="nav-link">My Rides</a>
                <a href="user?action=profile" class="nav-link active">Profile</a>
                <a href="user?action=logout" class="nav-link">Logout</a>
            </div>
        </div>
    </nav>

    <div class="container">
        <h1>👤 My Profile</h1>
        
        <!-- Success Message -->
        <% if (request.getAttribute("successMessage") != null) { %>
            <div class="alert alert-success">
                <%= request.getAttribute("successMessage") %>
            </div>
        <% } %>
        
        <!-- Error Message -->
        <% if (request.getAttribute("errorMessage") != null) { %>
            <div class="alert alert-error">
                <%= request.getAttribute("errorMessage") %>
            </div>
        <% } %>
        
        <div class="profile-container">
            <!-- Profile Info Card -->
            <div class="profile-card">
                <div class="profile-icon">👤</div>
                <h2><%= currentUser.getName() %></h2>
                <p class="text-muted">User ID: <%= currentUser.getUserId() %></p>
            </div>
            
            <!-- Edit Profile Form -->
            <div class="form-container">
                <h2>Edit Profile</h2>
                
                <form action="user" method="POST">
                    <input type="hidden" name="action" value="update">
                    
                    <div class="form-group">
                        <label for="name">Full Name:</label>
                        <input type="text" id="name" name="name" required 
                               value="<%= currentUser.getName() %>">
                    </div>
                    
                    <div class="form-group">
                        <label for="email">Email:</label>
                        <input type="email" id="email" name="email" required 
                               value="<%= currentUser.getEmail() %>">
                    </div>
                    
                    <div class="form-group">
                        <label for="mobile">Mobile Number:</label>
                        <input type="number" id="mobile" name="mobile" required 
                               value="<%= currentUser.getMobile() %>">
                    </div>
                    
                    <div class="form-actions">
                        <button type="submit" class="btn btn-primary">Update Profile</button>
                        <a href="dashboard.jsp" class="btn btn-secondary">Cancel</a>
                    </div>
                </form>
            </div>
            
            <!-- Danger Zone -->
            <div class="danger-zone">
                <h3>⚠️ Danger Zone</h3>
                <p>Once you delete your account, there is no going back. Please be certain.</p>
                <a href="user?action=delete" class="btn btn-danger">Delete Account</a>
            </div>
        </div>
    </div>

    <footer class="footer">
        <p>&copy; 2026 Cab Booking System. All rights reserved.</p>
    </footer>
</body>
</html>
