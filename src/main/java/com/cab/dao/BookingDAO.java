package com.cab.dao;

import com.cab.model.Booking;
import com.cab.model.Ride;
import com.cab.model.User;
import com.cab.util.DBConnection;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;
import java.util.UUID;

public class BookingDAO {

    private RideDAO rideDAO = new RideDAO();


    public Booking createBooking(int rideId, int passengerId, int seatsBooked) {
        Connection conn = null;

        try {
            conn = DBConnection.getConnection();
            conn.setAutoCommit(false); // Start transaction

            // Step 1: Check if enough seats available
            String checkSql = "SELECT available_seats FROM rides WHERE ride_id = ? FOR UPDATE";
            PreparedStatement checkStmt = conn.prepareStatement(checkSql);
            checkStmt.setInt(1, rideId);
            ResultSet rs = checkStmt.executeQuery();

            if (!rs.next()) {
                System.err.println("Ride not found");
                conn.rollback();
                return null;
            }

            int availableSeats = rs.getInt("available_seats");
            if (availableSeats < seatsBooked) {
                System.err.println("Not enough seats available");
                conn.rollback();
                return null;
            }

            // Step 2: Create booking
            String bookingId = UUID.randomUUID().toString().substring(0, 8).toUpperCase();
            String insertSql = "INSERT INTO bookings (booking_id, ride_id, passenger_id, seats_booked, status) " +
                    "VALUES (?, ?, ?, ?, 'CONFIRMED')";
            PreparedStatement insertStmt = conn.prepareStatement(insertSql);
            insertStmt.setString(1, bookingId);
            insertStmt.setInt(2, rideId);
            insertStmt.setInt(3, passengerId);
            insertStmt.setInt(4, seatsBooked);
            insertStmt.executeUpdate();

            // Step 3: Update available seats
            String updateSql = "UPDATE rides SET available_seats = available_seats - ? WHERE ride_id = ?";
            PreparedStatement updateStmt = conn.prepareStatement(updateSql);
            updateStmt.setInt(1, seatsBooked);
            updateStmt.setInt(2, rideId);
            updateStmt.executeUpdate();

            conn.commit(); // Commit transaction
            System.out.println("Booking created: " + bookingId);

            // Return the booking object
            return getBookingById(bookingId);

        } catch (SQLException e) {
            System.err.println("Error creating booking: " + e.getMessage());
            e.printStackTrace();
            if (conn != null) {
                try {
                    conn.rollback();
                } catch (SQLException ex) {
                    ex.printStackTrace();
                }
            }
        } finally {
            if (conn != null) {
                try {
                    conn.setAutoCommit(true);
                    DBConnection.closeConnection(conn);
                } catch (SQLException e) {
                    e.printStackTrace();
                }
            }
        }
        return null;
    }

    /**
     * Get booking by ID
     * @param bookingId Booking ID
     * @return Booking object or null
     */
    public Booking getBookingById(String bookingId) {
        String sql = "SELECT b.*, " +
                "r.source, r.destination, r.fare, " +
                "u.name as passenger_name, u.email as passenger_email " +
                "FROM bookings b " +
                "JOIN rides r ON b.ride_id = r.ride_id " +
                "JOIN users u ON b.passenger_id = u.user_id " +
                "WHERE b.booking_id = ?";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {

            pstmt.setString(1, bookingId);
            ResultSet rs = pstmt.executeQuery();

            if (rs.next()) {
                return mapResultSetToBooking(rs);
            }

        } catch (SQLException e) {
            System.err.println("Error fetching booking: " + e.getMessage());
            e.printStackTrace();
        }
        return null;
    }


    public List<Booking> getBookingsByPassenger(int passengerId) {
        List<Booking> bookings = new ArrayList<>();
        String sql = "SELECT b.*, " +
                "r.source, r.destination, r.fare, r.total_seats, r.available_seats, " +
                "u.name as passenger_name, u.email as passenger_email, " +
                "d.name as driver_name " +
                "FROM bookings b " +
                "JOIN rides r ON b.ride_id = r.ride_id " +
                "JOIN users u ON b.passenger_id = u.user_id " +
                "JOIN users d ON r.driver_id = d.user_id " +
                "WHERE b.passenger_id = ? " +
                "ORDER BY b.created_at DESC";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {

            pstmt.setInt(1, passengerId);
            ResultSet rs = pstmt.executeQuery();

            while (rs.next()) {
                Booking booking = mapResultSetToBooking(rs);
                bookings.add(booking);
            }

        } catch (SQLException e) {
            System.err.println("Error fetching bookings: " + e.getMessage());
            e.printStackTrace();
        }
        return bookings;
    }


    public List<Booking> getBookingsByRide(int rideId) {
        List<Booking> bookings = new ArrayList<>();
        String sql = "SELECT b.*, " +
                "r.source, r.destination, r.fare, " +
                "u.name as passenger_name, u.email as passenger_email " +
                "FROM bookings b " +
                "JOIN rides r ON b.ride_id = r.ride_id " +
                "JOIN users u ON b.passenger_id = u.user_id " +
                "WHERE b.ride_id = ? " +
                "ORDER BY b.created_at DESC";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {

            pstmt.setInt(1, rideId);
            ResultSet rs = pstmt.executeQuery();

            while (rs.next()) {
                Booking booking = mapResultSetToBooking(rs);
                bookings.add(booking);
            }

        } catch (SQLException e) {
            System.err.println("Error fetching bookings: " + e.getMessage());
            e.printStackTrace();
        }
        return bookings;
    }


    public boolean cancelBooking(String bookingId) {
        Connection conn = null;

        try {
            conn = DBConnection.getConnection();
            conn.setAutoCommit(false);

            // Step 1: Get booking details
            String selectSql = "SELECT ride_id, seats_booked FROM bookings WHERE booking_id = ?";
            PreparedStatement selectStmt = conn.prepareStatement(selectSql);
            selectStmt.setString(1, bookingId);
            ResultSet rs = selectStmt.executeQuery();

            if (!rs.next()) {
                System.err.println("Booking not found");
                conn.rollback();
                return false;
            }

            int rideId = rs.getInt("ride_id");
            int seatsBooked = rs.getInt("seats_booked");

            // Step 2: Update booking status
            String updateBookingSql = "UPDATE bookings SET status = 'CANCELLED' WHERE booking_id = ?";
            PreparedStatement updateBookingStmt = conn.prepareStatement(updateBookingSql);
            updateBookingStmt.setString(1, bookingId);
            updateBookingStmt.executeUpdate();

            // Step 3: Return seats to ride
            String updateRideSql = "UPDATE rides SET available_seats = available_seats + ? WHERE ride_id = ?";
            PreparedStatement updateRideStmt = conn.prepareStatement(updateRideSql);
            updateRideStmt.setInt(1, seatsBooked);
            updateRideStmt.setInt(2, rideId);
            updateRideStmt.executeUpdate();

            conn.commit();
            System.out.println("Booking cancelled: " + bookingId);
            return true;

        } catch (SQLException e) {
            System.err.println("Error cancelling booking: " + e.getMessage());
            e.printStackTrace();
            if (conn != null) {
                try {
                    conn.rollback();
                } catch (SQLException ex) {
                    ex.printStackTrace();
                }
            }
        } finally {
            if (conn != null) {
                try {
                    conn.setAutoCommit(true);
                    DBConnection.closeConnection(conn);
                } catch (SQLException e) {
                    e.printStackTrace();
                }
            }
        }
        return false;
    }


    public int cancelAllBookingsForRide(int rideId) {
        String sql = "UPDATE bookings SET status = 'CANCELLED_BY_DRIVER' " +
                "WHERE ride_id = ? AND status = 'CONFIRMED'";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {

            pstmt.setInt(1, rideId);
            int rowsAffected = pstmt.executeUpdate();

            System.out.println("Cancelled " + rowsAffected + " bookings for ride " + rideId);
            return rowsAffected;

        } catch (SQLException e) {
            System.err.println("Error cancelling bookings: " + e.getMessage());
            e.printStackTrace();
        }
        return 0;
    }


    private Booking mapResultSetToBooking(ResultSet rs) throws SQLException {
        // Create ride object
        Ride ride = new Ride();
        ride.setRideId(rs.getInt("ride_id"));
        ride.setSource(rs.getString("source"));
        ride.setDestination(rs.getString("destination"));
        ride.setFare(rs.getDouble("fare"));

        // Create passenger object
        User passenger = new User();
        passenger.setUserId(rs.getInt("passenger_id"));
        passenger.setName(rs.getString("passenger_name"));
        passenger.setEmail(rs.getString("passenger_email"));

        // Create booking
        Booking booking = new Booking(ride, passenger, rs.getInt("seats_booked"));
        booking.setBookingId(rs.getString("booking_id"));
        booking.setStatus(rs.getString("status"));

        return booking;
    }
}