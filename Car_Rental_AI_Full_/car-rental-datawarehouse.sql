-- Dimensional Model for Car Rental Booking Analysis

-- Dimension Tables

-- Date Dimension (Critical for time-based analysis)
CREATE TABLE dim_date (
    date_key INT PRIMARY KEY,
    full_date DATE,
    day_of_week VARCHAR(10),
    day_of_month INT,
    month INT,
    month_name VARCHAR(20),
    quarter INT,
    year INT,
    is_weekend BOOLEAN,
    is_holiday BOOLEAN
);

-- Customer Dimension
CREATE TABLE dim_customer (
    customer_key INT PRIMARY KEY,
    customer_id INT,
    first_name VARCHAR(50),
    last_name VARCHAR(50),
    age_group VARCHAR(20),
    city VARCHAR(100),
    state VARCHAR(50),
    country VARCHAR(50),
    registration_year INT,
    total_rentals INT,
    customer_segment VARCHAR(50)
);

-- Vehicle Dimension
CREATE TABLE dim_vehicle (
    vehicle_key INT PRIMARY KEY,
    vehicle_id INT,
    make VARCHAR(50),
    model VARCHAR(50),
    year INT,
    vehicle_type VARCHAR(50),
    color VARCHAR(50),
    transmission_type VARCHAR(20),
    purchase_year INT,
    age_group VARCHAR(20)
);

-- Branch Dimension
CREATE TABLE dim_branch (
    branch_key INT PRIMARY KEY,
    branch_id INT,
    branch_name VARCHAR(100),
    city VARCHAR(100),
    state VARCHAR(50),
    region VARCHAR(50),
    branch_type VARCHAR(50)
);

-- Booking Fact Table
CREATE TABLE fact_booking (
    booking_key BIGINT PRIMARY KEY,
    date_key INT,
    customer_key INT,
    vehicle_key INT,
    pickup_branch_key INT,
    return_branch_key INT,
    
    -- Booking Metrics
    total_bookings INT,
    total_revenue DECIMAL(12,2),
    rental_days INT,
    
    -- Revenue Metrics
    base_rental_revenue DECIMAL(12,2),
    insurance_revenue DECIMAL(12,2),
    additional_charges DECIMAL(12,2),
    
    -- Performance Metrics
    advance_booking_days INT,
    is_peak_season BOOLEAN,
    is_weekend_booking BOOLEAN,
    
    -- Foreign Keys
    FOREIGN KEY (date_key) REFERENCES dim_date(date_key),
    FOREIGN KEY (customer_key) REFERENCES dim_customer(customer_key),
    FOREIGN KEY (vehicle_key) REFERENCES dim_vehicle(vehicle_key),
    FOREIGN KEY (pickup_branch_key) REFERENCES dim_branch(branch_key),
    FOREIGN KEY (return_branch_key) REFERENCES dim_branch(branch_key)
);

-- ETL Staging View for Booking Analysis
CREATE VIEW vw_booking_analysis AS
SELECT 
    -- Date Dimensions
    dd.year,
    dd.quarter,
    dd.month_name,
    dd.day_of_week,
    dd.is_weekend,
    
    -- Customer Dimensions
    dc.customer_segment,
    dc.age_group AS customer_age_group,
    dc.city AS customer_city,
    dc.state AS customer_state,
    
    -- Vehicle Dimensions
    dv.vehicle_type,
    dv.make,
    dv.model,
    dv.age_group AS vehicle_age_group,
    
    -- Branch Dimensions
    db_pickup.city AS pickup_city,
    db_pickup.state AS pickup_state,
    db_pickup.region AS pickup_region,
    
    -- Aggregated Metrics
    SUM(fb.total_bookings) AS total_bookings,
    SUM(fb.total_revenue) AS total_revenue,
    AVG(fb.rental_days) AS avg_rental_duration,
    SUM(fb.base_rental_revenue) AS base_rental_revenue,
    SUM(fb.insurance_revenue) AS insurance_revenue,
    AVG(fb.advance_booking_days) AS avg_advance_booking_days
FROM 
    fact_booking fb
    JOIN dim_date dd ON fb.date_key = dd.date_key
    JOIN dim_customer dc ON fb.customer_key = dc.customer_key
    JOIN dim_vehicle dv ON fb.vehicle_key = dv.vehicle_key
    JOIN dim_branch db_pickup ON fb.pickup_branch_key = db_pickup.branch_key
GROUP BY 
    dd.year, dd.quarter, dd.month_name, dd.day_of_week, dd.is_weekend,
    dc.customer_segment, dc.age_group, dc.city, dc.state,
    dv.vehicle_type, dv.make, dv.model, dv.age_group,
    db_pickup.city, db_pickup.state, db_pickup.region;

-- Example ETL Dimension Population Procedure (Pseudo-code)
CREATE OR REPLACE PROCEDURE populate_customer_dimension()
BEGIN
    -- Truncate existing dimension
    TRUNCATE TABLE dim_customer;
    
    -- Populate customer dimension with enhanced attributes
    INSERT INTO dim_customer (
        customer_key, customer_id, first_name, last_name,
        age_group, city, state, country,
        registration_year, total_rentals, customer_segment
    )
    SELECT 
        ROW_NUMBER() OVER (ORDER BY customer_id) AS customer_key,
        customer_id,
        first_name,
        last_name,
        CASE 
            WHEN EXTRACT(YEAR FROM AGE(date_of_birth)) < 25 THEN 'Under 25'
            WHEN EXTRACT(YEAR FROM AGE(date_of_birth)) BETWEEN 25 AND 40 THEN '25-40'
            WHEN EXTRACT(YEAR FROM AGE(date_of_birth)) BETWEEN 41 AND 60 THEN '41-60'
            ELSE 'Over 60'
        END AS age_group,
        city,
        state,
        'United States' AS country,
        EXTRACT(YEAR FROM registration_date) AS registration_year,
        (SELECT COUNT(*) FROM rental_reservation WHERE customer_id = c.customer_id) AS total_rentals,
        CASE 
            WHEN total_rentals > 10 THEN 'Frequent'
            WHEN total_rentals > 3 THEN 'Regular'
            ELSE 'Occasional'
        END AS customer_segment
    FROM 
        customer c;
END;

-- Key Performance Indicators View
CREATE VIEW vw_booking_kpis AS
SELECT 
    year,
    quarter,
    month_name,
    
    -- Booking Volume KPIs
    SUM(total_bookings) AS total_bookings,
    AVG(total_bookings) AS avg_monthly_bookings,
    
    -- Revenue KPIs
    SUM(total_revenue) AS total_revenue,
    AVG(total_revenue) AS avg_monthly_revenue,
    MAX(total_revenue) AS peak_month_revenue,
    
    -- Rental Performance KPIs
    AVG(avg_rental_duration) AS avg_rental_duration,
    SUM(base_rental_revenue) AS base_rental_revenue,
    SUM(insurance_revenue) AS insurance_revenue,
    
    -- Booking Advance KPIs
    AVG(avg_advance_booking_days) AS avg_advance_booking_days
FROM 
    vw_booking_analysis
GROUP BY 
    year, quarter, month_name
ORDER BY 
    year, quarter, month_name;
