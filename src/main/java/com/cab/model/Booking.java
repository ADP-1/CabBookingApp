package com.cab.model;

import java.util.UUID;

public class Booking {
    private String bookingId;
    private Ride ride;
    private User passenger;
    private int seatsBooked;
    private String status; 

public Booking(Ride ride, User passenger, int seatsBooked) {
        this.bookingId = UUID.randomUUID().toString().substring(0, 8).toUpperCase();
        this.ride = ride;
        this.passenger = passenger;
        this.seatsBooked = seatsBooked;
        this.status = "CONFIRMED";
    }

public String getBookingId() {
        return bookingId;
    }

    public void setBookingId(String bookingId) {
        this.bookingId = bookingId;
    }

    public Ride getRide() {
        return ride;
    }

    public void setRide(Ride ride) {
        this.ride = ride;
    }

    public User getPassenger() {
        return passenger;
    }

    public void setPassenger(User passenger) {
        this.passenger = passenger;
    }

    public int getSeatsBooked() {
        return seatsBooked;
    }

    public void setSeatsBooked(int seatsBooked) {
        this.seatsBooked = seatsBooked;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }

    @Override
    public String toString() {
        return "Booking[ID=" + bookingId + " | Status=" + status +
                " | Ride=" + ride.getSource() + "->" + ride.getDestination() +
                " | Seats=" + seatsBooked + "]";
    }
}