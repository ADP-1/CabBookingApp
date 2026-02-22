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
    String source = (String) request.getAttribute("source");
    String destination = (String) request.getAttribute("destination");
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Search Rides - Cab Booking System</title>
    <link rel="stylesheet" href="css/style.css">
</head>
<body>
    <!-- Navigation Bar -->
    <nav class="navbar">
        <div class="nav-container">
            <div class="nav-brand">🚖 Cab Booking</div>
            <div class="nav-menu">
                <a href="dashboard.jsp" class="nav-link">Dashboard</a>
                <a href="ride?action=search" class="nav-link active">Search Rides</a>
                <a href="booking?action=myBookings" class="nav-link">My Bookings</a>
                <a href="ride?action=myRides" class="nav-link">My Rides</a>
                <a href="user?action=profile" class="nav-link">Profile</a>
                <a href="user?action=logout" class="nav-link">Logout</a>
            </div>
        </div>
    </nav>

    <div class="container">
        <h1>🔍 Search Rides</h1>
        
        <!-- Error/Success Messages -->
        <% if (request.getAttribute("errorMessage") != null) { %>
            <div class="alert alert-error">
                <%= request.getAttribute("errorMessage") %>
            </div>
        <% } %>
        
        <!-- Search Form -->
        <div class="form-container">
            <form action="ride" method="POST">
                <input type="hidden" name="action" value="search">
                
                <div class="form-row">
                    <div class="form-group">
                        <label for="source">From:</label>
                        <input type="text" id="source" name="source" required 
                               placeholder="Enter source location"
                               value="<%= source != null ? source : "" %>">
                    </div>
                    
                    <div class="form-group">
                        <label for="destination">To:</label>
                        <input type="text" id="destination" name="destination" required 
                               placeholder="Enter destination"
                               value="<%= destination != null ? destination : "" %>">
                    </div>
                    
                    <div class="form-group">
                        <button type="submit" class="btn btn-primary">Search</button>
                    </div>
                </div>
            </form>
        </div>
        
        <!-- Search Results -->
        <% if (rides != null) { %>
            <div class="results-section">
                <h2>Search Results</h2>
                <% if (rides.isEmpty()) { %>
                    <div class="alert alert-info">
                        No rides found from <%= source %> to <%= destination %>. 
                        Try different locations or <a href="ride?action=create">create your own ride</a>.
                    </div>
                <% } else { %>
                    <p class="text-muted">Found <%= rides.size() %> ride(s) from <%= source %> to <%= destination %></p>
                    
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
                                        <button class="btn btn-secondary" disabled>Your Ride</button>
                                    <% } %>
                                </div>
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
