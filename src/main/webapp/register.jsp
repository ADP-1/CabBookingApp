<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <!DOCTYPE html>
    <html lang="en">

    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Create Account — Cab Booking</title>
        <link rel="preconnect" href="https://fonts.googleapis.com">
        <link rel="stylesheet"
            href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700;800&family=Material+Symbols+Rounded:opsz,wght,FILL,GRAD@24,400,1,0&display=swap">
        <link rel="stylesheet" href="css/style.css">
    </head>

    <body>
        <!-- Minimal top nav bar -->
        <div
            style="position:fixed; top:0; left:0; right:0; height:var(--nav-h); background:var(--bg-structure); display:flex; align-items:center; padding:0 1.5rem; z-index:100;">
            <div style="display:inline-flex; align-items:center; gap:0.55rem;">
                <div class="nav-brand-icon"><span class="ms">directions_car</span></div>
                <span style="font-weight:700; color:#fff; font-size:1rem;">Cab Booking</span>
            </div>
        </div>

        <div class="container" style="padding-top:calc(var(--nav-h) + 2rem); padding-bottom:3rem;">
            <div class="form-container" style="max-width:520px;">
                <div style="margin-bottom:1.75rem;">
                    <h1 style="font-size:1.5rem; margin-bottom:0.25rem;">Create your account</h1>
                    <p class="text-muted">Join thousands of riders and drivers.</p>
                </div>

                <% if (request.getAttribute("errorMessage") !=null) { %>
                    <div class="alert alert-error">
                        <span class="ms">error</span>
                        <%= request.getAttribute("errorMessage") %>
                    </div>
                    <% } %>

                        <form action="user" method="POST" onsubmit="return validateForm()">
                            <input type="hidden" name="action" value="register">

                            <div class="form-group">
                                <label for="name">Full Name</label>
                                <input type="text" id="name" name="name" required placeholder="Jane Doe">
                            </div>

                            <div class="form-group">
                                <label for="email">Email</label>
                                <input type="email" id="email" name="email" required placeholder="you@example.com">
                            </div>

                            <div class="form-group">
                                <label for="mobile">Mobile Number</label>
                                <input type="number" id="mobile" name="mobile" required placeholder="10-digit number">
                            </div>

                            <div class="form-row-2">
                                <div class="form-group">
                                    <label for="password">Password</label>
                                    <input type="password" id="password" name="password" required
                                        placeholder="Min 6 characters">
                                </div>
                                <div class="form-group">
                                    <label for="confirmPassword">Confirm</label>
                                    <input type="password" id="confirmPassword" name="confirmPassword" required
                                        placeholder="Repeat password">
                                </div>
                            </div>

                            <!-- Driving License -->
                            <div class="license-section">
                                <div class="license-toggle">
                                    <input type="checkbox" id="hasLicense" name="hasLicense"
                                        onchange="toggleLicenseFields()">
                                    <label for="hasLicense" class="license-toggle-label">
                                        <span class="ms"
                                            style="font-size:1rem; color:var(--accent-mid); margin-right:0.25rem;">id_card</span>
                                        I have a driving license
                                    </label>
                                </div>
                                <p>Required to post rides as a driver.</p>

                                <div id="licenseFields" class="license-fields">
                                    <div class="form-group" style="margin-top:1rem;">
                                        <label for="licenseNumber">License Number</label>
                                        <input type="text" id="licenseNumber" name="licenseNumber"
                                            placeholder="e.g., DL-1420110012345">
                                    </div>
                                    <div class="form-row-2">
                                        <div class="form-group">
                                            <label for="expiryMonth">Expiry Month</label>
                                            <select id="expiryMonth" name="expiryMonth">
                                                <option value="">Month</option>
                                                <% String[]
                                                    months={"January","February","March","April","May","June","July","August","September","October","November","December"};
                                                    for (int m=1; m <=12; m++) { %>
                                                    <option value="<%= m %>">
                                                        <%= months[m-1] %>
                                                    </option>
                                                    <% } %>
                                            </select>
                                        </div>
                                        <div class="form-group">
                                            <label for="expiryYear">Expiry Year</label>
                                            <select id="expiryYear" name="expiryYear">
                                                <option value="">Year</option>
                                                <% int cy=java.time.LocalDate.now().getYear(); for (int y=cy; y <=cy +
                                                    20; y++) { %>
                                                    <option value="<%= y %>">
                                                        <%= y %>
                                                    </option>
                                                    <% } %>
                                            </select>
                                        </div>
                                    </div>
                                </div>
                            </div>

                            <button type="submit" class="btn btn-primary btn-lg"
                                style="width:100%; justify-content:center;">
                                Create Account <span class="ms">arrow_forward</span>
                            </button>
                        </form>

                        <div class="form-footer">
                            Already have an account? <a href="login.jsp">Sign in</a>
                        </div>
            </div>
        </div>

        <footer class="footer">
            <div class="footer-brand"><span class="ms">directions_car</span> Cab Booking</div>
            &nbsp;·&nbsp; &copy; Java Project Made By Aditya Pandey.
        </footer>

        <script>
            function toggleLicenseFields() {
                const cb = document.getElementById('hasLicense');
                const fields = document.getElementById('licenseFields');
                const ln = document.getElementById('licenseNumber');
                const em = document.getElementById('expiryMonth');
                const ey = document.getElementById('expiryYear');
                if (cb.checked) {
                    fields.classList.add('active');
                    ln.required = em.required = ey.required = true;
                } else {
                    fields.classList.remove('active');
                    ln.required = em.required = ey.required = false;
                    ln.value = ''; em.value = ''; ey.value = '';
                }
            }
            function validateForm() {
                const pwd = document.getElementById('password').value;
                const cpwd = document.getElementById('confirmPassword').value;
                const mob = document.getElementById('mobile').value;
                if (pwd.length < 6) { alert('Password must be at least 6 characters.'); return false; }
                if (pwd !== cpwd) { alert('Passwords do not match.'); return false; }
                if (mob.length !== 10) { alert('Mobile number must be 10 digits.'); return false; }
                if (document.getElementById('hasLicense').checked) {
                    const ln = document.getElementById('licenseNumber').value;
                    const em = document.getElementById('expiryMonth').value;
                    const ey = document.getElementById('expiryYear').value;
                    if (!ln || !em || !ey) { alert('Please fill all license details.'); return false; }
                    const now = new Date();
                    if (parseInt(ey) < now.getFullYear() ||
                        (parseInt(ey) === now.getFullYear() && parseInt(em) < now.getMonth() + 1)) {
                        alert('License is expired!'); return false;
                    }
                }
                return true;
            }
        </script>
    </body>

    </html>