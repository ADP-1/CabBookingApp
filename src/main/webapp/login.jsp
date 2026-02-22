<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <!DOCTYPE html>
    <html lang="en">

    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Sign In — Cab Booking</title>
        <link rel="preconnect" href="https://fonts.googleapis.com">
        <link rel="stylesheet"
            href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700;800&family=Material+Symbols+Rounded:opsz,wght,FILL,GRAD@24,400,1,0&display=swap">
        <link rel="stylesheet" href="css/style.css">
    </head>

    <body style="display:flex; flex-direction:column; min-height:100vh; background:var(--bg-structure);">
        <!-- Top strip -->
        <div style="padding:1.25rem 1.5rem;">
            <div style="display:inline-flex; align-items:center; gap:0.55rem;">
                <div class="nav-brand-icon"><span class="ms">directions_car</span></div>
                <span style="font-weight:700; color:#fff; font-size:1rem;">Cab Booking</span>
            </div>
        </div>

        <!-- Main split -->
        <div style="flex:1; display:flex; align-items:center; justify-content:center; padding:1rem;">
            <div style="width:100%; max-width:420px;">
                <!-- Heading on dark -->
                <div style="text-align:left; margin-bottom:2rem;">
                    <h1
                        style="color:#fff; font-size:2rem; font-weight:800; letter-spacing:-0.03em; margin-bottom:0.3rem;">
                        Good to see<br>you again.
                    </h1>
                    <p style="color:rgba(255,255,255,0.45); font-size:0.9rem;">Sign in to continue</p>
                </div>

                <!-- Card -->
                <div
                    style="background:var(--bg-surface); border:1px solid var(--border); border-radius:var(--radius-lg); padding:2rem; box-shadow:var(--shadow-lg);">
                    <% if (request.getAttribute("successMessage") !=null) { %>
                        <div class="alert alert-success">
                            <span class="ms">check_circle</span>
                            <%= request.getAttribute("successMessage") %>
                        </div>
                        <% } %>
                            <% if (request.getAttribute("errorMessage") !=null) { %>
                                <div class="alert alert-error">
                                    <span class="ms">error</span>
                                    <%= request.getAttribute("errorMessage") %>
                                </div>
                                <% } %>

                                    <form action="user" method="POST">
                                        <input type="hidden" name="action" value="login">

                                        <div class="form-group">
                                            <label for="email">Email</label>
                                            <input type="email" id="email" name="email" required
                                                placeholder="you@example.com" autofocus>
                                        </div>

                                        <div class="form-group">
                                            <label for="password">Password</label>
                                            <input type="password" id="password" name="password" required
                                                placeholder="••••••••">
                                        </div>

                                        <button type="submit" class="btn btn-primary btn-lg"
                                            style="width:100%; justify-content:center; margin-top:0.5rem;">
                                            Sign In <span class="ms">arrow_forward</span>
                                        </button>
                                    </form>

                                    <div class="form-footer" style="margin-top:1.25rem;">
                                        Don't have an account? <a href="register.jsp">Create one</a>
                                    </div>
                </div>
            </div>
        </div>

        <footer class="footer"
            style="background:transparent; border-top:1px solid rgba(255,255,255,0.07); color:rgba(255,255,255,0.3);">
            &copy; Java Project Made By Aditya Pandey
        </footer>
    </body>

    </html>