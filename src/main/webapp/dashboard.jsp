<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <%@ page import="com.cab.model.User" %>
        <% User currentUser=(User) session.getAttribute("user"); if (currentUser==null) {
            response.sendRedirect("login.jsp"); return; } %>
            <!DOCTYPE html>
            <html lang="en">

            <head>
                <meta charset="UTF-8">
                <meta name="viewport" content="width=device-width, initial-scale=1.0">
                <title>Dashboard — Cab Booking</title>
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
                            <a href="dashboard.jsp" class="nav-link active">Dashboard</a>
                            <a href="ride?action=search" class="nav-link">Search</a>
                            <a href="booking?action=myBookings" class="nav-link">Bookings</a>
                            <a href="ride?action=myRides" class="nav-link">My Rides</a>
                            <a href="user?action=profile" class="nav-link">Profile</a>
                            <a href="user?action=logout" class="nav-link logout">Logout</a>
                        </div>
                    </div>
                </nav>

                <div class="container">
                    <!-- Hero -->
                    <div class="dashboard-hero">
                        <div>
                            <h1>Hello, <%= currentUser.getName().split(" ")[0] %>.</h1>
                <p>Where are you headed today?</p>
            </div>
            <a href=" ride?action=search" class="btn btn-primary btn-lg">
                                    <span class="ms">search</span> Find a Ride
                                    </a>
                        </div>

                        <% if (request.getAttribute("errorMessage") !=null) { %>
                            <div class="alert alert-error">
                                <span class="ms">error</span>
                                <%= request.getAttribute("errorMessage") %>
                            </div>
                            <% } %>

                                <!-- Quick-action cards → 70% light surface -->
                                <div class="dashboard-grid">
                                    <a href="ride?action=search" class="dash-card">
                                        <div class="dash-card-icon"><span class="ms">search</span></div>
                                        <h3>Search Rides</h3>
                                        <p>Find rides to your destination</p>
                                        <div class="dash-card-arrow">Explore <span class="ms">arrow_forward</span></div>
                                    </a>

                                    <a href="ride?action=create" class="dash-card">
                                        <div class="dash-card-icon"><span class="ms">add_circle</span></div>
                                        <h3>Offer a Ride</h3>
                                        <p>Post a ride and share your journey</p>
                                        <div class="dash-card-arrow">Create <span class="ms">arrow_forward</span></div>
                                    </a>

                                    <a href="booking?action=myBookings" class="dash-card">
                                        <div class="dash-card-icon"><span class="ms">receipt_long</span></div>
                                        <h3>My Bookings</h3>
                                        <p>Track and manage your bookings</p>
                                        <div class="dash-card-arrow">View <span class="ms">arrow_forward</span></div>
                                    </a>

                                    <a href="ride?action=myRides" class="dash-card">
                                        <div class="dash-card-icon"><span class="ms">drive_eta</span></div>
                                        <h3>My Rides</h3>
                                        <p>Manage rides you created</p>
                                        <div class="dash-card-arrow">Manage <span class="ms">arrow_forward</span></div>
                                    </a>

                                    <a href="user?action=profile" class="dash-card">
                                        <div class="dash-card-icon"><span class="ms">account_circle</span></div>
                                        <h3>Profile</h3>
                                        <p>Update your info and license</p>
                                        <div class="dash-card-arrow">Edit <span class="ms">arrow_forward</span></div>
                                    </a>

                                    <a href="ride?action=viewAll" class="dash-card">
                                        <div class="dash-card-icon"><span class="ms">map</span></div>
                                        <h3>Browse All Rides</h3>
                                        <p>See every available ride</p>
                                        <div class="dash-card-arrow">Browse <span class="ms">arrow_forward</span></div>
                                    </a>
                                </div>
                    </div>

                    <footer class="footer">
                        <div class="footer-brand"><span class="ms">directions_car</span> Cab Booking</div>
                        &nbsp;·&nbsp; &copy; Java Project Made By Aditya Pandey.
                    </footer>
            </body>

            </html>