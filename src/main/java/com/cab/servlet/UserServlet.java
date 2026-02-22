package com.cab.servlet;

import com.cab.dao.UserDAO;
import com.cab.model.User;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;

/**
 * Servlet for handling user-related operations
 * - Registration (with optional driving license)
 * - Login / Logout
 * - Profile Update
 * - License Update
 * - Account Deletion
 */
@WebServlet("/user")
public class UserServlet extends HttpServlet {

    private UserDAO userDAO;

    @Override
    public void init() {
        userDAO = new UserDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String action = request.getParameter("action");
        if (action == null)
            action = "login";

        switch (action) {
            case "logout":
                handleLogout(request, response);
                break;
            case "profile":
                showProfile(request, response);
                break;
            case "delete":
                showDeleteConfirm(request, response);
                break;
            default:
                response.sendRedirect("login.jsp");
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String action = request.getParameter("action");
        if (action == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        switch (action) {
            case "register":
                handleRegister(request, response);
                break;
            case "login":
                handleLogin(request, response);
                break;
            case "update":
                handleUpdate(request, response);
                break;
            case "updateLicense":
                handleUpdateLicense(request, response);
                break;
            case "deleteConfirm":
                handleDelete(request, response);
                break;
            default:
                response.sendRedirect("login.jsp");
        }
    }

    // -------------------------------------------------------------------------
    // Handlers
    // -------------------------------------------------------------------------

    private void handleRegister(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String name = request.getParameter("name");
        String email = request.getParameter("email");
        String mobileStr = request.getParameter("mobile");
        String password = request.getParameter("password");
        String confirmPassword = request.getParameter("confirmPassword");

        // Basic validation
        if (name == null || email == null || mobileStr == null || password == null ||
                name.trim().isEmpty() || email.trim().isEmpty()) {
            request.setAttribute("errorMessage", "All fields are required!");
            request.getRequestDispatcher("register.jsp").forward(request, response);
            return;
        }

        if (!password.equals(confirmPassword)) {
            request.setAttribute("errorMessage", "Passwords do not match!");
            request.getRequestDispatcher("register.jsp").forward(request, response);
            return;
        }

        if (userDAO.emailExists(email.trim())) {
            request.setAttribute("errorMessage", "Email already registered!");
            request.getRequestDispatcher("register.jsp").forward(request, response);
            return;
        }

        try {
            long mobile = Long.parseLong(mobileStr.trim());

            User user = new User();
            user.setName(name.trim());
            user.setEmail(email.trim());
            user.setMobile(mobile);
            user.setPwd(password);

            // Optional driving license
            String hasLicenseParam = request.getParameter("hasLicense");
            boolean hasLicense = "on".equals(hasLicenseParam) || "true".equals(hasLicenseParam);
            user.setHasLicense(hasLicense);

            if (hasLicense) {
                String licenseNumber = request.getParameter("licenseNumber");
                String expiryMonthStr = request.getParameter("expiryMonth");
                String expiryYearStr = request.getParameter("expiryYear");

                if (licenseNumber != null && !licenseNumber.trim().isEmpty() &&
                        expiryMonthStr != null && expiryYearStr != null) {
                    user.setLicenseNumber(licenseNumber.trim());
                    user.setLicenseExpiryMonth(Integer.parseInt(expiryMonthStr));
                    user.setLicenseExpiryYear(Integer.parseInt(expiryYearStr));
                } else {
                    // Missing license details — register without license
                    user.setHasLicense(false);
                }
            }

            boolean success = userDAO.registerUser(user);

            if (success) {
                request.setAttribute("successMessage", "Registration successful! Please login.");
                request.getRequestDispatcher("login.jsp").forward(request, response);
            } else {
                request.setAttribute("errorMessage", "Registration failed. Please try again.");
                request.getRequestDispatcher("register.jsp").forward(request, response);
            }

        } catch (NumberFormatException e) {
            request.setAttribute("errorMessage", "Invalid mobile number or license expiry!");
            request.getRequestDispatcher("register.jsp").forward(request, response);
        }
    }

    private void handleLogin(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String email = request.getParameter("email");
        String password = request.getParameter("password");

        if (email == null || password == null) {
            request.setAttribute("errorMessage", "Email and password are required!");
            request.getRequestDispatcher("login.jsp").forward(request, response);
            return;
        }

        User user = userDAO.loginUser(email.trim(), password);

        if (user != null) {
            HttpSession session = request.getSession();
            session.setAttribute("user", user);
            session.setAttribute("userId", user.getUserId());
            session.setAttribute("userName", user.getName());
            session.setAttribute("userEmail", user.getEmail());
            response.sendRedirect("dashboard.jsp");
        } else {
            request.setAttribute("errorMessage", "Invalid email or password!");
            request.getRequestDispatcher("login.jsp").forward(request, response);
        }
    }

    private void handleLogout(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        if (session != null)
            session.invalidate();
        response.sendRedirect("login.jsp");
    }

    private void showProfile(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            response.sendRedirect("login.jsp");
            return;
        }
        request.getRequestDispatcher("profile.jsp").forward(request, response);
    }

    private void handleUpdate(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        User currentUser = (User) session.getAttribute("user");
        String name = request.getParameter("name");
        String email = request.getParameter("email");
        String mobileStr = request.getParameter("mobile");

        try {
            long mobile = Long.parseLong(mobileStr.trim());

            currentUser.setName(name.trim());
            currentUser.setEmail(email.trim());
            currentUser.setMobile(mobile);

            boolean success = userDAO.updateUser(currentUser);

            if (success) {
                session.setAttribute("user", currentUser);
                session.setAttribute("userName", name.trim());
                session.setAttribute("userEmail", email.trim());
                request.setAttribute("successMessage", "Profile updated successfully!");
            } else {
                request.setAttribute("errorMessage", "Update failed. Please try again.");
            }

        } catch (NumberFormatException e) {
            request.setAttribute("errorMessage", "Invalid mobile number!");
        }

        request.getRequestDispatcher("profile.jsp").forward(request, response);
    }

    /**
     * Handle driving license update from profile page
     */
    private void handleUpdateLicense(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        User currentUser = (User) session.getAttribute("user");
        String licenseNumber = request.getParameter("licenseNumber");
        String expiryMonthStr = request.getParameter("expiryMonth");
        String expiryYearStr = request.getParameter("expiryYear");

        if (licenseNumber == null || licenseNumber.trim().isEmpty() ||
                expiryMonthStr == null || expiryYearStr == null) {
            request.setAttribute("errorMessage", "All license fields are required!");
            request.getRequestDispatcher("profile.jsp").forward(request, response);
            return;
        }

        try {
            int expiryMonth = Integer.parseInt(expiryMonthStr);
            int expiryYear = Integer.parseInt(expiryYearStr);

            boolean success = userDAO.updateLicense(
                    currentUser.getUserId(), licenseNumber.trim(), expiryMonth, expiryYear);

            if (success) {
                // Refresh user in session
                User refreshed = userDAO.getUserById(currentUser.getUserId());
                if (refreshed != null)
                    session.setAttribute("user", refreshed);
                request.setAttribute("successMessage", "Driving license updated successfully!");
            } else {
                request.setAttribute("errorMessage", "Failed to update license.");
            }

        } catch (NumberFormatException e) {
            request.setAttribute("errorMessage", "Invalid month or year!");
        }

        request.getRequestDispatcher("profile.jsp").forward(request, response);
    }

    private void showDeleteConfirm(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            response.sendRedirect("login.jsp");
            return;
        }
        request.getRequestDispatcher("delete-account.jsp").forward(request, response);
    }

    private void handleDelete(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        User currentUser = (User) session.getAttribute("user");
        String confirmation = request.getParameter("confirmation");

        if (confirmation != null && confirmation.equalsIgnoreCase("DELETE")) {
            boolean success = userDAO.deleteUser(currentUser.getUserId());

            if (success) {
                session.invalidate();
                request.setAttribute("successMessage", "Account deleted successfully.");
                request.getRequestDispatcher("login.jsp").forward(request, response);
            } else {
                request.setAttribute("errorMessage", "Failed to delete account.");
                request.getRequestDispatcher("delete-account.jsp").forward(request, response);
            }
        } else {
            request.setAttribute("errorMessage", "Please type DELETE to confirm.");
            request.getRequestDispatcher("delete-account.jsp").forward(request, response);
        }
    }
}
