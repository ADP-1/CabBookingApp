<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <%@ page import="com.cab.model.User" %>
        <%@ page import="com.cab.model.Ride" %>
            <% User currentUser=(User) session.getAttribute("user"); if (currentUser==null) {
                response.sendRedirect("login.jsp"); return; } Ride ride=(Ride) request.getAttribute("ride"); if
                (ride==null) { response.sendRedirect("ride?action=search"); return; } %>
                <!DOCTYPE html>
                <html>

                <head>
                    <meta charset="UTF-8">
                    <meta name="viewport" content="width=device-width, initial-scale=1.0">
                    <title>Book Ride - Cab Booking System</title>
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
                        <h1>📋 Book Your Ride</h1>

                        <!-- Error Message -->
                        <% if (request.getAttribute("errorMessage") !=null) { %>
                            <div class="alert alert-error">
                                <%= request.getAttribute("errorMessage") %>
                            </div>
                            <% } %>

                                <div class="booking-container">
                                    <!-- Ride Details Card -->
                                    <div class="ride-details-card">
                                        <h2>Ride Details</h2>

                                        <div class="detail-row">
                                            <div class="detail-label">Route:</div>
                                            <div class="detail-value">
                                                <strong>
                                                    <%= ride.getSource() %> → <%= ride.getDestination() %>
                                                </strong>
                                            </div>
                                        </div>

                                        <div class="detail-row">
                                            <div class="detail-label">Driver:</div>
                                            <div class="detail-value">
                                                <%= ride.getCreatedBy().getName() %>
                                            </div>
                                        </div>

                                        <div class="detail-row">
                                            <div class="detail-label">Fare per Seat:</div>
                                            <div class="detail-value">₹<%= String.format("%.2f", ride.getFare()) %>
                                            </div>
                                        </div>

                                        <div class="detail-row">
                                            <div class="detail-label">Available Seats:</div>
                                            <div class="detail-value">
                                                <%= ride.getAvailableSeats() %> / <%= ride.getTotalSeats() %>
                                            </div>
                                        </div>
                                    </div>

                                    <!-- Booking Form Card -->
                                    <div class="booking-form-card">
                                        <h2>Confirm Booking</h2>

                                        <form action="booking" method="POST">
                                            <input type="hidden" name="action" value="create">
                                            <input type="hidden" name="rideId" value="<%= ride.getRideId() %>">

                                            <div class="form-group">
                                                <label for="seats">Number of Seats:</label>
                                                <select id="seats" name="seats" required onchange="updateTotal()">
                                                    <option value="">Select seats</option>
                                                    <% for (int i=1; i <=ride.getAvailableSeats() && i <=5; i++) { %>
                                                        <option value="<%= i %>">
                                                            <%= i %> seat<%= i> 1 ? "s" : "" %>
                                                        </option>
                                                        <% } %>
                                                </select>
                                            </div>

                                            <div class="booking-summary">
                                                <div class="summary-row">
                                                    <span>Fare per seat:</span>
                                                    <span>₹<%= String.format("%.2f", ride.getFare()) %></span>
                                                </div>
                                                <div class="summary-row">
                                                    <span>Number of seats:</span>
                                                    <span id="selectedSeats">0</span>
                                                </div>
                                                <hr>
                                                <div class="summary-row total">
                                                    <strong>Total Amount:</strong>
                                                    <strong id="totalAmount">₹0.00</strong>
                                                </div>
                                            </div>

                                            <div class="form-actions">
                                                <button type="submit" class="btn btn-primary">Confirm Booking</button>
                                                <a href="ride?action=search" class="btn btn-secondary">Cancel</a>
                                            </div>
                                        </form>
                                    </div>
                                </div>
                    </div>

                    <footer class="footer">
                        <p>&copy; Java Project Made By Aditya Pandey. All rights reserved.</p>
                    </footer>

                    <script>
                        const farePerSeat = <%= ride.getFare() %>;

                        function updateTotal() {
                            const seats = parseInt(document.getElementById('seats').value) || 0;
                            const total = seats * farePerSeat;

                            document.getElementById('selectedSeats').textContent = seats;
                            document.getElementById('totalAmount').textContent = '₹' + total.toFixed(2);
                        }
                    </script>
                </body>

                </html>