<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <%@ page import="com.cab.model.User, com.cab.model.Ride, java.util.List" %>
        <% User currentUser=(User) session.getAttribute("user"); if (currentUser==null) {
            response.sendRedirect("login.jsp"); return; } List<Ride> rides = (List<Ride>) request.getAttribute("rides");
                %>
                <!DOCTYPE html>
                <html lang="en">

                <head>
                    <meta charset="UTF-8">
                    <meta name="viewport" content="width=device-width, initial-scale=1.0">
                    <title>My Rides — Cab Booking</title>
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
                                <a href="ride?action=myRides" class="nav-link active">My Rides</a>
                                <a href="user?action=profile" class="nav-link">Profile</a>
                                <a href="user?action=logout" class="nav-link logout">Logout</a>
                            </div>
                        </div>
                    </nav>

                    <div class="container">
                        <div class="page-header">
                            <h1><span class="ms">drive_eta</span> My Rides</h1>
                            <a href="ride?action=create" class="btn btn-primary">
                                <span class="ms">add</span> Create Ride
                            </a>
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

                                        <% if (rides==null || rides.isEmpty()) { %>
                                            <div class="empty-state">
                                                <div class="empty-icon"><span class="ms">commute</span></div>
                                                <h2>No Rides Yet</h2>
                                                <p>Post a ride to start earning and help others get around.</p>
                                                <a href="ride?action=create" class="btn btn-primary"><span
                                                        class="ms">add</span> Create Your First Ride</a>
                                            </div>
                                            <% } else { %>
                                                <div class="rides-grid">
                                                    <% for (Ride ride : rides) { %>
                                                        <div class="ride-card <%= ride.getStatus().equals(" CANCELLED")
                                                            ? "cancelled" : "" %>">
                                                            <div class="ride-header">
                                                                <div class="ride-route">
                                                                    <%= ride.getSource() %>
                                                                        <span class="route-arrow">→</span>
                                                                        <%= ride.getDestination() %>
                                                                </div>
                                                                <span
                                                                    class="badge badge-<%= ride.getStatus().equals('ACTIVE') ? "
                                                                    success" : "danger" %>">
                                                                    <%= ride.getStatus() %>
                                                                </span>
                                                            </div>
                                                            <div class="ride-details">
                                                                <div class="detail-item"><span
                                                                        class="ms">calendar_today</span><strong>Date</strong>
                                                                    <%= ride.getFormattedDate() %>
                                                                </div>
                                                                <div class="detail-item"><span
                                                                        class="ms">schedule</span><strong>Time</strong>
                                                                    <%= ride.getFormattedTime() %>
                                                                </div>
                                                                <div class="detail-item"><span
                                                                        class="ms">currency_rupee</span><strong>Fare</strong>₹
                                                                    <%= String.format("%.2f", ride.getFare()) %> / seat
                                                                </div>
                                                                <div class="detail-item"><span
                                                                        class="ms">event_seat</span><strong>Seats</strong>
                                                                    <%= ride.getAvailableSeats() %> available of <%=
                                                                            ride.getTotalSeats() %>
                                                                </div>
                                                                <div class="detail-item"><span
                                                                        class="ms">people</span><strong>Booked</strong>
                                                                    <%= ride.getTotalSeats() - ride.getAvailableSeats()
                                                                        %> passengers
                                                                </div>
                                                            </div>
                                                            <% if (ride.getStatus().equals("ACTIVE")) { %>
                                                                <div class="ride-actions">
                                                                    <a href="ride?action=edit&rideId=<%= ride.getRideId() %>"
                                                                        class="btn btn-secondary btn-sm">
                                                                        <span class="ms">edit</span> Edit
                                                                    </a>
                                                                    <form action="ride" method="POST"
                                                                        style="display:inline;"
                                                                        onsubmit="return confirm('Cancel this ride? All bookings will be voided.');">
                                                                        <input type="hidden" name="action"
                                                                            value="cancel">
                                                                        <input type="hidden" name="rideId"
                                                                            value="<%= ride.getRideId() %>">
                                                                        <button type="submit"
                                                                            class="btn btn-danger btn-sm"><span
                                                                                class="ms">cancel</span> Cancel</button>
                                                                    </form>
                                                                </div>
                                                                <% } else { %>
                                                                    <div class="ride-actions">
                                                                        <button class="btn btn-secondary btn-sm"
                                                                            disabled><span class="ms">block</span>
                                                                            Cancelled</button>
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