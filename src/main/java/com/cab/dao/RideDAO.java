package com.cab.dao;

import com.cab.model.Ride;
import com.cab.model.User;
import com.cab.util.DBConnection;

import java.sql.*;
import java.time.LocalDate;
import java.time.LocalTime;
import java.util.ArrayList;
import java.util.List;

/**
 * Data Access Object for Ride operations (with date/time support)
 */
public class RideDAO {

    /**
     * Create a new ride with date and time
     */
    public int createRide(Ride ride, int driverId) {
        String sql = "INSERT INTO rides (source, destination, total_seats, available_seats, " +
                "fare, driver_id, ride_date, ride_time) " +
                "VALUES (?, ?, ?, ?, ?, ?, ?, ?) RETURNING ride_id";

        try (Connection conn = DBConnection.getConnection();
                PreparedStatement pstmt = conn.prepareStatement(sql)) {

            pstmt.setString(1, ride.getSource());
            pstmt.setString(2, ride.getDestination());
            pstmt.setInt(3, ride.getTotalSeats());
            pstmt.setInt(4, ride.getAvailableSeats());
            pstmt.setDouble(5, ride.getFare());
            pstmt.setInt(6, driverId);
            pstmt.setDate(7, Date.valueOf(ride.getRideDate()));
            pstmt.setTime(8, Time.valueOf(ride.getRideTime()));

            ResultSet rs = pstmt.executeQuery();
            if (rs.next()) {
                int rideId = rs.getInt("ride_id");
                System.out.println("Ride created with ID: " + rideId + " for " +
                        ride.getFormattedDate() + " at " + ride.getFormattedTime());
                return rideId;
            }

        } catch (SQLException e) {
            System.err.println("Error creating ride: " + e.getMessage());
            e.printStackTrace();
        }
        return -1;
    }

    /**
     * Get all active upcoming rides (today and future), ordered by date/time
     */
    public List<Ride> getAllRides() {
        List<Ride> rides = new ArrayList<>();
        String sql = "SELECT r.*, u.name as driver_name, u.email as driver_email " +
                "FROM rides r " +
                "JOIN users u ON r.driver_id = u.user_id " +
                "WHERE r.status = 'ACTIVE' " +
                "AND (r.ride_date > CURRENT_DATE " +
                "     OR (r.ride_date = CURRENT_DATE AND r.ride_time >= CURRENT_TIME)) " +
                "ORDER BY r.ride_date, r.ride_time ASC";

        try (Connection conn = DBConnection.getConnection();
                Statement stmt = conn.createStatement();
                ResultSet rs = stmt.executeQuery(sql)) {

            while (rs.next()) {
                rides.add(mapResultSetToRide(rs));
            }

        } catch (SQLException e) {
            System.err.println("Error fetching rides: " + e.getMessage());
            e.printStackTrace();
        }
        return rides;
    }

    /**
     * Search rides by source and destination (upcoming only)
     */
    public List<Ride> searchRides(String source, String destination) {
        List<Ride> rides = new ArrayList<>();
        String sql = "SELECT r.*, u.name as driver_name, u.email as driver_email " +
                "FROM rides r " +
                "JOIN users u ON r.driver_id = u.user_id " +
                "WHERE LOWER(r.source) = LOWER(?) " +
                "AND LOWER(r.destination) = LOWER(?) " +
                "AND r.status = 'ACTIVE' " +
                "AND r.available_seats > 0 " +
                "AND (r.ride_date > CURRENT_DATE " +
                "     OR (r.ride_date = CURRENT_DATE AND r.ride_time >= CURRENT_TIME)) " +
                "ORDER BY r.ride_date, r.ride_time, r.fare ASC";

        try (Connection conn = DBConnection.getConnection();
                PreparedStatement pstmt = conn.prepareStatement(sql)) {

            pstmt.setString(1, source);
            pstmt.setString(2, destination);

            ResultSet rs = pstmt.executeQuery();
            while (rs.next()) {
                rides.add(mapResultSetToRide(rs));
            }

        } catch (SQLException e) {
            System.err.println("Error searching rides: " + e.getMessage());
            e.printStackTrace();
        }
        return rides;
    }

    /**
     * Search rides by source, destination, and specific date
     */
    public List<Ride> searchRidesByDate(String source, String destination, LocalDate date) {
        List<Ride> rides = new ArrayList<>();
        String sql = "SELECT r.*, u.name as driver_name, u.email as driver_email " +
                "FROM rides r " +
                "JOIN users u ON r.driver_id = u.user_id " +
                "WHERE LOWER(r.source) = LOWER(?) " +
                "AND LOWER(r.destination) = LOWER(?) " +
                "AND r.ride_date = ? " +
                "AND r.status = 'ACTIVE' " +
                "AND r.available_seats > 0 " +
                "ORDER BY r.ride_time, r.fare ASC";

        try (Connection conn = DBConnection.getConnection();
                PreparedStatement pstmt = conn.prepareStatement(sql)) {

            pstmt.setString(1, source);
            pstmt.setString(2, destination);
            pstmt.setDate(3, Date.valueOf(date));

            ResultSet rs = pstmt.executeQuery();
            while (rs.next()) {
                rides.add(mapResultSetToRide(rs));
            }

        } catch (SQLException e) {
            System.err.println("Error searching rides by date: " + e.getMessage());
            e.printStackTrace();
        }
        return rides;
    }

    /**
     * Get ride by ID
     */
    public Ride getRideById(int rideId) {
        String sql = "SELECT r.*, u.name as driver_name, u.email as driver_email " +
                "FROM rides r " +
                "JOIN users u ON r.driver_id = u.user_id " +
                "WHERE r.ride_id = ?";

        try (Connection conn = DBConnection.getConnection();
                PreparedStatement pstmt = conn.prepareStatement(sql)) {

            pstmt.setInt(1, rideId);
            ResultSet rs = pstmt.executeQuery();

            if (rs.next()) {
                return mapResultSetToRide(rs);
            }

        } catch (SQLException e) {
            System.err.println("Error fetching ride: " + e.getMessage());
            e.printStackTrace();
        }
        return null;
    }

    /**
     * Get all rides created by a specific driver, newest first
     */
    public List<Ride> getRidesByDriver(int driverId) {
        List<Ride> rides = new ArrayList<>();
        String sql = "SELECT r.*, u.name as driver_name, u.email as driver_email " +
                "FROM rides r " +
                "JOIN users u ON r.driver_id = u.user_id " +
                "WHERE r.driver_id = ? " +
                "ORDER BY r.ride_date DESC, r.ride_time DESC, r.created_at DESC";

        try (Connection conn = DBConnection.getConnection();
                PreparedStatement pstmt = conn.prepareStatement(sql)) {

            pstmt.setInt(1, driverId);
            ResultSet rs = pstmt.executeQuery();

            while (rs.next()) {
                rides.add(mapResultSetToRide(rs));
            }

        } catch (SQLException e) {
            System.err.println("Error fetching driver rides: " + e.getMessage());
            e.printStackTrace();
        }
        return rides;
    }

    /**
     * Update ride details including date and time
     */
    public boolean updateRide(Ride ride) {
        String sql = "UPDATE rides SET source = ?, destination = ?, fare = ?, " +
                "ride_date = ?, ride_time = ? WHERE ride_id = ?";

        try (Connection conn = DBConnection.getConnection();
                PreparedStatement pstmt = conn.prepareStatement(sql)) {

            pstmt.setString(1, ride.getSource());
            pstmt.setString(2, ride.getDestination());
            pstmt.setDouble(3, ride.getFare());
            pstmt.setDate(4, Date.valueOf(ride.getRideDate()));
            pstmt.setTime(5, Time.valueOf(ride.getRideTime()));
            pstmt.setInt(6, ride.getRideId());

            int rowsAffected = pstmt.executeUpdate();
            if (rowsAffected > 0) {
                System.out.println("Ride updated: ID " + ride.getRideId());
                return true;
            }

        } catch (SQLException e) {
            System.err.println("Error updating ride: " + e.getMessage());
            e.printStackTrace();
        }
        return false;
    }

    /**
     * Update available seats (seatsChange is negative when booking, positive when
     * cancelling)
     */
    public boolean updateAvailableSeats(int rideId, int seatsChange) {
        String sql = "UPDATE rides SET available_seats = available_seats + ? " +
                "WHERE ride_id = ? AND available_seats + ? >= 0 " +
                "AND available_seats + ? <= total_seats";

        try (Connection conn = DBConnection.getConnection();
                PreparedStatement pstmt = conn.prepareStatement(sql)) {

            pstmt.setInt(1, seatsChange);
            pstmt.setInt(2, rideId);
            pstmt.setInt(3, seatsChange);
            pstmt.setInt(4, seatsChange);

            int rowsAffected = pstmt.executeUpdate();
            if (rowsAffected > 0) {
                System.out.println("Seats updated for ride: " + rideId);
                return true;
            }

        } catch (SQLException e) {
            System.err.println("Error updating seats: " + e.getMessage());
            e.printStackTrace();
        }
        return false;
    }

    /**
     * Cancel a ride (soft delete — status set to CANCELLED)
     */
    public boolean cancelRide(int rideId) {
        String sql = "UPDATE rides SET status = 'CANCELLED' WHERE ride_id = ?";

        try (Connection conn = DBConnection.getConnection();
                PreparedStatement pstmt = conn.prepareStatement(sql)) {

            pstmt.setInt(1, rideId);
            int rowsAffected = pstmt.executeUpdate();
            if (rowsAffected > 0) {
                System.out.println("Ride cancelled: ID " + rideId);
                return true;
            }

        } catch (SQLException e) {
            System.err.println("Error cancelling ride: " + e.getMessage());
            e.printStackTrace();
        }
        return false;
    }

    /**
     * Helper: map a ResultSet row to a Ride object
     */
    private Ride mapResultSetToRide(ResultSet rs) throws SQLException {
        Ride ride = new Ride();
        ride.setRideId(rs.getInt("ride_id"));
        ride.setSource(rs.getString("source"));
        ride.setDestination(rs.getString("destination"));
        ride.setTotalSeats(rs.getInt("total_seats"));
        ride.setAvailableSeats(rs.getInt("available_seats"));
        ride.setFare(rs.getDouble("fare"));
        ride.setStatus(rs.getString("status"));

        Date sqlDate = rs.getDate("ride_date");
        Time sqlTime = rs.getTime("ride_time");
        if (sqlDate != null)
            ride.setRideDate(sqlDate.toLocalDate());
        if (sqlTime != null)
            ride.setRideTime(sqlTime.toLocalTime());

        User driver = new User();
        driver.setUserId(rs.getInt("driver_id"));
        driver.setName(rs.getString("driver_name"));
        driver.setEmail(rs.getString("driver_email"));
        ride.setCreatedBy(driver);

        return ride;
    }
}