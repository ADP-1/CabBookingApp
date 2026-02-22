<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <%@ page import="com.cab.model.User, com.cab.model.Ride" %>
        <% User currentUser=(User) session.getAttribute("user"); if (currentUser==null) {
            response.sendRedirect("login.jsp"); return; } Ride ride=(Ride) request.getAttribute("ride"); if (ride==null)
            { response.sendRedirect("ride?action=myRides"); return; } %>
            <!DOCTYPE html>
            <html lang="en">

            <head>
                <meta charset="UTF-8">
                <meta name="viewport" content="width=device-width, initial-scale=1.0">
                <title>Edit Ride — Cab Booking</title>
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
                    <div class="form-container">
                        <div style="margin-bottom:1.5rem;">
                            <div style="display:flex; align-items:center; gap:0.6rem; margin-bottom:0.3rem;">
                                <div class="nav-brand-icon" style="width:38px; height:38px; border-radius:9px;">
                                    <span class="ms" style="font-size:1.1rem;">edit</span>
                                </div>
                                <h1 style="font-size:1.3rem;">Edit Ride</h1>
                            </div>
                            <p class="text-muted">Update your ride details.</p>
                        </div>

                        <% if (request.getAttribute("errorMessage") !=null) { %>
                            <div class="alert alert-error"><span class="ms">error</span>
                                <%= request.getAttribute("errorMessage") %>
                            </div>
                            <% } %>

                                <form action="ride" method="POST">
                                    <input type="hidden" name="action" value="update">
                                    <input type="hidden" name="rideId" value="<%= ride.getRideId() %>">

                                    <div class="form-row-2">
                                        <div class="form-group">
                                            <label for="source">From</label>
                                            <input type="text" id="source" name="source" required
                                                value="<%= ride.getSource() %>">
                                        </div>
                                        <div class="form-group">
                                            <label for="destination">To</label>
                                            <input type="text" id="destination" name="destination" required
                                                value="<%= ride.getDestination() %>">
                                        </div>
                                    </div>

                                    <div class="form-row-2">
                                        <div class="form-group">
                                            <label for="rideDate">Ride Date</label>
                                            <input type="date" id="rideDate" name="rideDate"
                                                value="<%= ride.getRideDateForInput() != null ? ride.getRideDateForInput() : "" %>">
                                        </div>
                                        <div class="form-group">
                                            <label for="rideTime">Departure Time</label>
                                            <input type="time" id="rideTime" name="rideTime"
                                                value="<%= ride.getRideTimeForInput() != null ? ride.getRideTimeForInput() : "" %>">
                                        </div>
                                    </div>

                                    <div class="form-row-2">
                                        <div class="form-group">
                                            <label>Total Seats</label>
                                            <input type="text" value="<%= ride.getTotalSeats() %>" disabled>
                                            <small>Cannot be changed after creation</small>
                                        </div>
                                        <div class="form-group">
                                            <label>Available Seats</label>
                                            <input type="text" value="<%= ride.getAvailableSeats() %>" disabled>
                                            <small>Auto-updated with bookings</small>
                                        </div>
                                    </div>

                                    <div class="form-group">
                                        <label for="fare">Fare per Seat (₹)</label>
                                        <input type="number" id="fare" name="fare" required min="1" step="0.01"
                                            value="<%= ride.getFare() %>">
                                    </div>

                                    <div class="form-actions">
                                        <button type="submit" class="btn btn-primary btn-lg"
                                            style="flex:1; justify-content:center;">
                                            <span class="ms">save</span> Save Changes
                                        </button>
                                        <a href="ride?action=myRides" class="btn btn-secondary">Cancel</a>
                                    </div>
                                </form>
                    </div>
                </div>

                <footer class="footer">
                    <div class="footer-brand"><span class="ms">directions_car</span> Cab Booking</div>
                    &nbsp;·&nbsp; &copy; 2026 All rights reserved.
                </footer>
            </body>

            </html>