<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <%@ page import="com.cab.model.User, com.cab.model.Booking" %>
        <% User currentUser=(User) session.getAttribute("user"); if (currentUser==null) {
            response.sendRedirect("login.jsp"); return; } Booking booking=(Booking) request.getAttribute("booking"); if
            (booking==null) { response.sendRedirect("dashboard.jsp"); return; } double
            totalAmount=booking.getRide().getFare() * booking.getSeatsBooked(); %>
            <!DOCTYPE html>
            <html lang="en">

            <head>
                <meta charset="UTF-8">
                <meta name="viewport" content="width=device-width, initial-scale=1.0">
                <title>Booking Confirmed — Cab Booking</title>
                <link rel="preconnect" href="https://fonts.googleapis.com">
                <link rel="stylesheet"
                    href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700;800&family=Material+Symbols+Rounded:opsz,wght,FILL,GRAD@24,400,1,0&display=swap">
                <link rel="stylesheet" href="css/style.css">
            </head>

            <body>
                <nav class="navbar">
                    <div class="nav-container">
                        <a href="dashboard.jsp" class="nav-brand">
                            <div class="nav-brand-icon"><span class="ms">directions_car</span></div>
                            <span class="nav-brand-text">Cab Booking</span>
                        </a>
                        <div class="nav-menu">
                            <a href="dashboard.jsp" class="nav-link">Dashboard</a>
                            <a href="ride?action=search" class="nav-link">Search</a>
                            <a href="booking?action=myBookings" class="nav-link">Bookings</a>
                            <a href="ride?action=myRides" class="nav-link">My Rides</a>
                            <a href="user?action=profile" class="nav-link">Profile</a>
                            <a href="user?action=logout" class="nav-link logout">Logout</a>
                        </div>
                    </div>
                </nav>

                <div class="container">
                    <div class="success-wrapper">
                        <div class="success-icon-wrap"><span class="ms">check_circle</span></div>
                        <h1 class="success-title">You're booked!</h1>
                        <p class="success-sub">Your ride has been confirmed. Have a safe journey.</p>

                        <div class="confirmation-card">
                            <h2 style="display:flex; align-items:center; gap:0.45rem; margin-bottom:1.25rem;">
                                <span class="ms"
                                    style="font-size:1.1rem; color:var(--accent-mid);">confirmation_number</span>
                                Booking Summary
                            </h2>

                            <div class="detail-row">
                                <span class="label">Booking ID</span>
                                <span class="value" style="font-family:monospace; font-size:0.8rem;">
                                    <%= booking.getBookingId() %>
                                </span>
                            </div>
                            <div class="detail-row">
                                <span class="label">Route</span>
                                <span class="value">
                                    <%= booking.getRide().getSource() %> <span style="color:var(--accent-mid);">→</span>
                                        <%= booking.getRide().getDestination() %>
                                </span>
                            </div>
                            <div class="detail-row">
                                <span class="label">Date</span>
                                <span class="value">
                                    <%= booking.getRide().getFormattedDate() %>
                                </span>
                            </div>
                            <div class="detail-row">
                                <span class="label">Time</span>
                                <span class="value">
                                    <%= booking.getRide().getFormattedTime() %>
                                </span>
                            </div>
                            <div class="detail-row">
                                <span class="label">Seats Booked</span>
                                <span class="value">
                                    <%= booking.getSeatsBooked() %>
                                </span>
                            </div>
                            <div class="detail-row">
                                <span class="label">Fare / Seat</span>
                                <span class="value">₹<%= String.format("%.2f", booking.getRide().getFare()) %></span>
                            </div>
                            <div class="detail-row">
                                <span class="label">Status</span>
                                <span class="value"><span class="badge badge-success">
                                        <%= booking.getStatus() %>
                                    </span></span>
                            </div>
                            <div class="detail-row total">
                                <span class="label">Total Paid</span>
                                <span class="value">₹<%= String.format("%.2f", totalAmount) %></span>
                            </div>
                        </div>

                        <div class="success-actions">
                            <a href="booking?action=myBookings" class="btn btn-primary">
                                <span class="ms">receipt_long</span> View Bookings
                            </a>
                            <a href="ride?action=search" class="btn btn-secondary">
                                <span class="ms">search</span> Book Another
                            </a>
                            <a href="dashboard.jsp" class="btn btn-secondary">
                                <span class="ms">home</span> Home
                            </a>
                        </div>

                        <div class="info-box">
                            <span class="ms">info</span>
                            Save your Booking ID <strong style="font-family:monospace; margin-left:0.25rem;">
                                <%= booking.getBookingId() %>
                            </strong> for reference.
                        </div>
                    </div>
                </div>

                <footer class="footer">
                    <div class="footer-brand"><span class="ms">directions_car</span> Cab Booking</div>
                    &nbsp;·&nbsp; &copy; 2026 All rights reserved.
                </footer>
            </body>

            </html>