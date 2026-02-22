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
    <title>Create Ride - Cab Booking System</title>
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
                <a href="user?action=profile" class="nav-link">Profile</a>
                <a href="user?action=logout" class="nav-link">Logout</a>
            </div>
        </div>
    </nav>

    <div class="container">
        <div class="form-container">
            <h1>➕ Create New Ride</h1>
            <p class="text-muted">Offer a ride to help others reach their destination</p>
            
            <!-- Error Message -->
            <% if (request.getAttribute("errorMessage") != null) { %>
                <div class="alert alert-error">
                    <%= request.getAttribute("errorMessage") %>
                </div>
            <% } %>
            
            <form action="ride" method="POST">
                <input type="hidden" name="action" value="create">
                
                <div class="form-group">
                    <label for="source">Source Location:</label>
                    <input type="text" id="source" name="source" required 
                           placeholder="e.g., Mumbai, Delhi">
                </div>
                
                <div class="form-group">
                    <label for="destination">Destination:</label>
                    <input type="text" id="destination" name="destination" required 
                           placeholder="e.g., Pune, Jaipur">
                </div>
                
                <div class="form-group">
                    <label for="totalSeats">Total Seats Available:</label>
                    <input type="number" id="totalSeats" name="totalSeats" required 
                           min="1" max="10" placeholder="e.g., 4">
                    <small>Maximum 10 seats</small>
                </div>
                
                <div class="form-group">
                    <label for="fare">Fare per Person (₹):</label>
                    <input type="number" id="fare" name="fare" required 
                           min="1" step="0.01" placeholder="e.g., 500.00">
                </div>
                
                <div class="form-actions">
                    <button type="submit" class="btn btn-primary">Create Ride</button>
                    <a href="dashboard.jsp" class="btn btn-secondary">Cancel</a>
                </div>
            </form>
        </div>
    </div>

    <footer class="footer">
        <p>&copy; 2026 Cab Booking System. All rights reserved.</p>
    </footer>
</body>
</html>
