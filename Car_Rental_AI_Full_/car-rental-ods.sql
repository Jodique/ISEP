-- Car Rental Operational Data Store (ODS)

-- Schema Creation
CREATE SCHEMA car_rental_ods;
SET search_path TO car_rental_ods;

-- Operational Staging Tables

-- Staging Table for Customer Data
CREATE TABLE stg_customer (
    staging_id SERIAL PRIMARY KEY,
    source_system VARCHAR(50),
    source_table VARCHAR(50),
    customer_id INT,
    first_name VARCHAR(50),
    last_name VARCHAR(50),
    email VARCHAR(100),
    phone VARCHAR(20),
    driver_license VARCHAR(50),
    date_of_birth DATE,
    registration_date TIMESTAMP,
    address VARCHAR(255),
    city VARCHAR(100),
    state VARCHAR(50),
    postal_code VARCHAR(20),
    load_timestamp TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    record_status VARCHAR(20) DEFAULT 'NEW'
);

-- Staging Table for Vehicle Data
CREATE TABLE stg_vehicle (
    staging_id SERIAL PRIMARY KEY,
    source_system VARCHAR(50),
    source_table VARCHAR(50),
    vehicle_id INT,
    license_plate VARCHAR(20),
    vin VARCHAR(17),
    make VARCHAR(50),
    model VARCHAR(50),
    year INT,
    current_mileage INT,
    vehicle_type VARCHAR(50),
    status VARCHAR(50),
    current_branch_id INT,
    last_service_date DATE,
    purchase_date DATE,
    color VARCHAR(50),
    transmission_type VARCHAR(20),
    load_timestamp TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    record_status VARCHAR(20) DEFAULT 'NEW'
);

-- Staging Table for Rental Reservations
CREATE TABLE stg_rental_reservation (
    staging_id SERIAL PRIMARY KEY,
    source_system VARCHAR(50),
    source_table VARCHAR(50),
    reservation_id INT,
    customer_id INT,
    vehicle_id INT,
    pickup_branch_id INT,
    return_branch_id INT,
    pickup_datetime TIMESTAMP,
    return_datetime TIMESTAMP,
    reservation_status VARCHAR(50),
    total_estimated_cost DECIMAL(10,2),
    actual_return_mileage INT,
    actual_return_datetime TIMESTAMP,
    load_timestamp TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    record_status VARCHAR(20) DEFAULT 'NEW'
);

-- Operational Tracking Tables

-- Change Data Capture (CDC) Table for Customers
CREATE TABLE cdc_customer (
    cdc_id SERIAL PRIMARY KEY,
    customer_id INT,
    change_type VARCHAR(10), -- INSERT, UPDATE, DELETE
    old_data JSONB,
    new_data JSONB,
    change_timestamp TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Change Data Capture (CDC) Table for Vehicles
CREATE TABLE cdc_vehicle (
    cdc_id SERIAL PRIMARY KEY,
    vehicle_id INT,
    change_type VARCHAR(10),
    old_data JSONB,
    new_data JSONB,
    change_timestamp TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Operational Procedures

-- Procedure to Load Customer Data
CREATE OR REPLACE PROCEDURE load_customer_data()
LANGUAGE plpgsql AS $$
BEGIN
    -- Clear existing staging data
    TRUNCATE TABLE stg_customer;
    
    -- Load data from source system
    INSERT INTO stg_customer (
        source_system, 
        source_table, 
        customer_id, 
        first_name, 
        last_name, 
        email, 
        phone, 
        driver_license, 
        date_of_birth, 
        registration_date, 
        address, 
        city, 
        state, 
        postal_code
    )
    SELECT 
        'OPERATIONAL_DB',
        'customer',
        customer_id,
        first_name,
        last_name,
        email,
        phone,
        driver_license,
        date_of_birth,
        registration_date,
        address,
        city,
        state,
        postal_code
    FROM public.customer;  -- Assuming the original table is in public schema
END;
$$;

-- Procedure to Load Vehicle Data
CREATE OR REPLACE PROCEDURE load_vehicle_data()
LANGUAGE plpgsql AS $$
BEGIN
    -- Clear existing staging data
    TRUNCATE TABLE stg_vehicle;
    
    -- Load data from source system
    INSERT INTO stg_vehicle (
        source_system,
        source_table,
        vehicle_id,
        license_plate,
        vin,
        make,
        model,
        year,
        current_mileage,
        vehicle_type,
        status,
        current_branch_id,
        last_service_date,
        purchase_date,
        color,
        transmission_type
    )
    SELECT 
        'OPERATIONAL_DB',
        'vehicle',
        v.vehicle_id,
        v.license_plate,
        v.vin,
        v.make,
        v.model,
        v.year,
        v.current_mileage,
        vt.type_name,
        vs.status_name,
        v.current_branch_id,
        v.last_service_date,
        v.purchase_date,
        v.color,
        v.transmission_type
    FROM public.vehicle v
    JOIN public.vehicle_type vt ON v.type_id = vt.type_id
    JOIN public.vehicle_status vs ON v.status_id = vs.status_id;
END;
$$;

-- Procedure to Load Rental Reservation Data
CREATE OR REPLACE PROCEDURE load_rental_reservation_data()
LANGUAGE plpgsql AS $$
BEGIN
    -- Clear existing staging data
    TRUNCATE TABLE stg_rental_reservation;
    
    -- Load data from source system
    INSERT INTO stg_rental_reservation (
        source_system,
        source_table,
        reservation_id,
        customer_id,
        vehicle_id,
        pickup_branch_id,
        return_branch_id,
        pickup_datetime,
        return_datetime,
        reservation_status,
        total_estimated_cost,
        actual_return_mileage,
        actual_return_datetime
    )
    SELECT 
        'OPERATIONAL_DB',
        'rental_reservation',
        rr.reservation_id,
        rr.customer_id,
        rr.vehicle_id,
        rr.pickup_branch_id,
        rr.return_branch_id,
        rr.pickup_datetime,
        rr.return_datetime,
        rs.status_name,
        bd.total_cost,
        rr.actual_return_mileage,
        rr.actual_return_datetime
    FROM public.rental_reservation rr
    JOIN public.rental_status rs ON rr.status_id = rs.status_id
    LEFT JOIN public.billing_detail bd ON rr.reservation_id = bd.reservation_id;
END;
$$;

-- Procedure to Capture Customer Changes
CREATE OR REPLACE PROCEDURE capture_customer_changes()
LANGUAGE plpgsql AS $$
BEGIN
    -- Capture INSERT changes
    INSERT INTO cdc_vehicle (
        customer_id, 
        change_type, 
        new_data
    )
    SELECT 
        customer_id,
        'INSERT',
        to_jsonb(row) 
    FROM public.customer c
    WHERE NOT EXISTS (
        SELECT 1 
        FROM stg_customer sc 
        WHERE sc.customer_id = c.customer_id
    );

    -- TODO: Implement UPDATE and DELETE change capture
END;
$$;

-- Master ETL Procedure
CREATE OR REPLACE PROCEDURE run_ods_etl()
LANGUAGE plpgsql AS $$
BEGIN
    -- Load staging tables
    CALL load_customer_data();
    CALL load_vehicle_data();
    CALL load_rental_reservation_data();
    
    -- Capture changes
    CALL capture_customer_changes();
END;
$$;

-- Quality Check Views

-- View to Check Data Quality for Customers
CREATE OR REPLACE VIEW vw_customer_data_quality AS
SELECT 
    COUNT(*) AS total_records,
    COUNT(CASE WHEN email IS NULL THEN 1 END) AS null_email_count,
    COUNT(CASE WHEN driver_license IS NULL THEN 1 END) AS null_driver_license_count,
    COUNT(DISTINCT email) AS unique_emails,
    MIN(registration_date) AS earliest_registration,
    MAX(registration_date) AS latest_registration
FROM stg_customer;

-- View to Check Data Quality for Vehicles
CREATE OR REPLACE VIEW vw_vehicle_data_quality AS
SELECT 
    COUNT(*) AS total_records,
    COUNT(CASE WHEN vin IS NULL THEN 1 END) AS null_vin_count,
    COUNT(CASE WHEN license_plate IS NULL THEN 1 END) AS null_license_plate_count,
    COUNT(DISTINCT make) AS unique_makes,
    MIN(purchase_date) AS earliest_purchase,
    MAX(purchase_date) AS latest_purchase
FROM stg_vehicle;

-- View to Check Data Quality for Rental Reservations
CREATE OR REPLACE VIEW vw_rental_reservation_data_quality AS
SELECT 
    COUNT(*) AS total_reservations,
    COUNT(CASE WHEN pickup_datetime > return_datetime THEN 1 END) AS invalid_dates,
    COUNT(CASE WHEN total_estimated_cost < 0 THEN 1 END) AS negative_cost_reservations,
    MIN(pickup_datetime) AS earliest_reservation,
    MAX(pickup_datetime) AS latest_reservation
FROM stg_rental_reservation;
