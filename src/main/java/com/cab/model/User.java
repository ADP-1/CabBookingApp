package com.cab.model;

import java.time.LocalDate;

public class User {
    private int userId;
    private String name;
    private String email;
    private long mobile;
    private String pwd;

    // Driving License fields
    private boolean hasLicense;
    private String licenseNumber;
    private Integer licenseExpiryMonth;
    private Integer licenseExpiryYear;
    private boolean licenseVerified;

    public User() {
        this.hasLicense = false;
        this.licenseVerified = false;
    }

    // Core getters/setters
    public int getUserId() {
        return userId;
    }

    public void setUserId(int userId) {
        this.userId = userId;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public String getEmail() {
        return email;
    }

    public void setEmail(String email) {
        this.email = email;
    }

    public long getMobile() {
        return mobile;
    }

    public void setMobile(long mobile) {
        this.mobile = mobile;
    }

    public String getPwd() {
        return pwd;
    }

    public void setPwd(String pwd) {
        this.pwd = pwd;
    }

    // License getters/setters
    public boolean isHasLicense() {
        return hasLicense;
    }

    public void setHasLicense(boolean hasLicense) {
        this.hasLicense = hasLicense;
    }

    public String getLicenseNumber() {
        return licenseNumber;
    }

    public void setLicenseNumber(String licenseNumber) {
        this.licenseNumber = licenseNumber;
    }

    public Integer getLicenseExpiryMonth() {
        return licenseExpiryMonth;
    }

    public void setLicenseExpiryMonth(Integer licenseExpiryMonth) {
        this.licenseExpiryMonth = licenseExpiryMonth;
    }

    public Integer getLicenseExpiryYear() {
        return licenseExpiryYear;
    }

    public void setLicenseExpiryYear(Integer licenseExpiryYear) {
        this.licenseExpiryYear = licenseExpiryYear;
    }

    public boolean isLicenseVerified() {
        return licenseVerified;
    }

    public void setLicenseVerified(boolean licenseVerified) {
        this.licenseVerified = licenseVerified;
    }

    /**
     * Check if the driving license has expired
     */
    public boolean isLicenseExpired() {
        if (!hasLicense || licenseExpiryMonth == null || licenseExpiryYear == null)
            return true;
        LocalDate now = LocalDate.now();
        if (licenseExpiryYear < now.getYear())
            return true;
        if (licenseExpiryYear == now.getYear() && licenseExpiryMonth < now.getMonthValue())
            return true;
        return false;
    }

    /**
     * Check if user can create rides (has valid, verified, non-expired license)
     */
    public boolean canCreateRides() {
        return hasLicense && licenseVerified && !isLicenseExpired();
    }

    /**
     * Get license expiry as "MM/YYYY" or "Not Available"
     */
    public String getLicenseExpiryFormatted() {
        if (licenseExpiryMonth != null && licenseExpiryYear != null) {
            return String.format("%02d/%d", licenseExpiryMonth, licenseExpiryYear);
        }
        return "Not Available";
    }

    @Override
    public String toString() {
        return "User{" +
                "userId=" + userId +
                ", name='" + name + '\'' +
                ", email='" + email + '\'' +
                ", mobile=" + mobile +
                ", hasLicense=" + hasLicense +
                ", licenseVerified=" + licenseVerified +
                '}';
    }
}