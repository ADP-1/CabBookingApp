import java.util.UUID;

public class Booking {
    private String bookingId;
    private Ride ride;
    private User passenger;
    private int seatsBooked;
    private String status; // e.g., "CONFIRMED", "CANCELLED"

    public Booking(Ride ride, User passenger, int seatsBooked) {
        this.bookingId = UUID.randomUUID().toString().substring(0, 8); // Simple unique ID
        this.ride = ride;
        this.passenger = passenger;
        this.seatsBooked = seatsBooked;
        this.status = "CONFIRMED";
    }

    public String getBookingId() { return bookingId; }
    public Ride getRide() { return ride; }
    public User getPassenger() { return passenger; }
    public int getSeatsBooked() { return seatsBooked; }
    public String getStatus() { return status; }
    public void setStatus(String status) { this.status = status; }

    @Override
    public String toString() {
        return "Booking[ID=" + bookingId + " | Status=" + status +
                " | Ride=" + ride.getSource() + "->" + ride.getDestination() +
                " | Seats=" + seatsBooked + "]";
    }
}