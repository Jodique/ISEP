-- TRUNCATE TABLE f_BOOKING; 

INSERT INTO f_booking (
	customer_id, 
	vehicle_id, 
	date, 
	customer, 
	brand_model, 
	vehicle_plate, 
	start_rent, end_rent, 
	active, etl_ts
	)
	
SELECT 
    c.id_customer AS customer_id,
    v.id_vehicle AS vehicle_id,
    v.start_rent AS date,
    CONCAT(c.first_name, ' ', c.last_name) AS customer,
    CONCAT(v.brand, ' ', v.model) AS brand_model,
    v.plate AS vehicle_plate,
    v.start_rent AS start_rent,
    v.end_rent AS end_rent,
    'Y' AS active,
    CURRENT_TIMESTAMP AS etl_ts

FROM 
    d_customer c
	
LEFT JOIN d_vehicle v 
	ON c.location_id= v.location_id
	
LEFT JOIN d_calendar cal 
	ON cal.date BETWEEN v.start_rent AND v.end_rent
	
WHERE 
    c.active = 'Y' AND v.start_rent <= v.end_rent
;

SELECT * FROM f_BOOKING;