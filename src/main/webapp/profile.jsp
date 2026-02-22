<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <%@ page import="com.cab.model.User" %>
        <% User currentUser=(User) session.getAttribute("user"); if (currentUser==null) {
            response.sendRedirect("login.jsp"); return; } int currentYear=java.time.LocalDate.now().getYear(); int
            currentMonth=java.time.LocalDate.now().getMonthValue(); String[]
            months={"January","February","March","April","May","June","July","August","September","October","November","December"};
            %>
            <!DOCTYPE html>
            <html lang="en">

            <head>
                <meta charset="UTF-8">
                <meta name="viewport" content="width=device-width, initial-scale=1.0">
                <title>Profile — Cab Booking</title>
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
                            <a href="user?action=profile" class="nav-link active">Profile</a>
                            <a href="user?action=logout" class="nav-link logout">Logout</a>
                        </div>
                    </div>
                </nav>

                <div class="container">
                    <div class="page-header">
                        <h1><span class="ms">account_circle</span> Profile</h1>
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

                                    <div class="profile-layout">
                                        <!-- Sidebar -->
                                        <div class="profile-sidebar">
                                            <div class="profile-card">
                                                <div class="profile-avatar"><span class="ms">person</span></div>
                                                <div class="profile-name">
                                                    <%= currentUser.getName() %>
                                                </div>
                                                <div class="profile-meta">
                                                    <%= currentUser.getEmail() %>
                                                </div>
                                                <div class="profile-meta">+91 <%= currentUser.getMobile() %>
                                                </div>

                                                <% boolean hasLicense=currentUser.isHasLicense(); boolean
                                                    expired=hasLicense && currentUser.isLicenseExpired(); boolean
                                                    verified=hasLicense && currentUser.isLicenseVerified(); %>
                                                    <% if (hasLicense && !expired) { %>
                                                        <div class="license-status <%= verified ? " verified"
                                                            : "pending" %>">
                                                            <span class="ms">
                                                                <%= verified ? "verified_user" : "pending" %>
                                                            </span>
                                                            <%= verified ? "License Verified" : "License Pending" %>
                                                        </div>
                                                        <% } else if (hasLicense && expired) { %>
                                                            <div class="license-status expired"><span
                                                                    class="ms">warning</span> License Expired</div>
                                                            <% } else { %>
                                                                <div class="license-status none"><span
                                                                        class="ms">id_card</span> No License</div>
                                                                <% } %>

                                                                    <% if (hasLicense) { %>
                                                                        <div class="profile-license-info">
                                                                            #<%= currentUser.getLicenseNumber() %><br>
                                                                                Expires <%=
                                                                                    months[currentUser.getLicenseExpiryMonth()-1]
                                                                                    %>
                                                                                    <%= currentUser.getLicenseExpiryYear()
                                                                                        %>
                                                                        </div>
                                                                        <% } %>
                                            </div>

                                            <!-- Quick nav -->
                                            <div class="card" style="padding:1rem;">
                                                <div style="display:flex; flex-direction:column; gap:0.35rem;">
                                                    <a href="ride?action=myRides"
                                                        style="display:flex; align-items:center; gap:0.6rem; text-decoration:none; color:var(--text-primary); font-size:0.875rem; font-weight:500; padding:0.5rem 0.6rem; border-radius:var(--radius-sm); transition:background var(--transition);"
                                                        onmouseover="this.style.background='var(--bg)'"
                                                        onmouseout="this.style.background=''">
                                                        <span class="ms"
                                                            style="font-size:1rem; color:var(--text-muted); top:0;">drive_eta</span>
                                                        My Rides
                                                    </a>
                                                    <a href="booking?action=myBookings"
                                                        style="display:flex; align-items:center; gap:0.6rem; text-decoration:none; color:var(--text-primary); font-size:0.875rem; font-weight:500; padding:0.5rem 0.6rem; border-radius:var(--radius-sm); transition:background var(--transition);"
                                                        onmouseover="this.style.background='var(--bg)'"
                                                        onmouseout="this.style.background=''">
                                                        <span class="ms"
                                                            style="font-size:1rem; color:var(--text-muted); top:0;">receipt_long</span>
                                                        My Bookings
                                                    </a>
                                                </div>
                                            </div>
                                        </div>

                                        <!-- Main -->
                                        <div class="profile-main">
                                            <!-- Edit Profile -->
                                            <div class="card">
                                                <h2 style="margin-bottom:1.25rem;">Personal Information</h2>
                                                <form action="user" method="POST">
                                                    <input type="hidden" name="action" value="updateProfile">
                                                    <div class="form-row-2">
                                                        <div class="form-group">
                                                            <label for="name">Full Name</label>
                                                            <input type="text" id="name" name="name" required
                                                                value="<%= currentUser.getName() %>">
                                                        </div>
                                                        <div class="form-group">
                                                            <label for="mobile">Mobile</label>
                                                            <input type="number" id="mobile" name="mobile" required
                                                                value="<%= currentUser.getMobile() %>">
                                                        </div>
                                                    </div>
                                                    <div class="form-group">
                                                        <label for="email">Email</label>
                                                        <input type="email" id="email"
                                                            value="<%= currentUser.getEmail() %>" disabled>
                                                        <small>Email cannot be changed</small>
                                                    </div>
                                                    <div class="form-actions">
                                                        <button type="submit" class="btn btn-primary"><span
                                                                class="ms">save</span> Save Changes</button>
                                                    </div>
                                                </form>
                                            </div>

                                            <!-- License Management -->
                                            <div class="card">
                                                <h2 style="margin-bottom:0.35rem;">Driving License</h2>
                                                <p class="text-muted"
                                                    style="font-size:0.875rem; margin-bottom:1.25rem;">
                                                    A valid license is required to post rides.
                                                </p>
                                                <form action="user" method="POST">
                                                    <input type="hidden" name="action" value="updateLicense">
                                                    <div class="form-group">
                                                        <label for="licenseNumber">License Number</label>
                                                        <input type="text" id="licenseNumber" name="licenseNumber"
                                                            placeholder="e.g., DL-1420110012345"
                                                            value="<%= currentUser.isHasLicense() ? currentUser.getLicenseNumber() : "" %>">
                                                    </div>
                                                    <div class="form-row-2">
                                                        <div class="form-group">
                                                            <label for="expiryMonth">Expiry Month</label>
                                                            <select id="expiryMonth" name="expiryMonth">
                                                                <option value="">Select month</option>
                                                                <% for (int m=1; m <=12; m++) { %>
                                                                    <option value="<%= m %>"
                                                                        <%=(currentUser.isHasLicense() &&
                                                                        currentUser.getLicenseExpiryMonth()==m)
                                                                        ? "selected" : "" %>>
                                                                        <%= months[m-1] %>
                                                                    </option>
                                                                    <% } %>
                                                            </select>
                                                        </div>
                                                        <div class="form-group">
                                                            <label for="expiryYear">Expiry Year</label>
                                                            <select id="expiryYear" name="expiryYear">
                                                                <option value="">Select year</option>
                                                                <% for (int y=currentYear - 5; y <=currentYear + 20;
                                                                    y++) { %>
                                                                    <option value="<%= y %>"
                                                                        <%=(currentUser.isHasLicense() &&
                                                                        currentUser.getLicenseExpiryYear()==y)
                                                                        ? "selected" : "" %>>
                                                                        <%= y %>
                                                                    </option>
                                                                    <% } %>
                                                            </select>
                                                        </div>
                                                    </div>
                                                    <div class="form-actions">
                                                        <button type="submit" class="btn btn-primary"><span
                                                                class="ms">id_card</span> Update License</button>
                                                    </div>
                                                </form>
                                            </div>

                                            <!-- Danger Zone -->
                                            <div class="danger-zone">
                                                <h3><span class="ms">warning</span> Danger Zone</h3>
                                                <p>Logging out will end your current session. This does not delete your
                                                    account.</p>
                                                <a href="user?action=logout" class="btn btn-danger btn-sm"><span
                                                        class="ms">logout</span> Logout</a>
                                            </div>
                                        </div>
                                    </div>
                </div>

                <footer class="footer">
                    <div class="footer-brand"><span class="ms">directions_car</span> Cab Booking</div>
                    &nbsp;·&nbsp; &copy; 2026 All rights reserved.
                </footer>
            </body>

            </html>