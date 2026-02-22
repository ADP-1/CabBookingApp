<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <%@ page import="com.cab.model.User, com.cab.model.Booking, java.util.List" %>
        <% User currentUser=(User) session.getAttribute("user"); if (currentUser==null) {
            response.sendRedirect("login.jsp"); return; } List<Booking> bookings = (List<Booking>)
                request.getAttribute("bookings");
                %>
                <!DOCTYPE html>
                <html lang="en">

                <head>
                    <meta charset="UTF-8">
                    <meta name="viewport" content="width=device-width, initial-scale=1.0">
                    <title>My Bookings — Cab Booking</title>
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
                                <a href="booking?action=myBookings" class="nav-link active">Bookings</a>
                                <a href="ride?action=myRides" class="nav-link">My Rides</a>
                                <a href="user?action=profile" class="nav-link">Profile</a>
                                <a href="user?action=logout" class="nav-link logout">Logout</a>
                            </div>
                        </div>
                    </nav>

                    <div class="container">
                        <div class="page-header">
                            <h1><span class="ms">receipt_long</span> My Bookings</h1>
                        </div>

                        <% if (request.getAttribute("successMessage") !=null) { %>
                            <div class="alert alert-success"><span class="ms">check_circle</span>
                                <%= request.getAttribute("successMessage") %>
                            </div>
                            <% } %>
                                <% if (request.getAttribute("errorMessage") !=null) { %>
                                    <div class="alert alert-error"><span class="ms">error</span>
                                        <%= request.getAttribute("errorMessage") %>
                                    </div>
                                    <% } %>

                                        <% if (bookings==null || bookings.isEmpty()) { %>
                                            <div class="empty-state">
                                                <div class="empty-icon"><span class="ms">confirmation_number</span>
                                                </div>
                                                <h2>No Bookings Yet</h2>
                                                <p>You haven't booked any rides. Search for one and get going.</p>
                                                <a href="ride?action=search" class="btn btn-primary"><span
                                                        class="ms">search</span> Find a Ride</a>
                                            </div>
                                            <% } else { %>
                                                <div class="bookings-list">
                                                    <% for (Booking booking : bookings) { %>
                                                        <div class="booking-card">
                                                            <div class="booking-header">
                                                                <div>
                                                                    <div class="booking-route">
                                                                        <%= booking.getRide().getSource() %>
                                                                            <span class="route-arrow">→</span>
                                                                            <%= booking.getRide().getDestination() %>
                                                                    </div>
                                                                    <div class="booking-id">
                                                                        <span class="ms"
                                                                            style="font-size:0.8rem; top:0;">tag</span>
                                                                        <%= booking.getBookingId() %>
                                                                    </div>
                                                                </div>
                                                                <% String bClass="CONFIRMED"
                                                                    .equals(booking.getStatus()) ? "success" : "danger"
                                                                    ; %>
                                                                    <span class="badge badge-<%= bClass %>">
                                                                        <%= booking.getStatus() %>
                                                                    </span>
                                                            </div>

                                                            <div class="booking-details">
                                                                <div class="ride-details" style="margin-bottom:0;">
                                                                    <div class="detail-item"><span
                                                                            class="ms">calendar_today</span><strong>Date</strong>
                                                                        <%= booking.getRide().getFormattedDate() %>
                                                                    </div>
                                                                    <div class="detail-item"><span
                                                                            class="ms">schedule</span><strong>Time</strong>
                                                                        <%= booking.getRide().getFormattedTime() %>
                                                                    </div>
                                                                    <div class="detail-item"><span
                                                                            class="ms">event_seat</span><strong>Seats</strong>
                                                                        <%= booking.getSeatsBooked() %>
                                                                    </div>
                                                                    <div class="detail-item"><span
                                                                            class="ms">currency_rupee</span><strong>Fare/seat</strong>₹
                                                                        <%= String.format("%.2f",
                                                                            booking.getRide().getFare()) %>
                                                                    </div>
                                                                    <div class="detail-item"><span
                                                                            class="ms">payments</span><strong>Total</strong>₹
                                                                        <%= String.format("%.2f",
                                                                            booking.getRide().getFare() *
                                                                            booking.getSeatsBooked()) %>
                                                                    </div>
                                                                </div>
                                                            </div>

                                                            <% if (booking.getStatus().equals("CONFIRMED")) { %>
                                                                <div class="booking-actions">
                                                                    <form action="booking" method="POST"
                                                                        style="display:inline;"
                                                                        onsubmit="return confirm('Cancel this booking?');">
                                                                        <input type="hidden" name="action"
                                                                            value="cancel">
                                                                        <input type="hidden" name="bookingId"
                                                                            value="<%= booking.getBookingId() %>">
                                                                        <button type="submit"
                                                                            class="btn btn-danger btn-sm"><span
                                                                                class="ms">cancel</span> Cancel
                                                                            Booking</button>
                                                                    </form>
                                                                </div>
                                                                <% } %>
                                                        </div>
                                                        <% } %>
                                                </div>
                                                <% } %>
                    </div>

                    <footer class="footer">
                        <div class="footer-brand"><span class="ms">directions_car</span> Cab Booking</div>
                        &nbsp;·&nbsp; &copy; Java Project Made By Aditya Pandey.
                    </footer>
                </body>

                </html>