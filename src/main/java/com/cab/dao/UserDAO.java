package com.cab.dao;

import com.cab.model.User;
import com.cab.util.DBConnection;

import java.sql.*;
import java.time.LocalDate;
import java.util.ArrayList;
import java.util.List;

public class UserDAO {

public boolean registerUser(User user) {
        String sql = "INSERT INTO users (name, email, mobile, password, has_license, " +
                "license_number, license_expiry_month, license_expiry_year, " +
                "license_verified, license_uploaded_at) " +
                "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";

        try (Connection conn = DBConnection.getConnection();
                PreparedStatement pstmt = conn.prepareStatement(sql)) {

            pstmt.setString(1, user.getName());
            pstmt.setString(2, user.getEmail());
            pstmt.setLong(3, user.getMobile());
            pstmt.setString(4, user.getPwd());
            pstmt.setBoolean(5, user.isHasLicense());

            if (user.isHasLicense() && user.getLicenseNumber() != null) {
                pstmt.setString(6, user.getLicenseNumber());
                pstmt.setInt(7, user.getLicenseExpiryMonth());
                pstmt.setInt(8, user.getLicenseExpiryYear());
                pstmt.setBoolean(9, true); 
                pstmt.setTimestamp(10, new Timestamp(System.currentTimeMillis()));
            } else {
                pstmt.setNull(6, Types.VARCHAR);
                pstmt.setNull(7, Types.INTEGER);
                pstmt.setNull(8, Types.INTEGER);
                pstmt.setBoolean(9, false);
                pstmt.setNull(10, Types.TIMESTAMP);
            }

            int rowsAffected = pstmt.executeUpdate();
            if (rowsAffected > 0) {
                System.out.println("User registered: " + user.getEmail());
                return true;
            }

        } catch (SQLException e) {
            System.err.println("Error registering user: " + e.getMessage());
            e.printStackTrace();
        }
        return false;
    }

public User loginUser(String email, String password) {
        String sql = "SELECT * FROM users WHERE email = ? AND password = ?";

        try (Connection conn = DBConnection.getConnection();
                PreparedStatement pstmt = conn.prepareStatement(sql)) {

            pstmt.setString(1, email);
            pstmt.setString(2, password);

            ResultSet rs = pstmt.executeQuery();
            if (rs.next()) {
                User user = mapResultSetToUser(rs);
                System.out.println("Login successful: " + email);
                return user;
            } else {
                System.out.println("Login failed: Invalid credentials");
            }

        } catch (SQLException e) {
            System.err.println("Error during login: " + e.getMessage());
            e.printStackTrace();
        }
        return null;
    }

public User getUserById(int userId) {
        String sql = "SELECT * FROM users WHERE user_id = ?";

        try (Connection conn = DBConnection.getConnection();
                PreparedStatement pstmt = conn.prepareStatement(sql)) {

            pstmt.setInt(1, userId);
            ResultSet rs = pstmt.executeQuery();

            if (rs.next()) {
                return mapResultSetToUser(rs);
            }

        } catch (SQLException e) {
            System.err.println("Error fetching user: " + e.getMessage());
            e.printStackTrace();
        }
        return null;
    }

public boolean updateUser(User user) {
        String sql = "UPDATE users SET name = ?, email = ?, mobile = ? WHERE user_id = ?";

        try (Connection conn = DBConnection.getConnection();
                PreparedStatement pstmt = conn.prepareStatement(sql)) {

            pstmt.setString(1, user.getName());
            pstmt.setString(2, user.getEmail());
            pstmt.setLong(3, user.getMobile());
            pstmt.setInt(4, user.getUserId());

            int rowsAffected = pstmt.executeUpdate();
            if (rowsAffected > 0) {
                System.out.println("User updated: " + user.getEmail());
                return true;
            }

        } catch (SQLException e) {
            System.err.println("Error updating user: " + e.getMessage());
            e.printStackTrace();
        }
        return false;
    }

public boolean updateLicense(int userId, String licenseNumber,
            int expiryMonth, int expiryYear) {
        String sql = "UPDATE users SET has_license = TRUE, license_number = ?, " +
                "license_expiry_month = ?, license_expiry_year = ?, " +
                "license_verified = TRUE, license_uploaded_at = ? " +
                "WHERE user_id = ?";

        try (Connection conn = DBConnection.getConnection();
                PreparedStatement pstmt = conn.prepareStatement(sql)) {

            pstmt.setString(1, licenseNumber);
            pstmt.setInt(2, expiryMonth);
            pstmt.setInt(3, expiryYear);
            pstmt.setTimestamp(4, new Timestamp(System.currentTimeMillis()));
            pstmt.setInt(5, userId);

            int rowsAffected = pstmt.executeUpdate();
            if (rowsAffected > 0) {
                System.out.println("License updated for user ID: " + userId);
                return true;
            }

        } catch (SQLException e) {
            System.err.println("Error updating license: " + e.getMessage());
            e.printStackTrace();
        }
        return false;
    }

public boolean canUserCreateRides(int userId) {
        String sql = "SELECT has_license, license_verified, " +
                "license_expiry_month, license_expiry_year " +
                "FROM users WHERE user_id = ?";

        try (Connection conn = DBConnection.getConnection();
                PreparedStatement pstmt = conn.prepareStatement(sql)) {

            pstmt.setInt(1, userId);
            ResultSet rs = pstmt.executeQuery();

            if (rs.next()) {
                boolean hasLicense = rs.getBoolean("has_license");
                boolean verified = rs.getBoolean("license_verified");
                Integer expiryMonth = (Integer) rs.getObject("license_expiry_month");
                Integer expiryYear = (Integer) rs.getObject("license_expiry_year");

                if (!hasLicense || !verified || expiryMonth == null || expiryYear == null) {
                    return false;
                }

                LocalDate now = LocalDate.now();
                if (expiryYear < now.getYear())
                    return false;
                if (expiryYear == now.getYear() && expiryMonth < now.getMonthValue())
                    return false;

                return true;
            }

        } catch (SQLException e) {
            System.err.println("Error checking license: " + e.getMessage());
            e.printStackTrace();
        }
        return false;
    }

public boolean deleteUser(int userId) {
        String sql = "DELETE FROM users WHERE user_id = ?";

        try (Connection conn = DBConnection.getConnection();
                PreparedStatement pstmt = conn.prepareStatement(sql)) {

            pstmt.setInt(1, userId);
            int rowsAffected = pstmt.executeUpdate();
            if (rowsAffected > 0) {
                System.out.println("User deleted: ID " + userId);
                return true;
            }

        } catch (SQLException e) {
            System.err.println("Error deleting user: " + e.getMessage());
            e.printStackTrace();
        }
        return false;
    }

public boolean emailExists(String email) {
        String sql = "SELECT COUNT(*) FROM users WHERE email = ?";

        try (Connection conn = DBConnection.getConnection();
                PreparedStatement pstmt = conn.prepareStatement(sql)) {

            pstmt.setString(1, email);
            ResultSet rs = pstmt.executeQuery();
            if (rs.next())
                return rs.getInt(1) > 0;

        } catch (SQLException e) {
            System.err.println("Error checking email: " + e.getMessage());
            e.printStackTrace();
        }
        return false;
    }

public List<User> getAllUsers() {
        List<User> users = new ArrayList<>();
        String sql = "SELECT * FROM users ORDER BY created_at DESC";

        try (Connection conn = DBConnection.getConnection();
                Statement stmt = conn.createStatement();
                ResultSet rs = stmt.executeQuery(sql)) {

            while (rs.next()) {
                users.add(mapResultSetToUser(rs));
            }

        } catch (SQLException e) {
            System.err.println("Error fetching users: " + e.getMessage());
            e.printStackTrace();
        }
        return users;
    }

private User mapResultSetToUser(ResultSet rs) throws SQLException {
        User user = new User();
        user.setUserId(rs.getInt("user_id"));
        user.setName(rs.getString("name"));
        user.setEmail(rs.getString("email"));
        user.setMobile(rs.getLong("mobile"));
        user.setPwd(rs.getString("password"));

user.setHasLicense(rs.getBoolean("has_license"));
        user.setLicenseNumber(rs.getString("license_number"));
        user.setLicenseExpiryMonth((Integer) rs.getObject("license_expiry_month"));
        user.setLicenseExpiryYear((Integer) rs.getObject("license_expiry_year"));
        user.setLicenseVerified(rs.getBoolean("license_verified"));

        return user;
    }
}