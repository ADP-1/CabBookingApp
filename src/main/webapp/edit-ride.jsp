<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.cab.model.User" %>
<%@ page import="com.cab.model.Ride" %>
<%
    User currentUser = (User) session.getAttribute("user");
    if (currentUser == null) {
        response.sendRedirect("login.jsp");
        return;
    }
    
    Ride ride = (Ride) request.getAttribute("ride");
    if (ride == null) {
        response.sendRedirect("ride?action=myRides");
        return;
    }
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Edit Ride - Cab Booking System</title>
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
            <h1>✏️ Edit Ride</h1>
            <p class="text-muted">Update your ride details</p>
            
            <!-- Error Message -->
            <% if (request.getAttribute("errorMessage") != null) { %>
                <div class="alert alert-error">
                    <%= request.getAttribute("errorMessage") %>
                </div>
            <% } %>
            
            <form action="ride" method="POST">
                <input type="hidden" name="action" value="update">
                <input type="hidden" name="rideId" value="<%= ride.getRideId() %>">
                
                <div class="form-group">
                    <label for="source">Source Location:</label>
                    <input type="text" id="source" name="source" required 
                           value="<%= ride.getSource() %>">
                </div>
                
                <div class="form-group">
                    <label for="destination">Destination:</label>
                    <input type="text" id="destination" name="destination" required 
                           value="<%= ride.getDestination() %>">
                </div>
                
                <div class="form-group">
                    <label>Total Seats:</label>
                    <input type="text" value="<%= ride.getTotalSeats() %>" disabled>
                    <small>Total seats cannot be changed after creation</small>
                </div>
                
                <div class="form-group">
                    <label>Available Seats:</label>
                    <input type="text" value="<%= ride.getAvailableSeats() %>" disabled>
                    <small>Available seats update automatically with bookings</small>
                </div>
                
                <div class="form-group">
                    <label for="fare">Fare per Person (₹):</label>
                    <input type="number" id="fare" name="fare" required 
                           min="1" step="0.01" value="<%= ride.getFare() %>">
                </div>
                
                <div class="form-actions">
                    <button type="submit" class="btn btn-primary">Update Ride</button>
                    <a href="ride?action=myRides" class="btn btn-secondary">Cancel</a>
                </div>
            </form>
        </div>
    </div>

    <footer class="footer">
        <p>&copy; 2026 Cab Booking System. All rights reserved.</p>
    </footer>
</body>
</html>
