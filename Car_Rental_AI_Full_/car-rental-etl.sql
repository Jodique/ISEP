-- ETL Process for Car Rental Data Warehouse

-- Dimension Preparation: Truncate existing dimensions before loading
CREATE OR REPLACE PROCEDURE prepare_dimensions()
BEGIN
    TRUNCATE TABLE dim_date;
    TRUNCATE TABLE dim_customer;
    TRUNCATE TABLE dim_vehicle;
    TRUNCATE TABLE dim_branch;
END;

-- Date Dimension Population
CREATE OR REPLACE PROCEDURE populate_date_dimension(start_date DATE, end_date DATE)
BEGIN
    WITH date_series AS (
        SELECT generate_series(start_date, end_date, '1 day'::interval) AS full_date
    )
    INSERT INTO dim_date (
        date_key,
        full_date,
        day_of_week,
        day_of_month,
        month,
        month_name,
        quarter,
        year,
        is_weekend,
        is_holiday
    )
    SELECT 
        EXTRACT(YEAR FROM full_date) * 10000 + 
        EXTRACT(MONTH FROM full_date) * 100 + 
        EXTRACT(DAY FROM full_date) AS date_key,
        full_date,
        TO_CHAR(full_date, 'Day') AS day_of_week,
        EXTRACT(DAY FROM full_date) AS day_of_month,
        EXTRACT(MONTH FROM full_date) AS month,
        TO_CHAR(full_date, 'Month') AS month_name,
        EXTRACT(QUARTER FROM full_date) AS quarter,
        EXTRACT(YEAR FROM full_date) AS year,
        EXTRACT(DOW FROM full_date) IN (0,6) AS is_weekend,
        -- Simple holiday example (can be expanded)
        CASE 
            WHEN (EXTRACT(MONTH FROM full_date) = 1 AND EXTRACT(DAY FROM full_date) = 1) THEN TRUE  -- New Year's Day
            WHEN (EXTRACT(MONTH FROM full_date) = 7 AND EXTRACT(DAY FROM full_date) = 4) THEN TRUE  -- Independence Day
            WHEN (EXTRACT(MONTH FROM full_date) = 12 AND EXTRACT(DAY FROM full_date) = 25) THEN TRUE  -- Christmas
            ELSE FALSE
        END AS is_holiday
    FROM date_series;
END;

-- Customer Dimension Population
CREATE OR REPLACE PROCEDURE populate_customer_dimension()
BEGIN
    INSERT INTO dim_customer (
        customer_key,
        customer_id,
        first_name,
        last_name,
        age_group,
        city,
        state,
        country,
        registration_year,
        total_rentals,
        customer_segment
    )
    SELECT 
        ROW_NUMBER() OVER (ORDER BY c.customer_id) AS customer_key,
        c.customer_id,
        c.first_name,
        c.last_name,
        CASE 
            WHEN (EXTRACT(YEAR FROM AGE(c.date_of_birth)) < 25) THEN 'Under 25'
            WHEN (EXTRACT(YEAR FROM AGE(c.date_of_birth)) BETWEEN 25 AND 40) THEN '25-40'
            WHEN (EXTRACT(YEAR FROM AGE(c.date_of_birth)) BETWEEN 41 AND 60) THEN '41-60'
            ELSE 'Over 60'
        END AS age_group,
        c.city,
        c.state,
        'United States' AS country,
        EXTRACT(YEAR FROM c.registration_date) AS registration_year,
        (
            SELECT COUNT(*) 
            FROM rental_reservation rr 
            WHERE rr.customer_id = c.customer_id
        ) AS total_rentals,
        CASE 
            WHEN (
                SELECT COUNT(*) 
                FROM rental_reservation rr 
                WHERE rr.customer_id = c.customer_id
            ) > 10 THEN 'Frequent'
            WHEN (
                SELECT COUNT(*) 
                FROM rental_reservation rr 
                WHERE rr.customer_id = c.customer_id
            ) > 3 THEN 'Regular'
            ELSE 'Occasional'
        END AS customer_segment
    FROM customer c;
END;

-- Vehicle Dimension Population
CREATE OR REPLACE PROCEDURE populate_vehicle_dimension()
BEGIN
    INSERT INTO dim_vehicle (
        vehicle_key,
        vehicle_id,
        make,
        model,
        year,
        vehicle_type,
        color,
        transmission_type,
        purchase_year,
        age_group
    )
    SELECT 
        ROW_NUMBER() OVER (ORDER BY v.vehicle_id) AS vehicle_key,
        v.vehicle_id,
        v.make,
        v.model,
        v.year,
        vt.type_name AS vehicle_type,
        v.color,
        v.transmission_type,
        EXTRACT(YEAR FROM v.purchase_date) AS purchase_year,
        CASE 
            WHEN (EXTRACT(YEAR FROM CURRENT_DATE) - v.year < 3) THEN 'New (0-3 years)'
            WHEN (EXTRACT(YEAR FROM CURRENT_DATE) - v.year BETWEEN 3 AND 7) THEN 'Mid-age (3-7 years)'
            ELSE 'Older (7+ years)'
        END AS age_group
    FROM vehicle v
    JOIN vehicle_type vt ON v.type_id = vt.type_id;
END;

-- Branch Dimension Population
CREATE OR REPLACE PROCEDURE populate_branch_dimension()
BEGIN
    INSERT INTO dim_branch (
        branch_key,
        branch_id,
        branch_name,
        city,
        state,
        region,
        branch_type
    )
    SELECT 
        ROW_NUMBER() OVER (ORDER BY branch_id) AS branch_key,
        branch_id,
        branch_name,
        city,
        state,
        CASE 
            WHEN state IN ('CA', 'OR', 'WA') THEN 'West Coast'
            WHEN state IN ('NY', 'NJ', 'CT', 'MA') THEN 'Northeast'
            WHEN state IN ('TX', 'FL') THEN 'Large Market'
            ELSE 'Other Regions'
        END AS region,
        CASE 
            WHEN (SELECT COUNT(*) FROM vehicle WHERE current_branch_id = b.branch_id) > 100 THEN 'Large'
            WHEN (SELECT COUNT(*) FROM vehicle WHERE current_branch_id = b.branch_id) > 50 THEN 'Medium'
            ELSE 'Small'
        END AS branch_type
    FROM branch b;
END;

-- Booking Fact Table Population
CREATE OR REPLACE PROCEDURE populate_booking_fact()
BEGIN
    INSERT INTO fact_booking (
        booking_key,
        date_key,
        customer_key,
        vehicle_key,
        pickup_branch_key,
        return_branch_key,
        total_bookings,
        total_revenue,
        rental_days,
        base_rental_revenue,
        insurance_revenue,
        additional_charges,
        advance_booking_days,
        is_peak_season,
        is_weekend_booking
    )
    SELECT 
        ROW_NUMBER() OVER (ORDER BY rr.reservation_id) AS booking_key,
        EXTRACT(YEAR FROM rr.pickup_datetime) * 10000 + 
        EXTRACT(MONTH FROM rr.pickup_datetime) * 100 + 
        EXTRACT(DAY FROM rr.pickup_datetime) AS date_key,
        dc.customer_key,
        dv.vehicle_key,
        dpickup.branch_key AS pickup_branch_key,
        dreturn.branch_key AS return_branch_key,
        1 AS total_bookings,
        bd.total_cost AS total_revenue,
        (EXTRACT(EPOCH FROM (rr.return_datetime - rr.pickup_datetime)) / (24 * 3600))::INT AS rental_days,
        bd.base_rental_cost AS base_rental_revenue,
        bd.insurance_cost AS insurance_revenue,
        bd.additional_charges,
        (EXTRACT(EPOCH FROM (rr.pickup_datetime - CURRENT_TIMESTAMP)) / (24 * 3600))::INT AS advance_booking_days,
        CASE 
            WHEN EXTRACT(MONTH FROM rr.pickup_datetime) IN (6, 7, 8) THEN TRUE
            ELSE FALSE
        END AS is_peak_season,
        EXTRACT(DOW FROM rr.pickup_datetime) IN (0,6) AS is_weekend_booking
    FROM rental_reservation rr
    JOIN customer c ON rr.customer_id = c.customer_id
    JOIN vehicle v ON rr.vehicle_id = v.vehicle_id
    JOIN billing_detail bd ON rr.reservation_id = bd.reservation_id
    JOIN dim_customer dc ON c.customer_id = dc.customer_id
    JOIN dim_vehicle dv ON v.vehicle_id = dv.vehicle_id
    JOIN dim_branch dpickup ON rr.pickup_branch_id = dpickup.branch_id
    JOIN dim_branch dreturn ON rr.return_branch_id = dreturn.branch_id;
END;

-- Master ETL Procedure
CREATE OR REPLACE PROCEDURE run_car_rental_etl(start_date DATE, end_date DATE)
BEGIN
    -- Prepare dimensions
    CALL prepare_dimensions();
    
    -- Populate dimensions
    CALL populate_date_dimension(start_date, end_date);
    CALL populate_customer_dimension();
    CALL populate_vehicle_dimension();
    CALL populate_branch_dimension();
    
    -- Populate fact table
    CALL populate_booking_fact();
END;

-- Example Execution
-- CALL run_car_rental_etl('2023-01-01', '2023-12-31');
