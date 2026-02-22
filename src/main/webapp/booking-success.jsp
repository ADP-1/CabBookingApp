<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.cab.model.User" %>
<%@ page import="com.cab.model.Booking" %>
<%
    User currentUser = (User) session.getAttribute("user");
    if (currentUser == null) {
        response.sendRedirect("login.jsp");
        return;
    }
    
    Booking booking = (Booking) request.getAttribute("booking");
    if (booking == null) {
        response.sendRedirect("dashboard.jsp");
        return;
    }
    
    double totalAmount = booking.getRide().getFare() * booking.getSeatsBooked();
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Booking Confirmed - Cab Booking System</title>
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
        <div class="success-container">
            <div class="success-icon">✅</div>
            <h1>Booking Confirmed!</h1>
            <p class="success-message">Your ride has been successfully booked.</p>
            
            <div class="confirmation-card">
                <h2>Booking Details</h2>
                
                <div class="detail-row">
                    <span class="label">Booking ID:</span>
                    <span class="value"><strong><%= booking.getBookingId() %></strong></span>
                </div>
                
                <div class="detail-row">
                    <span class="label">Route:</span>
                    <span class="value">
                        <%= booking.getRide().getSource() %> → <%= booking.getRide().getDestination() %>
                    </span>
                </div>
                
                <div class="detail-row">
                    <span class="label">Seats Booked:</span>
                    <span class="value"><%= booking.getSeatsBooked() %></span>
                </div>
                
                <div class="detail-row">
                    <span class="label">Fare per Seat:</span>
                    <span class="value">₹<%= String.format("%.2f", booking.getRide().getFare()) %></span>
                </div>
                
                <hr>
                
                <div class="detail-row total">
                    <span class="label"><strong>Total Amount:</strong></span>
                    <span class="value"><strong>₹<%= String.format("%.2f", totalAmount) %></strong></span>
                </div>
                
                <div class="detail-row">
                    <span class="label">Status:</span>
                    <span class="value"><span class="badge badge-success"><%= booking.getStatus() %></span></span>
                </div>
            </div>
            
            <div class="success-actions">
                <a href="booking?action=myBookings" class="btn btn-primary">View My Bookings</a>
                <a href="ride?action=search" class="btn btn-secondary">Book Another Ride</a>
                <a href="dashboard.jsp" class="btn btn-secondary">Go to Dashboard</a>
            </div>
            
            <div class="info-box">
                <strong>Important:</strong> Please save your Booking ID (<%= booking.getBookingId() %>) for future reference.
            </div>
        </div>
    </div>

    <footer class="footer">
        <p>&copy; 2026 Cab Booking System. All rights reserved.</p>
    </footer>
</body>
</html>
