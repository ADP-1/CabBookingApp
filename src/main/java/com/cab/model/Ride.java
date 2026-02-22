package com.cab.model;

import java.time.LocalDate;
import java.time.LocalTime;
import java.time.format.DateTimeFormatter;
import java.util.ArrayList;
import java.util.List;

public class Ride {

private int rideId;
    private String source;
    private String destination;
    private int totalSeats;
    private int availableSeats;
    private double fare;
    private String status;

private LocalDate rideDate;
    private LocalTime rideTime;

private User createdBy;
    private List<User> passengers;

public Ride() {
        this.passengers = new ArrayList<>();
        this.status = "ACTIVE";
    }

    public Ride(String source, String destination, int totalSeats, int availableSeats,
            double fare, LocalDate rideDate, LocalTime rideTime) {
        this.source = source;
        this.destination = destination;
        this.totalSeats = totalSeats;
        this.availableSeats = availableSeats;
        this.fare = fare;
        this.rideDate = rideDate;
        this.rideTime = rideTime;
        this.passengers = new ArrayList<>();
        this.status = "ACTIVE";
    }

public int getRideId() {
        return rideId;
    }

    public void setRideId(int rideId) {
        this.rideId = rideId;
    }

    public String getSource() {
        return source;
    }

    public void setSource(String source) {
        this.source = source;
    }

    public String getDestination() {
        return destination;
    }

    public void setDestination(String destination) {
        this.destination = destination;
    }

    public int getTotalSeats() {
        return totalSeats;
    }

    public void setTotalSeats(int totalSeats) {
        this.totalSeats = totalSeats;
    }

    public int getAvailableSeats() {
        return availableSeats;
    }

    public void setAvailableSeats(int availableSeats) {
        this.availableSeats = availableSeats;
    }

    public double getFare() {
        return fare;
    }

    public void setFare(double fare) {
        this.fare = fare;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }

    public LocalDate getRideDate() {
        return rideDate;
    }

    public void setRideDate(LocalDate rideDate) {
        this.rideDate = rideDate;
    }

    public LocalTime getRideTime() {
        return rideTime;
    }

    public void setRideTime(LocalTime rideTime) {
        this.rideTime = rideTime;
    }

    public User getCreatedBy() {
        return createdBy;
    }

    public void setCreatedBy(User createdBy) {
        this.createdBy = createdBy;
    }

    public List<User> getPassengers() {
        return passengers;
    }

    public void setPassengers(List<User> passengers) {
        this.passengers = passengers;
    }

    public void addPassenger(User user) {
        passengers.add(user);
    }

public String getFormattedDate() {
        if (rideDate == null)
            return "Not Set";
        return rideDate.format(DateTimeFormatter.ofPattern("dd MMM yyyy"));
    }

public String getFormattedTime() {
        if (rideTime == null)
            return "Not Set";
        return rideTime.format(DateTimeFormatter.ofPattern("hh:mm a"));
    }

public String getDateForInput() {
        if (rideDate == null)
            return "";
        return rideDate.toString();
    }

public String getTimeForInput() {
        if (rideTime == null)
            return "";
        return rideTime.format(DateTimeFormatter.ofPattern("HH:mm"));
    }

public boolean isPastRide() {
        if (rideDate == null || rideTime == null)
            return false;
        LocalDate today = LocalDate.now();
        LocalTime now = LocalTime.now();
        if (rideDate.isBefore(today))
            return true;
        if (rideDate.isEqual(today) && rideTime.isBefore(now))
            return true;
        return false;
    }

public boolean isToday() {
        if (rideDate == null)
            return false;
        return rideDate.isEqual(LocalDate.now());
    }

    @Override
    public String toString() {
        return "Ride{" +
                "rideId=" + rideId +
                ", source='" + source + '\'' +
                ", destination='" + destination + '\'' +
                ", date=" + getFormattedDate() +
                ", time=" + getFormattedTime() +
                ", fare=" + fare +
                ", seats=" + availableSeats + "/" + totalSeats +
                ", status='" + status + '\'' +
                ", driver=" + (createdBy != null ? createdBy.getName() : "N/A") +
                '}';
    }
}