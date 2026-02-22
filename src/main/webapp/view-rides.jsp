<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.cab.model.User" %>
<%@ page import="com.cab.model.Ride" %>
<%@ page import="java.util.List" %>
<%
    User currentUser = (User) session.getAttribute("user");
    if (currentUser == null) {
        response.sendRedirect("login.jsp");
        return;
    }
    
    List<Ride> rides = (List<Ride>) request.getAttribute("rides");
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>All Rides - Cab Booking System</title>
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
        <div class="page-header">
            <h1>🗺️ Browse All Rides</h1>
            <a href="ride?action=create" class="btn btn-primary">+ Create Ride</a>
        </div>
        
        <% if (rides == null || rides.isEmpty()) { %>
            <div class="empty-state">
                <div class="empty-icon">🚗</div>
                <h2>No Rides Available</h2>
                <p>There are no active rides at the moment. Be the first to create one!</p>
                <a href="ride?action=create" class="btn btn-primary">Create a Ride</a>
            </div>
        <% } else { %>
            <p class="text-muted" style="color: white; margin-bottom: 1rem;">
                Showing <%= rides.size() %> active ride(s)
            </p>
            
            <div class="rides-grid">
                <% for (Ride ride : rides) { %>
                    <div class="ride-card">
                        <div class="ride-header">
                            <h3><%= ride.getSource() %> → <%= ride.getDestination() %></h3>
                            <span class="badge badge-success"><%= ride.getStatus() %></span>
                        </div>
                        
                        <div class="ride-details">
                            <div class="detail-item">
                                <strong>Driver:</strong> <%= ride.getCreatedBy().getName() %>
                            </div>
                            <div class="detail-item">
                                <strong>Email:</strong> <%= ride.getCreatedBy().getEmail() %>
                            </div>
                            <div class="detail-item">
                                <strong>Fare:</strong> ₹<%= String.format("%.2f", ride.getFare()) %>
                            </div>
                            <div class="detail-item">
                                <strong>Available Seats:</strong> 
                                <%= ride.getAvailableSeats() %> / <%= ride.getTotalSeats() %>
                            </div>
                        </div>
                        
                        <div class="ride-actions">
                            <% if (ride.getAvailableSeats() > 0 && 
                                   ride.getCreatedBy().getUserId() != currentUser.getUserId()) { %>
                                <a href="booking?action=book&rideId=<%= ride.getRideId() %>" 
                                   class="btn btn-primary">Book Now</a>
                            <% } else if (ride.getAvailableSeats() == 0) { %>
                                <button class="btn btn-secondary" disabled>Fully Booked</button>
                            <% } else { %>
                                <a href="ride?action=edit&rideId=<%= ride.getRideId() %>" 
                                   class="btn btn-secondary">Edit My Ride</a>
                            <% } %>
                        </div>
                    </div>
                <% } %>
            </div>
        <% } %>
    </div>

    <footer class="footer">
        <p>&copy; 2026 Cab Booking System. All rights reserved.</p>
    </footer>
</body>
</html>
