import main.java.com.cab.dao.RideBookingSystem;
import main.java.com.cab.model.Ride;
import main.java.com.cab.model.User;

import java.util.List;
import java.util.ArrayList;
import java.util.Scanner;

public class Main {
    public static void main(String[] args) {
        RideBookingSystem system = new RideBookingSystem();
        Scanner sc = new Scanner(System.in);
        User currentUser = null; // Tracks the currently logged-in user

        while (true) {
            System.out.println("\n--- Cab main.java.com.cab.model.Booking System ---");
            if (currentUser != null) {
                System.out.println("Logged in as: " + currentUser.getName());
            }
            System.out.println("1. Register main.java.com.cab.model.User");
            System.out.println("2. Login");
            System.out.println("3. Create main.java.com.cab.model.Ride (Driver)");
            System.out.println("4. View/Search Rides");
            System.out.println("5. Book main.java.com.cab.model.Ride (Passenger)");
            System.out.println("6. Update My Profile");
            System.out.println("7. Delete My Account");
            System.out.println("8. Manage My Rides (Driver: Update/Cancel)");
            System.out.println("9. Logout");
            System.out.print("Enter choice: ");

            int choice = sc.nextInt();
            sc.nextLine();// Consume newline left-over

            switch (choice) {
                case 1: // Register
                    System.out.print("Enter Name: ");
                    String name = sc.nextLine();
                    System.out.print("Enter Email: ");
                    String email = sc.nextLine();
                    System.out.print("Enter Mobile: ");
                    long mobile = sc.nextLong();
                    sc.nextLine(); // consume newline
                    System.out.print("Enter Password: ");
                    String pwd = sc.nextLine();

                    User newUser = new User();
                    newUser.setName(name);
                    newUser.setEmail(email);
                    newUser.setMobile(mobile);
                    newUser.setPwd(pwd);
                    system.registerUser(newUser);
                    break;

                case 2: // Login
                    System.out.print("Enter Email: ");
                    String loginEmail = sc.nextLine();
                    System.out.print("Enter Password: ");
                    String loginPwd = sc.nextLine();
                    currentUser = system.userLogin(loginEmail, loginPwd);
                    if (currentUser != null) {
                        System.out.println("Login Successful!");
                    } else {
                        System.out.println("Invalid Credentials.");
                    }
                    break;

                case 3: // Create main.java.com.cab.model.Ride
                    if (currentUser == null) {
                        System.out.println("Please login first.");
                        break;
                    }
                    System.out.print("Source: ");
                    String src = sc.nextLine();
                    System.out.print("Destination: ");
                    String dest = sc.nextLine();
                    System.out.print("Total Seats: ");
                    int seats = sc.nextInt();
                    System.out.print("Fare: ");
                    double fare = sc.nextDouble();

                    system.createRide(currentUser, src, dest, seats, fare);
                    break;

                case 4: // View All
                    List<Ride> allRides = system.getRideList();
                    for (int i = 0; i < allRides.size(); i++) {
                        System.out.println((i + 1) + ". " + allRides.get(i));
                    }
                    break;

                case 5: // Search
                    System.out.print("Source: ");
                    String s = sc.nextLine();
                    System.out.print("Destination: ");
                    String d = sc.nextLine();
                    List<Ride> found = system.searchRide(s, d);
                    if(found.isEmpty()) System.out.println("No rides found.");
                    else found.forEach(System.out::println);
                    break;

                case 6:
                    if(currentUser == null) { System.out.println("Login first."); break; }
                    System.out.print("New Name: ");
                    String nName = sc.nextLine();
                    System.out.print("New Email: ");
                    String nEmail = sc.nextLine();
                    System.out.print("New Mobile: ");
                    long nMob = sc.nextLong();
                    system.updateUser(currentUser, nName, nEmail, nMob);
                    break;

                // NEW CASE 7: Delete Account
                case 7:
                    if(currentUser == null) { System.out.println("Login first."); break; }
                    System.out.print("Are you sure? (yes/no): ");
                    String confirm = sc.nextLine();
                    if(confirm.equalsIgnoreCase("yes")) {
                        system.deleteAccount(currentUser);
                        currentUser = null; // Log them out
                    }
                    break;

                // NEW CASE 8: Manage My Rides (Update/Cancel)
                case 8:
                    if(currentUser == null) { System.out.println("Login first."); break; }

                    // Find rides created by this user
                    List<Ride> myRides = new ArrayList<>();
                    for(Ride r : system.getRideList()) {
                        if(r.getCreatedBy().equals(currentUser)) {
                            myRides.add(r);
                        }
                    }

                    if(myRides.isEmpty()) {
                        System.out.println("You have no active rides.");
                    } else {
                        // Display main.java.com.cab.model.User's Rides
                        for(int i=0; i<myRides.size(); i++) {
                            System.out.println((i+1) + ". " + myRides.get(i).getSource() + " to " + myRides.get(i).getDestination());
                        }

                        System.out.println("Enter main.java.com.cab.model.Ride Number to manage (0 to go back):");
                        int rIdx = sc.nextInt() - 1;
                        sc.nextLine(); // consume newline

                        if(rIdx >= 0 && rIdx < myRides.size()) {
                            Ride selectedRide = myRides.get(rIdx);
                            System.out.println("Type 'u' to Update or 'c' to Cancel this ride:");
                            String action = sc.nextLine();

                            if(action.equalsIgnoreCase("c")) {
                                system.cancelRide(selectedRide);
                            } else if (action.equalsIgnoreCase("u")) {
                                System.out.print("New Source: ");
                                String ns = sc.nextLine();
                                System.out.print("New Destination: ");
                                String nd = sc.nextLine();
                                System.out.print("New Fare: ");
                                double nf = sc.nextDouble();
                                system.updateRide(selectedRide, ns, nd, nf);
                            }
                        }
                    }
                    break;

                case 9:
                    currentUser = null;
                    System.out.println("Logged out.");
                    break;
                default:
                    System.out.println("Invalid choice");
            }
        }
    }
}