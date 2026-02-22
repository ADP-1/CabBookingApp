package com.cab.servlet;

import com.cab.dao.BookingDAO;
import com.cab.dao.RideDAO;
import com.cab.dao.UserDAO;
import com.cab.model.Ride;
import com.cab.model.User;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.time.LocalDate;
import java.time.LocalTime;
import java.util.List;

@WebServlet("/ride")
public class RideServlet extends HttpServlet {

    private RideDAO rideDAO;
    private BookingDAO bookingDAO;
    private UserDAO userDAO;

    @Override
    public void init() {
        rideDAO = new RideDAO();
        bookingDAO = new BookingDAO();
        userDAO = new UserDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String action = request.getParameter("action");
        if (action == null)
            action = "viewAll";

        switch (action) {
            case "myRides":
                viewMyRides(request, response);
                break;
            case "search":
                showSearchPage(request, response);
                break;
            case "create":
                showCreatePage(request, response);
                break;
            case "edit":
                showEditPage(request, response);
                break;
            case "viewAll":
            default:
                viewAllRides(request, response);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String action = request.getParameter("action");
        if (action == null) {
            response.sendRedirect("dashboard.jsp");
            return;
        }

        switch (action) {
            case "create":
                handleCreateRide(request, response);
                break;
            case "search":
                handleSearchRides(request, response);
                break;
            case "update":
                handleUpdateRide(request, response);
                break;
            case "cancel":
                handleCancelRide(request, response);
                break;
            default:
                response.sendRedirect("dashboard.jsp");
        }
    }

private void viewAllRides(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        List<Ride> rides = rideDAO.getAllRides();
        request.setAttribute("rides", rides);
        request.getRequestDispatcher("view-rides.jsp").forward(request, response);
    }

    private void viewMyRides(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        User currentUser = (User) session.getAttribute("user");
        List<Ride> myRides = rideDAO.getRidesByDriver(currentUser.getUserId());

        request.setAttribute("rides", myRides);
        request.getRequestDispatcher("my-rides.jsp").forward(request, response);
    }

    private void showSearchPage(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.getRequestDispatcher("search-rides.jsp").forward(request, response);
    }

    private void showCreatePage(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            response.sendRedirect("login.jsp");
            return;
        }

User currentUser = (User) session.getAttribute("user");
        if (!currentUser.canCreateRides()) {
            request.setAttribute("errorMessage",
                    "You need a valid driving license to create rides. " +
                            "Please update your license in your profile.");
            request.getRequestDispatcher("dashboard.jsp").forward(request, response);
            return;
        }

        request.getRequestDispatcher("create-ride.jsp").forward(request, response);
    }

    private void showEditPage(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        String rideIdStr = request.getParameter("rideId");
        if (rideIdStr == null) {
            response.sendRedirect("ride?action=myRides");
            return;
        }

        try {
            int rideId = Integer.parseInt(rideIdStr);
            Ride ride = rideDAO.getRideById(rideId);

            if (ride == null) {
                response.sendRedirect("ride?action=myRides");
                return;
            }

User currentUser = (User) session.getAttribute("user");
            if (ride.getCreatedBy().getUserId() != currentUser.getUserId()) {
                request.setAttribute("errorMessage", "You can only edit your own rides!");
                response.sendRedirect("ride?action=myRides");
                return;
            }

            request.setAttribute("ride", ride);
            request.getRequestDispatcher("edit-ride.jsp").forward(request, response);

        } catch (NumberFormatException e) {
            response.sendRedirect("ride?action=myRides");
        }
    }

private void handleCreateRide(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        User currentUser = (User) session.getAttribute("user");

if (!userDAO.canUserCreateRides(currentUser.getUserId())) {
            request.setAttribute("errorMessage",
                    "You need a valid driving license to create rides.");
            request.getRequestDispatcher("create-ride.jsp").forward(request, response);
            return;
        }

        String source = request.getParameter("source");
        String destination = request.getParameter("destination");
        String totalSeatsStr = request.getParameter("totalSeats");
        String fareStr = request.getParameter("fare");
        String rideDateStr = request.getParameter("rideDate");
        String rideTimeStr = request.getParameter("rideTime");

if (source == null || destination == null || totalSeatsStr == null ||
                fareStr == null || rideDateStr == null || rideTimeStr == null ||
                source.trim().isEmpty() || destination.trim().isEmpty() ||
                rideDateStr.trim().isEmpty() || rideTimeStr.trim().isEmpty()) {
            request.setAttribute("errorMessage", "All fields are required!");
            request.getRequestDispatcher("create-ride.jsp").forward(request, response);
            return;
        }

        try {
            int totalSeats = Integer.parseInt(totalSeatsStr);
            double fare = Double.parseDouble(fareStr);
            LocalDate rideDate = LocalDate.parse(rideDateStr); 
            LocalTime rideTime = LocalTime.parse(rideTimeStr); 

            if (totalSeats <= 0 || fare <= 0) {
                request.setAttribute("errorMessage", "Seats and fare must be positive numbers!");
                request.getRequestDispatcher("create-ride.jsp").forward(request, response);
                return;
            }

if (rideDate.isBefore(LocalDate.now()) ||
                    (rideDate.isEqual(LocalDate.now()) && rideTime.isBefore(LocalTime.now()))) {
                request.setAttribute("errorMessage", "Ride date/time cannot be in the past!");
                request.getRequestDispatcher("create-ride.jsp").forward(request, response);
                return;
            }

            Ride ride = new Ride(source.trim(), destination.trim(),
                    totalSeats, totalSeats, fare, rideDate, rideTime);
            int rideId = rideDAO.createRide(ride, currentUser.getUserId());

            if (rideId > 0) {
                response.sendRedirect("ride?action=myRides");
            } else {
                request.setAttribute("errorMessage", "Failed to create ride. Please try again.");
                request.getRequestDispatcher("create-ride.jsp").forward(request, response);
            }

        } catch (NumberFormatException e) {
            request.setAttribute("errorMessage", "Invalid number format for seats or fare!");
            request.getRequestDispatcher("create-ride.jsp").forward(request, response);
        } catch (Exception e) {
            request.setAttribute("errorMessage", "Invalid date or time format!");
            request.getRequestDispatcher("create-ride.jsp").forward(request, response);
        }
    }

    private void handleSearchRides(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String source = request.getParameter("source");
        String destination = request.getParameter("destination");
        String rideDateStr = request.getParameter("rideDate"); 

        if (source == null || destination == null ||
                source.trim().isEmpty() || destination.trim().isEmpty()) {
            request.setAttribute("errorMessage", "Please enter both source and destination!");
            request.getRequestDispatcher("search-rides.jsp").forward(request, response);
            return;
        }

        List<Ride> rides;
        if (rideDateStr != null && !rideDateStr.trim().isEmpty()) {
            try {
                LocalDate date = LocalDate.parse(rideDateStr.trim());
                rides = rideDAO.searchRidesByDate(source.trim(), destination.trim(), date);
                request.setAttribute("rideDate", rideDateStr.trim());
            } catch (Exception e) {
                rides = rideDAO.searchRides(source.trim(), destination.trim());
            }
        } else {
            rides = rideDAO.searchRides(source.trim(), destination.trim());
        }

        request.setAttribute("rides", rides);
        request.setAttribute("source", source.trim());
        request.setAttribute("destination", destination.trim());
        request.getRequestDispatcher("search-rides.jsp").forward(request, response);
    }

    private void handleUpdateRide(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        String rideIdStr = request.getParameter("rideId");
        String source = request.getParameter("source");
        String destination = request.getParameter("destination");
        String fareStr = request.getParameter("fare");
        String rideDateStr = request.getParameter("rideDate");
        String rideTimeStr = request.getParameter("rideTime");

        try {
            int rideId = Integer.parseInt(rideIdStr);
            double fare = Double.parseDouble(fareStr);
            LocalDate rideDate = LocalDate.parse(rideDateStr);
            LocalTime rideTime = LocalTime.parse(rideTimeStr);

            Ride ride = rideDAO.getRideById(rideId);
            if (ride == null) {
                response.sendRedirect("ride?action=myRides");
                return;
            }

User currentUser = (User) session.getAttribute("user");
            if (ride.getCreatedBy().getUserId() != currentUser.getUserId()) {
                request.setAttribute("errorMessage", "You can only edit your own rides!");
                response.sendRedirect("ride?action=myRides");
                return;
            }

            ride.setSource(source);
            ride.setDestination(destination);
            ride.setFare(fare);
            ride.setRideDate(rideDate);
            ride.setRideTime(rideTime);

            boolean success = rideDAO.updateRide(ride);

            if (success) {
                response.sendRedirect("ride?action=myRides");
            } else {
                request.setAttribute("errorMessage", "Failed to update ride.");
                request.setAttribute("ride", ride);
                request.getRequestDispatcher("edit-ride.jsp").forward(request, response);
            }

        } catch (NumberFormatException e) {
            request.setAttribute("errorMessage", "Invalid input!");
            response.sendRedirect("ride?action=myRides");
        } catch (Exception e) {
            request.setAttribute("errorMessage", "Invalid date or time format!");
            response.sendRedirect("ride?action=myRides");
        }
    }

    private void handleCancelRide(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        String rideIdStr = request.getParameter("rideId");

        try {
            int rideId = Integer.parseInt(rideIdStr);

Ride ride = rideDAO.getRideById(rideId);
            if (ride == null) {
                response.sendRedirect("ride?action=myRides");
                return;
            }
            User currentUser = (User) session.getAttribute("user");
            if (ride.getCreatedBy().getUserId() != currentUser.getUserId()) {
                response.sendRedirect("ride?action=myRides");
                return;
            }

bookingDAO.cancelAllBookingsForRide(rideId);
            rideDAO.cancelRide(rideId);

            response.sendRedirect("ride?action=myRides");

        } catch (NumberFormatException e) {
            response.sendRedirect("ride?action=myRides");
        }
    }
}