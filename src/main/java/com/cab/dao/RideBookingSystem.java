package main.java.com.cab.dao;

import main.java.com.cab.model.Booking;
import main.java.com.cab.model.Ride;
import main.java.com.cab.model.User;

import java.util.ArrayList;
import java.util.List;

public class RideBookingSystem {
    //1. lists having data
    private List<Ride> rideList = new ArrayList<>();
    private List<User> userList = new ArrayList<>();
   //used in main.java.com.cab.model.Booking.java
    public List<Booking> allBookings = new ArrayList<>();

    // 2. Register a new user
    public void registerUser(User user) {
        userList.add(user);
        System.out.println("main.java.com.cab.model.User " + user.getName() + " registered successfully!");
    }

    // 3. Login logic
    public User userLogin(String email, String pwd) {
        for (User user : userList) {
            if (user.getEmail().equals(email) && user.getPwd().equals(pwd)) {
                return user; // Login successful
            }
        }
        return null; // Login failed
    }

    // 4. Create a ride (Added main.java.com.cab.model.User creator parameter)
    public void createRide(User creator, String source, String destination, int total_seats, double fare) {
        // Initial available seats = total seats
        Ride ride = new Ride(source, destination, total_seats, total_seats, fare);
        ride.setCreatedBy(creator); // we need a setter in main.java.com.cab.model.Ride.java or allow direct access
        rideList.add(ride);
        System.out.println("main.java.com.cab.model.Ride created successfully!");
    }

    public List<Ride> getRideList() {
        return rideList;
    }

    // 5. Search for rides
    public List<Ride> searchRide(String source, String destination) {
        List<Ride> result = new ArrayList<>();
        for (Ride ride : rideList) {
            if (ride.source.equalsIgnoreCase(source) && ride.destination.equalsIgnoreCase(destination)) {
                result.add(ride);
            }
        }
        return result;
    }

    // 6. Book a ride
    public void bookRide(Ride ride, User passenger, int seats) {
        if (ride.getAvailableSeats() >= seats) {
            ride.setAvailableSeats(ride.getAvailableSeats() - seats);
            Booking newBooking = new Booking(ride, passenger, seats);
            allBookings.add(newBooking);
            // Optional: Add to ride's passenger list if you kept it
            System.out.println("main.java.com.cab.model.Booking Confirmed! ID: " + newBooking.getBookingId());
        } else {
            System.out.println("main.java.com.cab.model.Booking Failed: Not enough seats.");
        }
    }

    // --- FEATURE: UPDATE USER ---
    public void updateUser(User user, String newName, String newEmail, long newMobile) {
        user.setName(newName);
        user.setEmail(newEmail);
        user.setMobile(newMobile);
        System.out.println("Profile updated successfully!");
    }

    // --- FEATURE: DELETE ACCOUNT ---
    public void deleteAccount(User user) {
        // 1. Cancel all bookings made BY this user
        for (Booking b : allBookings) {
            if (b.getPassenger().equals(user)) {
                b.setStatus("CANCELLED");
                // Return seats to the ride
                b.getRide().setAvailableSeats(b.getRide().getAvailableSeats() + b.getSeatsBooked());
            }
        }

        // 2. Remove all rides created BY this user
        // We use removeIf (Java 8+) for safe removal while iterating
        rideList.removeIf(ride -> ride.getCreatedBy().equals(user));

        // 3. Remove the user
        userList.remove(user);
        System.out.println("Account and associated data deleted.");
    }

    // --- FEATURE: UPDATE RIDE ---
    public void updateRide(Ride ride, String newSource, String newDest, double newFare) {
        ride.setSource(newSource);
        ride.setDestination(newDest);
        ride.setFare(newFare);
        System.out.println("main.java.com.cab.model.Ride details updated.");
    }

    // --- FEATURE: CANCEL RIDE (By Driver) ---
    public void cancelRide(Ride ride) {
        // 1. Notify/Cancel all bookings for this ride
        for (Booking b : allBookings) {
            if (b.getRide().equals(ride)) {
                b.setStatus("CANCELLED_BY_DRIVER");
                System.out.println("main.java.com.cab.model.Booking " + b.getBookingId() + " was cancelled as the ride was removed.");
            }
        }
        // 2. Remove ride from system
        rideList.remove(ride);
        System.out.println("main.java.com.cab.model.Ride has been cancelled and removed.");
    }
}
