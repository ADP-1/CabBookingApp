<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.cab.model.User" %>
<%@ page import="com.cab.model.Booking" %>
<%@ page import="java.util.List" %>
<%
    User currentUser = (User) session.getAttribute("user");
    if (currentUser == null) {
        response.sendRedirect("login.jsp");
        return;
    }
    
    List<Booking> bookings = (List<Booking>) request.getAttribute("bookings");
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>My Bookings - Cab Booking System</title>
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
                <a href="booking?action=myBookings" class="nav-link active">My Bookings</a>
                <a href="ride?action=myRides" class="nav-link">My Rides</a>
                <a href="user?action=profile" class="nav-link">Profile</a>
                <a href="user?action=logout" class="nav-link">Logout</a>
            </div>
        </div>
    </nav>

    <div class="container">
        <h1>📋 My Bookings</h1>
        
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
        
        <% if (bookings == null || bookings.isEmpty()) { %>
            <div class="empty-state">
                <div class="empty-icon">🎫</div>
                <h2>No Bookings Yet</h2>
                <p>You haven't booked any rides. Start exploring available rides!</p>
                <a href="ride?action=search" class="btn btn-primary">Search Rides</a>
            </div>
        <% } else { %>
            <div class="bookings-list">
                <% for (Booking booking : bookings) { %>
                    <div class="booking-card">
                        <div class="booking-header">
                            <div>
                                <h3><%= booking.getRide().getSource() %> → <%= booking.getRide().getDestination() %></h3>
                                <p class="booking-id">Booking ID: <%= booking.getBookingId() %></p>
                            </div>
                            <span class="badge badge-<%= booking.getStatus().equals("CONFIRMED") ? "success" : "danger" %>">
                                <%= booking.getStatus() %>
                            </span>
                        </div>
                        
                        <div class="booking-details">
                            <div class="detail-row">
                                <div class="detail-item">
                                    <strong>Seats Booked:</strong> <%= booking.getSeatsBooked() %>
                                </div>
                                <div class="detail-item">
                                    <strong>Fare per Seat:</strong> ₹<%= String.format("%.2f", booking.getRide().getFare()) %>
                                </div>
                                <div class="detail-item">
                                    <strong>Total Amount:</strong> 
                                    ₹<%= String.format("%.2f", booking.getRide().getFare() * booking.getSeatsBooked()) %>
                                </div>
                            </div>
                        </div>
                        
                        <% if (booking.getStatus().equals("CONFIRMED")) { %>
                            <div class="booking-actions">
                                <form action="booking" method="POST" style="display:inline;" 
                                      onsubmit="return confirm('Are you sure you want to cancel this booking?');">
                                    <input type="hidden" name="action" value="cancel">
                                    <input type="hidden" name="bookingId" value="<%= booking.getBookingId() %>">
                                    <button type="submit" class="btn btn-danger">Cancel Booking</button>
                                </form>
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
