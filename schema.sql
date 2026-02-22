-- ============================================================
-- CLEANUP (optional – use carefully in production)
-- ============================================================
DROP TABLE IF EXISTS bookings CASCADE;
DROP TABLE IF EXISTS rides CASCADE;
DROP TABLE IF EXISTS users CASCADE;

-- ============================================================
-- TABLE: users
-- ============================================================
CREATE TABLE users (
                       user_id SERIAL PRIMARY KEY,
                       name VARCHAR(100) NOT NULL,
                       email VARCHAR(100) UNIQUE NOT NULL,
                       mobile BIGINT NOT NULL,
                       password VARCHAR(255) NOT NULL,

    -- Driving License Fields
                       has_license BOOLEAN DEFAULT FALSE,
                       license_number VARCHAR(20),
                       license_expiry_month INT,
                       license_expiry_year INT,
                       license_verified BOOLEAN DEFAULT FALSE,
                       license_uploaded_at TIMESTAMP,

                       created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
                       updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,

    -- License expiry validation
                       CONSTRAINT chk_expiry_month
                           CHECK (license_expiry_month IS NULL
                               OR (license_expiry_month BETWEEN 1 AND 12)),

                       CONSTRAINT chk_expiry_year
                           CHECK (license_expiry_year IS NULL
                               OR license_expiry_year >= 2024)
);

-- Indexes
CREATE INDEX idx_users_email ON users(email);
CREATE INDEX idx_users_license ON users(has_license, license_verified);

-- Documentation
COMMENT ON COLUMN users.has_license IS 'Whether user has uploaded license details';
COMMENT ON COLUMN users.license_number IS 'Driving license number';
COMMENT ON COLUMN users.license_expiry_month IS 'License expiry month (1-12)';
COMMENT ON COLUMN users.license_expiry_year IS 'License expiry year';
COMMENT ON COLUMN users.license_verified IS 'Whether license is verified and valid';

-- ============================================================
-- TABLE: rides
-- ============================================================
CREATE TABLE rides (
                       ride_id SERIAL PRIMARY KEY,

                       source VARCHAR(100) NOT NULL,
                       destination VARCHAR(100) NOT NULL,

                       total_seats INT NOT NULL CHECK (total_seats > 0),
                       available_seats INT NOT NULL CHECK (available_seats >= 0),
                       fare DECIMAL(10,2) NOT NULL CHECK (fare >= 0),

                       driver_id INT NOT NULL,
                       status VARCHAR(20) DEFAULT 'ACTIVE',

    -- Date & Time fields
                       ride_date DATE NOT NULL DEFAULT CURRENT_DATE,
                       ride_time TIME NOT NULL DEFAULT CURRENT_TIME,
                       ride_datetime TIMESTAMP GENERATED ALWAYS AS (ride_date + ride_time) STORED,

                       created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
                       updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,

    -- Foreign key
                       CONSTRAINT fk_driver
                           FOREIGN KEY (driver_id)
                               REFERENCES users(user_id)
                               ON DELETE CASCADE,

    -- Seat consistency
                       CONSTRAINT chk_available_seats
                           CHECK (available_seats <= total_seats),

    -- Prevent past rides
                       CONSTRAINT chk_future_ride
                           CHECK (
                               ride_date > CURRENT_DATE
                                   OR (ride_date = CURRENT_DATE AND ride_time >= CURRENT_TIME)
                               )
);

-- Indexes
CREATE INDEX idx_rides_source_dest ON rides(source, destination);
CREATE INDEX idx_rides_driver ON rides(driver_id);
CREATE INDEX idx_rides_status ON rides(status);
CREATE INDEX idx_rides_datetime ON rides(ride_date, ride_time);

COMMENT ON COLUMN rides.ride_date IS 'Date of the ride';
COMMENT ON COLUMN rides.ride_time IS 'Time of the ride';
COMMENT ON COLUMN rides.ride_datetime IS 'Combined date and time for sorting';

-- ============================================================
-- TABLE: bookings
-- ============================================================
CREATE TABLE bookings (
                          booking_id VARCHAR(50) PRIMARY KEY,

                          ride_id INT NOT NULL,
                          passenger_id INT NOT NULL,

                          seats_booked INT NOT NULL CHECK (seats_booked > 0),
                          status VARCHAR(30) DEFAULT 'CONFIRMED',

                          created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,

                          CONSTRAINT fk_ride
                              FOREIGN KEY (ride_id)
                                  REFERENCES rides(ride_id)
                                  ON DELETE CASCADE,

                          CONSTRAINT fk_passenger
                              FOREIGN KEY (passenger_id)
                                  REFERENCES users(user_id)
                                  ON DELETE CASCADE
);

-- Indexes
CREATE INDEX idx_bookings_passenger ON bookings(passenger_id);
CREATE INDEX idx_bookings_ride ON bookings(ride_id);
CREATE INDEX idx_bookings_status ON bookings(status);

-- ============================================================
-- TRIGGER: Auto-update updated_at
-- ============================================================
CREATE OR REPLACE FUNCTION update_timestamp()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = CURRENT_TIMESTAMP;
RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER update_users_timestamp
    BEFORE UPDATE ON users
    FOR EACH ROW
    EXECUTE FUNCTION update_timestamp();

CREATE TRIGGER update_rides_timestamp
    BEFORE UPDATE ON rides
    FOR EACH ROW
    EXECUTE FUNCTION update_timestamp();