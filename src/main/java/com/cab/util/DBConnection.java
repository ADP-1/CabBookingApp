package com.cab.util;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;


public class DBConnection {

    private static final String URL = "jdbc:postgresql://localhost:5432/cab_booking_db";
    private static final String USERNAME = "postgres";
    private static final String PASSWORD = "toor";  // CHANGE THIS!

    // JDBC Driver
    private static final String DRIVER = "org.postgresql.Driver";

    // Static block to load driver once
    static {
        try {
            Class.forName(DRIVER);
            System.out.println("PostgreSQL JDBC Driver loaded successfully!");
        } catch (ClassNotFoundException e) {
            System.err.println("PostgreSQL JDBC Driver not found!");
            e.printStackTrace();
        }
    }


    public static Connection getConnection() throws SQLException {
        try {
            Connection conn = DriverManager.getConnection(URL, USERNAME, PASSWORD);
            System.out.println("Database connection established!");
            return conn;
        } catch (SQLException e) {
            System.err.println("Failed to connect to database!");
            System.err.println("URL: " + URL);
            System.err.println("Error: " + e.getMessage());
            throw e;
        }
    }


    public static void closeConnection(Connection conn) {
        if (conn != null) {
            try {
                conn.close();
                System.out.println("Database connection closed.");
            } catch (SQLException e) {
                System.err.println("Error closing connection: " + e.getMessage());
            }
        }
    }


    public static void main(String[] args) {
        System.out.println("Testing database connection...");

        Connection conn = null;
        try {
            conn = getConnection();
            System.out.println("✓ SUCCESS: Connected to PostgreSQL database!");
            System.out.println("✓ Database: cab_booking_db");
            System.out.println("✓ Connection valid: " + !conn.isClosed());
        } catch (SQLException e) {
            System.err.println("✗ FAILED: Could not connect to database");
            System.err.println("Check:");
            System.err.println("  1. PostgreSQL is running");
            System.err.println("  2. Database 'cab_booking_db' exists");
            System.err.println("  3. Username and password are correct");
            System.err.println("  4. postgresql-42.6.0.jar is in classpath");
        } finally {
            closeConnection(conn);
        }
    }
}