package com.cab.servlet;

import com.cab.dao.BookingDAO;
import com.cab.dao.RideDAO;
import com.cab.model.Booking;
import com.cab.model.Ride;
import com.cab.model.User;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.util.List;


@WebServlet("/booking")
public class BookingServlet extends HttpServlet {
    
    private BookingDAO bookingDAO;
    private RideDAO rideDAO;
    
    @Override
    public void init() {
        bookingDAO = new BookingDAO();
        rideDAO = new RideDAO();
    }
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        String action = request.getParameter("action");
        
        if (action == null) {
            action = "myBookings";
        }
        
        switch (action) {
            case "myBookings":
                viewMyBookings(request, response);
                break;
            case "book":
                showBookingPage(request, response);
                break;
            default:
                viewMyBookings(request, response);
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
                handleCreateBooking(request, response);
                break;
            case "cancel":
                handleCancelBooking(request, response);
                break;
            default:
                response.sendRedirect("dashboard.jsp");
        }
    }
    
    /**
     * View user's bookings
     */
    private void viewMyBookings(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            response.sendRedirect("login.jsp");
            return;
        }
        
        User currentUser = (User) session.getAttribute("user");
        List<Booking> bookings = bookingDAO.getBookingsByPassenger(currentUser.getUserId());
        
        request.setAttribute("bookings", bookings);
        request.getRequestDispatcher("my-bookings.jsp").forward(request, response);
    }
    
    /**
     * Show booking page for a specific ride
     */
    private void showBookingPage(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            response.sendRedirect("login.jsp");
            return;
        }
        
        String rideIdStr = request.getParameter("rideId");
        if (rideIdStr == null) {
            response.sendRedirect("ride?action=search");
            return;
        }
        
        try {
            int rideId = Integer.parseInt(rideIdStr);
            Ride ride = rideDAO.getRideById(rideId);
            
            if (ride == null) {
                request.setAttribute("errorMessage", "Ride not found!");
                response.sendRedirect("ride?action=search");
                return;
            }
            
            if (ride.getAvailableSeats() <= 0) {
                request.setAttribute("errorMessage", "No seats available!");
                response.sendRedirect("ride?action=search");
                return;
            }
            
            request.setAttribute("ride", ride);
            request.getRequestDispatcher("book-ride.jsp").forward(request, response);
            
        } catch (NumberFormatException e) {
            response.sendRedirect("ride?action=search");
        }
    }
    
    /**
     * Handle create booking
     */
    private void handleCreateBooking(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            response.sendRedirect("login.jsp");
            return;
        }
        
        User currentUser = (User) session.getAttribute("user");
        
        String rideIdStr = request.getParameter("rideId");
        String seatsStr = request.getParameter("seats");
        
        if (rideIdStr == null || seatsStr == null) {
            request.setAttribute("errorMessage", "Invalid booking request!");
            response.sendRedirect("ride?action=search");
            return;
        }
        
        try {
            int rideId = Integer.parseInt(rideIdStr);
            int seats = Integer.parseInt(seatsStr);
            
            if (seats <= 0) {
                request.setAttribute("errorMessage", "Please select at least 1 seat!");
                Ride ride = rideDAO.getRideById(rideId);
                request.setAttribute("ride", ride);
                request.getRequestDispatcher("book-ride.jsp").forward(request, response);
                return;
            }
            
            // Get ride details
            Ride ride = rideDAO.getRideById(rideId);
            if (ride == null) {
                request.setAttribute("errorMessage", "Ride not found!");
                response.sendRedirect("ride?action=search");
                return;
            }
            
            // Check if driver is trying to book their own ride
            if (ride.getCreatedBy().getUserId() == currentUser.getUserId()) {
                request.setAttribute("errorMessage", "You cannot book your own ride!");
                request.setAttribute("ride", ride);
                request.getRequestDispatcher("book-ride.jsp").forward(request, response);
                return;
            }
            
            // Check seat availability
            if (ride.getAvailableSeats() < seats) {
                request.setAttribute("errorMessage", "Not enough seats available! Only " + 
                        ride.getAvailableSeats() + " seats left.");
                request.setAttribute("ride", ride);
                request.getRequestDispatcher("book-ride.jsp").forward(request, response);
                return;
            }
            
            // Create booking
            Booking booking = bookingDAO.createBooking(rideId, currentUser.getUserId(), seats);
            
            if (booking != null) {
                request.setAttribute("successMessage", "Booking confirmed! Booking ID: " + booking.getBookingId());
                request.setAttribute("booking", booking);
                request.getRequestDispatcher("booking-success.jsp").forward(request, response);
            } else {
                request.setAttribute("errorMessage", "Booking failed. Please try again.");
                request.setAttribute("ride", ride);
                request.getRequestDispatcher("book-ride.jsp").forward(request, response);
            }
            
        } catch (NumberFormatException e) {
            request.setAttribute("errorMessage", "Invalid input!");
            response.sendRedirect("ride?action=search");
        }
    }
    
    /**
     * Handle cancel booking
     */
    private void handleCancelBooking(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            response.sendRedirect("login.jsp");
            return;
        }
        
        String bookingId = request.getParameter("bookingId");
        
        if (bookingId == null) {
            response.sendRedirect("booking?action=myBookings");
            return;
        }
        
        // Verify booking belongs to current user
        Booking booking = bookingDAO.getBookingById(bookingId);
        if (booking == null) {
            request.setAttribute("errorMessage", "Booking not found!");
            response.sendRedirect("booking?action=myBookings");
            return;
        }
        
        User currentUser = (User) session.getAttribute("user");
        if (booking.getPassenger().getUserId() != currentUser.getUserId()) {
            request.setAttribute("errorMessage", "You can only cancel your own bookings!");
            response.sendRedirect("booking?action=myBookings");
            return;
        }
        
        // Check if already cancelled
        if (booking.getStatus().contains("CANCELLED")) {
            request.setAttribute("errorMessage", "Booking is already cancelled!");
            response.sendRedirect("booking?action=myBookings");
            return;
        }
        
        // Cancel booking
        boolean success = bookingDAO.cancelBooking(bookingId);
        
        if (success) {
            request.setAttribute("successMessage", "Booking cancelled successfully!");
        } else {
            request.setAttribute("errorMessage", "Failed to cancel booking.");
        }
        
        response.sendRedirect("booking?action=myBookings");
    }
}
