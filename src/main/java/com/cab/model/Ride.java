import main.java.com.cab.model.User;

import java.util.ArrayList;
import java.util.List;

public class Ride {

    String source;
    String destination;
    int total_seats;
    int available_seats;
    double fare;

    // MAPPINGS
    private User createdBy;           // The Driver (One-to-One)
    private List<User> passengers;    // The Passengers (One-to-Many)




    public Ride(String source, String destination, int total_seats, int available_seats, double fare) {
        this.source = source;
        this.destination = destination;
        this.total_seats = total_seats;
        this.available_seats = available_seats;
        this.fare = fare;
        this.passengers = new ArrayList<>(); // Initialize the list!
    }

    public void setCreatedBy(User createdBy) {
        this.createdBy = createdBy;
    }

    public void setPassengers(List<User> passengers) {
        this.passengers = passengers;
    }

    public List<User> getPassengers() {
        return passengers;
    }

    // Helper method to add a passenger easily
    public void addPassenger(User user) {
        passengers.add(user);
    }

    // Helper to print details
    public void printRideDetails() {
        System.out.println("Ride from " + source + " to " + destination);
        System.out.println("Driver: " + (createdBy != null ? createdBy.getName() : "Unknown"));
        System.out.println("Passengers:");
        if (passengers.isEmpty()) {
            System.out.println(" - No passengers yet.");
        } else {
            for (User p : passengers) {
                System.out.println(" - " + p.getName());
            }
        }
    }

    public void setSource(String source) { this.source = source; }
    public String getSource() { return source; }

    public void setDestination(String destination) { this.destination = destination; }
    public String getDestination() { return destination; }

    public void setFare(double fare) { this.fare = fare; }

    public int getAvailableSeats() { return available_seats; }
    public void setAvailableSeats(int seats) { this.available_seats = seats; }

    public User getCreatedBy() { return createdBy; }

    @Override
    public String toString() {
        return "Ride{" +
                "source='" + source + '\'' +
                ", destination='" + destination + '\'' +
                ", fare=" + fare +
                ", seats=" + available_seats + "/" + total_seats +
                '}';
    }
}