<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <%@ page import="com.cab.model.User" %>
        <% User currentUser=(User) session.getAttribute("user"); if (currentUser==null) {
            response.sendRedirect("login.jsp"); return; } %>
            <!DOCTYPE html>
            <html lang="en">

            <head>
                <meta charset="UTF-8">
                <meta name="viewport" content="width=device-width, initial-scale=1.0">
                <title>Create Ride — Cab Booking</title>
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
                                    <span class="ms" style="font-size:1.1rem;">add_circle</span>
                                </div>
                                <h1 style="font-size:1.3rem;">Post a Ride</h1>
                            </div>
                            <p class="text-muted">Share your journey and earn from empty seats.</p>
                        </div>

                        <% if (request.getAttribute("errorMessage") !=null) { %>
                            <div class="alert alert-error"><span class="ms">error</span>
                                <%= request.getAttribute("errorMessage") %>
                            </div>
                            <% } %>

                                <form action="ride" method="POST">
                                    <input type="hidden" name="action" value="create">

                                    <div class="form-row-2">
                                        <div class="form-group">
                                            <label for="source">From</label>
                                            <input type="text" id="source" name="source" required
                                                placeholder="e.g., Mumbai">
                                        </div>
                                        <div class="form-group">
                                            <label for="destination">To</label>
                                            <input type="text" id="destination" name="destination" required
                                                placeholder="e.g., Pune">
                                        </div>
                                    </div>

                                    <div class="form-row-2">
                                        <div class="form-group">
                                            <label for="rideDate">Date</label>
                                            <input type="date" id="rideDate" name="rideDate" required>
                                        </div>
                                        <div class="form-group">
                                            <label for="rideTime">Departure Time</label>
                                            <input type="time" id="rideTime" name="rideTime" required>
                                        </div>
                                    </div>

                                    <div class="form-row-2">
                                        <div class="form-group">
                                            <label for="totalSeats">Available Seats</label>
                                            <input type="number" id="totalSeats" name="totalSeats" required min="1"
                                                max="10" placeholder="e.g., 4">
                                            <small>Maximum 10 seats</small>
                                        </div>
                                        <div class="form-group">
                                            <label for="fare">Fare per Seat (₹)</label>
                                            <input type="number" id="fare" name="fare" required min="1" step="0.01"
                                                placeholder="e.g., 500">
                                        </div>
                                    </div>

                                    <div class="form-actions">
                                        <button type="submit" class="btn btn-primary btn-lg"
                                            style="flex:1; justify-content:center;">
                                            <span class="ms">directions_car</span> Post Ride
                                        </button>
                                        <a href="dashboard.jsp" class="btn btn-secondary">Cancel</a>
                                    </div>
                                </form>
                    </div>
                </div>

                <script>
                    const dateInput = document.getElementById('rideDate');
                    const timeInput = document.getElementById('rideTime');
                    const today = new Date().toISOString().split('T')[0];
                    dateInput.min = today;
                    dateInput.value = today;
                    dateInput.addEventListener('change', () => {
                        if (dateInput.value === today) {
                            const now = new Date();
                            timeInput.min = String(now.getHours()).padStart(2, '0') + ':' + String(now.getMinutes()).padStart(2, '0');
                        } else { timeInput.min = ''; }
                    });
                </script>

                <footer class="footer">
                    <div class="footer-brand"><span class="ms">directions_car</span> Cab Booking</div>
                    &nbsp;·&nbsp; &copy; Java Project Made By Aditya Pandey.
                </footer>
            </body>

            </html>