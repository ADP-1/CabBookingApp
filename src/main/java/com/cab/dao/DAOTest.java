package com.cab.dao;

import com.cab.model.Booking;
import com.cab.model.Ride;
import com.cab.model.User;

import java.util.List;

public class DAOTest {

    public static void main(String[] args) {
        System.out.println("=== Starting DAO Tests ===\n");

        UserDAO userDAO = new UserDAO();
        RideDAO rideDAO = new RideDAO();
        BookingDAO bookingDAO = new BookingDAO();

        // Test 1: Register User
        System.out.println("--- Test 1: User Registration ---");
        User testUser = new User();
        testUser.setName("Test User");
        testUser.setEmail("test" + System.currentTimeMillis() + "@example.com"); // Unique email
        testUser.setMobile(1234567890L);
        testUser.setPwd("testpass123");

        boolean registered = userDAO.registerUser(testUser);
        System.out.println("User registered: " + registered);
        System.out.println();

        // Test 2: Login User
        System.out.println("--- Test 2: User Login ---");
        User loggedInUser = userDAO.loginUser(testUser.getEmail(), "testpass123");
        if (loggedInUser != null) {
            System.out.println("Login successful!");
            System.out.println("User ID: " + loggedInUser.getUserId());
            System.out.println("Name: " + loggedInUser.getName());
        } else {
            System.out.println("Login failed!");
        }
        System.out.println();

        // Test 3: Create Ride
        System.out.println("--- Test 3: Create Ride ---");
        if (loggedInUser != null) {
            Ride testRide = new Ride("Mumbai", "Pune", 4, 4, 500.00);
            int rideId = rideDAO.createRide(testRide, loggedInUser.getUserId());
            testRide.setRideId(rideId);
            System.out.println("Ride created with ID: " + rideId);
        }
        System.out.println();

        // Test 4: Search Rides
        System.out.println("--- Test 4: Search Rides ---");
        List<Ride> rides = rideDAO.searchRides("Mumbai", "Pune");
        System.out.println("Found " + rides.size() + " ride(s):");
        for (Ride r : rides) {
            System.out.println("  - " + r);
        }
        System.out.println();

        // Test 5: Get All Rides
        System.out.println("--- Test 5: Get All Rides ---");
        List<Ride> allRides = rideDAO.getAllRides();
        System.out.println("Total active rides: " + allRides.size());
        for (Ride r : allRides) {
            System.out.println("  - " + r);
        }
        System.out.println();

        // Test 6: Create Booking
        System.out.println("--- Test 6: Create Booking ---");
        if (loggedInUser != null && !allRides.isEmpty()) {
            Ride rideToBook = allRides.get(0);
            Booking booking = bookingDAO.createBooking(
                    rideToBook.getRideId(),
                    loggedInUser.getUserId(),
                    1
            );
            if (booking != null) {
                System.out.println("Booking created: " + booking);
            } else {
                System.out.println("Booking failed!");
            }
        }
        System.out.println();

        // Test 7: Get User's Bookings
        System.out.println("--- Test 7: Get User Bookings ---");
        if (loggedInUser != null) {
            List<Booking> bookings = bookingDAO.getBookingsByPassenger(loggedInUser.getUserId());
            System.out.println("User has " + bookings.size() + " booking(s):");
            for (Booking b : bookings) {
                System.out.println("  - " + b);
            }
        }
        System.out.println();

        // Test 8: Update User Profile
        System.out.println("--- Test 8: Update User Profile ---");
        if (loggedInUser != null) {
            loggedInUser.setName("Updated Test User");
            loggedInUser.setMobile(9999999999L);
            boolean updated = userDAO.updateUser(loggedInUser);
            System.out.println("User updated: " + updated);
        }
        System.out.println();

        System.out.println("=== All Tests Completed ===");
        System.out.println("\nIf all tests passed, your DAO layer is working correctly!");
        System.out.println("Next step: Create Servlets and JSP pages");
    }
}