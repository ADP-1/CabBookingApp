<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.cab.model.User" %>
<%
    // Check if user is logged in
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
    <title>Dashboard - Cab Booking System</title>
    <link rel="stylesheet" href="css/style.css">
</head>
<body>
    <!-- Navigation Bar -->
    <nav class="navbar">
        <div class="nav-container">
            <div class="nav-brand">🚖 Cab Booking</div>
            <div class="nav-menu">
                <a href="dashboard.jsp" class="nav-link active">Dashboard</a>
                <a href="ride?action=search" class="nav-link">Search Rides</a>
                <a href="booking?action=myBookings" class="nav-link">My Bookings</a>
                <a href="ride?action=myRides" class="nav-link">My Rides</a>
                <a href="user?action=profile" class="nav-link">Profile</a>
                <a href="user?action=logout" class="nav-link">Logout</a>
            </div>
        </div>
    </nav>

    <div class="container">
        <div class="dashboard-header">
            <h1>Welcome, <%= currentUser.getName() %>!</h1>
            <p class="text-muted">Email: <%= currentUser.getEmail() %> | Mobile: <%= currentUser.getMobile() %></p>
        </div>

        <div class="dashboard-grid">
            <!-- Search Rides Card -->
            <div class="card">
                <div class="card-icon">🔍</div>
                <h3>Search Rides</h3>
                <p>Find rides to your destination</p>
                <a href="ride?action=search" class="btn btn-primary">Search Now</a>
            </div>

            <!-- Create Ride Card -->
            <div class="card">
                <div class="card-icon">➕</div>
                <h3>Offer a Ride</h3>
                <p>Create a ride for others</p>
                <a href="ride?action=create" class="btn btn-primary">Create Ride</a>
            </div>

            <!-- My Bookings Card -->
            <div class="card">
                <div class="card-icon">📋</div>
                <h3>My Bookings</h3>
                <p>View your booked rides</p>
                <a href="booking?action=myBookings" class="btn btn-primary">View Bookings</a>
            </div>

            <!-- My Rides Card -->
            <div class="card">
                <div class="card-icon">🚗</div>
                <h3>My Rides</h3>
                <p>Manage rides you created</p>
                <a href="ride?action=myRides" class="btn btn-primary">View My Rides</a>
            </div>

            <!-- Profile Card -->
            <div class="card">
                <div class="card-icon">👤</div>
                <h3>Profile</h3>
                <p>Update your information</p>
                <a href="user?action=profile" class="btn btn-primary">Edit Profile</a>
            </div>

            <!-- All Rides Card -->
            <div class="card">
                <div class="card-icon">🗺️</div>
                <h3>Browse Rides</h3>
                <p>See all available rides</p>
                <a href="ride?action=viewAll" class="btn btn-primary">View All</a>
            </div>
        </div>
    </div>

    <footer class="footer">
        <p>&copy; 2026 Cab Booking System. All rights reserved.</p>
    </footer>
</body>
</html>
