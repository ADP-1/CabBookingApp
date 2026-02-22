<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Register - Cab Booking System</title>
    <link rel="stylesheet" href="css/style.css">
    <style>
        .license-section {
            background: #f8f9fa;
            padding: 1.5rem;
            border-radius: 8px;
            margin: 1.5rem 0;
        }
        .license-toggle {
            display: flex;
            align-items: center;
            gap: 0.5rem;
            margin-bottom: 1rem;
        }
        .license-toggle input[type="checkbox"] {
            width: auto;
        }
        .license-fields {
            display: none;
        }
        .license-fields.active {
            display: block;
        }
        .form-row-2 {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 1rem;
        }
    </style>
</head>
<body>
    <div class="container">
        <div class="form-container" style="max-width: 600px;">
            <h1>🚖 Cab Booking System</h1>
            <h2>Register</h2>
            
            <% if (request.getAttribute("errorMessage") != null) { %>
                <div class="alert alert-error">
                    <%= request.getAttribute("errorMessage") %>
                </div>
            <% } %>
            
            <form action="user" method="POST" onsubmit="return validateForm()">
                <input type="hidden" name="action" value="register">
                
                <!-- Basic Information -->
                <div class="form-group">
                    <label for="name">Full Name: *</label>
                    <input type="text" id="name" name="name" required 
                           placeholder="Enter your full name">
                </div>
                
                <div class="form-group">
                    <label for="email">Email: *</label>
                    <input type="email" id="email" name="email" required 
                           placeholder="Enter your email">
                </div>
                
                <div class="form-group">
                    <label for="mobile">Mobile Number: *</label>
                    <input type="number" id="mobile" name="mobile" required 
                           placeholder="Enter 10-digit mobile number">
                </div>
                
                <div class="form-group">
                    <label for="password">Password: *</label>
                    <input type="password" id="password" name="password" required 
                           placeholder="Enter password (min 6 characters)">
                </div>
                
                <div class="form-group">
                    <label for="confirmPassword">Confirm Password: *</label>
                    <input type="password" id="confirmPassword" name="confirmPassword" required 
                           placeholder="Re-enter password">
                </div>
                
                <!-- Driving License Section -->
                <div class="license-section">
                    <div class="license-toggle">
                        <input type="checkbox" id="hasLicense" name="hasLicense" 
                               onchange="toggleLicenseFields()">
                        <label for="hasLicense" style="margin: 0;">
                            <strong>I have a driving license (Optional)</strong>
                        </label>
                    </div>
                    <p style="color: #666; font-size: 0.9rem; margin: 0.5rem 0;">
                        Note: A valid driving license is required to create rides as a driver.
                    </p>
                    
                    <div id="licenseFields" class="license-fields">
                        <div class="form-group">
                            <label for="licenseNumber">License Number:</label>
                            <input type="text" id="licenseNumber" name="licenseNumber" 
                                   placeholder="e.g., DL-1420110012345">
                        </div>
                        
                        <div class="form-row-2">
                            <div class="form-group">
                                <label for="expiryMonth">Expiry Month:</label>
                                <select id="expiryMonth" name="expiryMonth">
                                    <option value="">Select Month</option>
                                    <option value="1">January</option>
                                    <option value="2">February</option>
                                    <option value="3">March</option>
                                    <option value="4">April</option>
                                    <option value="5">May</option>
                                    <option value="6">June</option>
                                    <option value="7">July</option>
                                    <option value="8">August</option>
                                    <option value="9">September</option>
                                    <option value="10">October</option>
                                    <option value="11">November</option>
                                    <option value="12">December</option>
                                </select>
                            </div>
                            
                            <div class="form-group">
                                <label for="expiryYear">Expiry Year:</label>
                                <select id="expiryYear" name="expiryYear">
                                    <option value="">Select Year</option>
                                    <% 
                                        int currentYear = java.time.LocalDate.now().getYear();
                                        for (int i = 0; i <= 20; i++) {
                                            int year = currentYear + i;
                                    %>
                                        <option value="<%= year %>"><%= year %></option>
                                    <% } %>
                                </select>
                            </div>
                        </div>
                    </div>
                </div>
                
                <button type="submit" class="btn btn-primary">Register</button>
            </form>
            
            <div class="form-footer">
                <p>Already have an account? <a href="login.jsp">Login here</a></p>
            </div>
        </div>
    </div>
    
    <script>
        function toggleLicenseFields() {
            const checkbox = document.getElementById('hasLicense');
            const fields = document.getElementById('licenseFields');
            const licenseNumber = document.getElementById('licenseNumber');
            const expiryMonth = document.getElementById('expiryMonth');
            const expiryYear = document.getElementById('expiryYear');
            
            if (checkbox.checked) {
                fields.classList.add('active');
                licenseNumber.required = true;
                expiryMonth.required = true;
                expiryYear.required = true;
            } else {
                fields.classList.remove('active');
                licenseNumber.required = false;
                expiryMonth.required = false;
                expiryYear.required = false;
                licenseNumber.value = '';
                expiryMonth.value = '';
                expiryYear.value = '';
            }
        }
        
        function validateForm() {
            const password = document.getElementById('password').value;
            const confirmPassword = document.getElementById('confirmPassword').value;
            const mobile = document.getElementById('mobile').value;
            const hasLicense = document.getElementById('hasLicense').checked;
            
            if (password.length < 6) {
                alert('Password must be at least 6 characters long');
                return false;
            }
            
            if (password !== confirmPassword) {
                alert('Passwords do not match');
                return false;
            }
            
            if (mobile.length !== 10) {
                alert('Mobile number must be 10 digits');
                return false;
            }
            
            // Validate license fields if checkbox is checked
            if (hasLicense) {
                const licenseNumber = document.getElementById('licenseNumber').value;
                const expiryMonth = document.getElementById('expiryMonth').value;
                const expiryYear = document.getElementById('expiryYear').value;
                
                if (!licenseNumber || !expiryMonth || !expiryYear) {
                    alert('Please fill all license details');
                    return false;
                }
                
                // Check if license is not expired
                const currentDate = new Date();
                const currentYear = currentDate.getFullYear();
                const currentMonth = currentDate.getMonth() + 1;
                
                if (parseInt(expiryYear) < currentYear) {
                    alert('License has already expired!');
                    return false;
                }
                
                if (parseInt(expiryYear) === currentYear && parseInt(expiryMonth) < currentMonth) {
                    alert('License has already expired!');
                    return false;
                }
            }
            
            return true;
        }
    </script>
</body>
</html>
