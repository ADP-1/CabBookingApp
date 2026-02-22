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
    <title>My Rides - Cab Booking System</title>
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
                <a href="ride?action=myRides" class="nav-link active">My Rides</a>
                <a href="user?action=profile" class="nav-link">Profile</a>
                <a href="user?action=logout" class="nav-link">Logout</a>
            </div>
        </div>
    </nav>

    <div class="container">
        <div class="page-header">
            <h1>🚗 My Rides</h1>
            <a href="ride?action=create" class="btn btn-primary">+ Create New Ride</a>
        </div>
        
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
        
        <% if (rides == null || rides.isEmpty()) { %>
            <div class="empty-state">
                <div class="empty-icon">🚙</div>
                <h2>No Rides Created Yet</h2>
                <p>You haven't created any rides. Start by offering a ride to help others!</p>
                <a href="ride?action=create" class="btn btn-primary">Create Your First Ride</a>
            </div>
        <% } else { %>
            <div class="rides-grid">
                <% for (Ride ride : rides) { %>
                    <div class="ride-card <%= ride.getStatus().equals("CANCELLED") ? "cancelled" : "" %>">
                        <div class="ride-header">
                            <h3><%= ride.getSource() %> → <%= ride.getDestination() %></h3>
                            <span class="badge badge-<%= ride.getStatus().equals("ACTIVE") ? "success" : "danger" %>">
                                <%= ride.getStatus() %>
                            </span>
                        </div>
                        
                        <div class="ride-details">
                            <div class="detail-item">
                                <strong>Fare:</strong> ₹<%= String.format("%.2f", ride.getFare()) %>
                            </div>
                            <div class="detail-item">
                                <strong>Seats:</strong> 
                                <%= ride.getAvailableSeats() %> available / <%= ride.getTotalSeats() %> total
                            </div>
                            <div class="detail-item">
                                <strong>Bookings:</strong> 
                                <%= ride.getTotalSeats() - ride.getAvailableSeats() %> passengers
                            </div>
                        </div>
                        
                        <% if (ride.getStatus().equals("ACTIVE")) { %>
                            <div class="ride-actions">
                                <a href="ride?action=edit&rideId=<%= ride.getRideId() %>" 
                                   class="btn btn-secondary">Edit</a>
                                <form action="ride" method="POST" style="display:inline;" 
                                      onsubmit="return confirm('Are you sure you want to cancel this ride? All bookings will be cancelled.');">
                                    <input type="hidden" name="action" value="cancel">
                                    <input type="hidden" name="rideId" value="<%= ride.getRideId() %>">
                                    <button type="submit" class="btn btn-danger">Cancel Ride</button>
                                </form>
                            </div>
                        <% } else { %>
                            <div class="ride-actions">
                                <button class="btn btn-secondary" disabled>Ride Cancelled</button>
                            </div>
                        <% } %>
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
