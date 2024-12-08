-- truncate table d_location;

INSERT INTO public.d_location VALUES (1, 'USA', 'California', 'Los Angeles', 'Y', '2024-12-01 12:00:00');
INSERT INTO public.d_location VALUES (2, 'USA', 'New York', 'New York City', 'Y', '2024-12-01 12:00:00');
INSERT INTO public.d_location VALUES (3, 'Canada', 'Ontario', 'Toronto', 'Y', '2024-12-01 12:00:00');
INSERT INTO public.d_location VALUES (4, 'Canada', 'British Columbia', 'Vancouver', 'Y', '2024-12-01 12:00:00');
INSERT INTO public.d_location VALUES (5, 'UK', 'England', 'London', 'Y', '2024-12-01 12:00:00');
INSERT INTO public.d_location VALUES (6, 'UK', 'Scotland', 'Edinburgh', 'Y', '2024-12-01 12:00:00');
INSERT INTO public.d_location VALUES (7, 'Germany', 'Bavaria', 'Munich', 'Y', '2024-12-01 12:00:00');
INSERT INTO public.d_location VALUES (8, 'Germany', 'Berlin', 'Berlin', 'Y', '2024-12-01 12:00:00');
INSERT INTO public.d_location VALUES (9, 'France', 'Ile-de-France', 'Paris', 'Y', '2024-12-01 12:00:00');
INSERT INTO public.d_location VALUES (10, 'Australia', 'New South Wales', 'Sydney', 'Y', '2024-12-01 12:00:00');
INSERT INTO public.d_location VALUES (11, 'Australia', 'Victoria', 'Melbourne', 'Y', '2024-12-01 12:00:00');
INSERT INTO public.d_location VALUES (12, 'Japan', 'Kanto', 'Tokyo', 'Y', '2024-12-01 12:00:00');
INSERT INTO public.d_location VALUES (13, 'Japan', 'Kansai', 'Osaka', 'Y', '2024-12-01 12:00:00');
INSERT INTO public.d_location VALUES (14, 'India', 'Maharashtra', 'Mumbai', 'Y', '2024-12-01 12:00:00');
INSERT INTO public.d_location VALUES (15, 'India', 'Delhi', 'New Delhi', 'Y', '2024-12-01 12:00:00');
INSERT INTO public.d_location VALUES (16, 'Brazil', 'Rio de Janeiro', 'Rio de Janeiro', 'Y', '2024-12-01 12:00:00');
INSERT INTO public.d_location VALUES (17, 'Brazil', 'São Paulo', 'São Paulo', 'Y', '2024-12-01 12:00:00');
INSERT INTO public.d_location VALUES (18, 'South Africa', 'Gauteng', 'Johannesburg', 'Y', '2024-12-01 12:00:00');
INSERT INTO public.d_location VALUES (19, 'South Africa', 'Western Cape', 'Cape Town', 'Y', '2024-12-01 12:00:00');


-- truncate table d_customer;

INSERT INTO public.d_customer VALUES (16, 1, 'John', 'Doe', 'A123456', '1985-04-12', '123 Elm St', '2024-01-01', '2024-12-31', 'Y', '2024-12-01 12:00:00');
INSERT INTO public.d_customer VALUES (17, 2, 'Jane', 'Smith', 'B654321', '1990-07-19', '456 Oak St', '2024-01-15', '2024-12-15', 'Y', '2024-12-01 12:00:00');
INSERT INTO public.d_customer VALUES (18, 1, 'Michael', 'Brown', 'C789012', '1982-01-20', '789 Pine St', '2024-02-01', '2024-12-01', 'Y', '2024-12-01 12:00:00');
INSERT INTO public.d_customer VALUES (19, 2, 'Emily', 'Davis', 'D345678', '1995-10-05', '101 Maple St', '2024-03-01', '2024-12-01', 'Y', '2024-12-01 12:00:00');
INSERT INTO public.d_customer VALUES (20, 2, 'Chris', 'Wilson', 'E901234', '1988-11-23', '202 Cedar St', '2024-03-15', '2024-12-15', 'Y', '2024-12-01 12:00:00');
INSERT INTO public.d_customer VALUES (21, 1, 'Sarah', 'Moore', 'F567890', '1993-05-14', '303 Birch St', '2024-04-01', '2024-12-01', 'Y', '2024-12-01 12:00:00');
INSERT INTO public.d_customer VALUES (22, 2, 'Daniel', 'Taylor', 'G112233', '1987-08-25', '404 Spruce St', '2024-04-15', '2024-12-15', 'Y', '2024-12-01 12:00:00');
INSERT INTO public.d_customer VALUES (23, 1, 'Laura', 'Anderson', 'H445566', '1992-02-17', '505 Ash St', '2024-05-01', '2024-12-01', 'Y', '2024-12-01 12:00:00');
INSERT INTO public.d_customer VALUES (24, 2, 'David', 'Thomas', 'I778899', '1984-09-30', '606 Chestnut St', '2024-05-15', '2024-12-15', 'Y', '2024-12-01 12:00:00');
INSERT INTO public.d_customer VALUES (25, 2, 'Anna', 'Jackson', 'J334455', '1996-03-28', '707 Redwood St', '2024-06-01', '2024-12-01', 'Y', '2024-12-01 12:00:00');
INSERT INTO public.d_customer VALUES (26, 1, 'James', 'White', 'K998877', '1991-12-18', '808 Sequoia St', '2024-06-15', '2024-12-15', 'Y', '2024-12-01 12:00:00');
INSERT INTO public.d_customer VALUES (27, 2, 'Olivia', 'Harris', 'L556677', '1986-06-08', '909 Fir St', '2024-07-01', '2024-12-01', 'Y', '2024-12-01 12:00:00');
INSERT INTO public.d_customer VALUES (28, 2, 'Ethan', 'Martin', 'M334455', '1989-04-03', '1010 Elmwood St', '2024-07-15', '2024-12-15', 'Y', '2024-12-01 12:00:00');
INSERT INTO public.d_customer VALUES (29, 2, 'Sophia', 'Thompson', 'N112233', '1994-08-10', '1111 Hawthorn St', '2024-08-01', '2024-12-01', 'Y', '2024-12-01 12:00:00');
INSERT INTO public.d_customer VALUES (30, 1, 'Matthew', 'Garcia', 'O445566', '1983-02-05', '1212 Dogwood St', '2024-08-15', '2024-12-15', 'Y', '2024-12-01 12:00:00');

-- truncate table d_vehicle;

INSERT INTO public.d_vehicle VALUES (31, 'AAA1111', 'Toyota', 'Corolla', 'Gasoline', 1, '2024-01-01', '2024-01-10', '2024-12-01 12:00:00');
INSERT INTO public.d_vehicle VALUES (32, 'BBB2222', 'Ford', 'Focus', 'Diesel', 1, '2024-01-11', '2024-01-20', '2024-12-01 12:00:00');
INSERT INTO public.d_vehicle VALUES (33, 'CCC3333', 'Honda', 'Civic', 'Hybrid', 1, '2024-01-21', '2024-01-30', '2024-12-01 12:00:00');
INSERT INTO public.d_vehicle VALUES (34, 'DDD4444', 'Tesla', 'Model 3', 'Electric', 1, '2024-02-01', '2024-02-10', '2024-12-01 12:00:00');
INSERT INTO public.d_vehicle VALUES (35, 'EEE5555', 'Nissan', 'Altima', 'Gasoline', 1, '2024-02-11', '2024-02-20', '2024-12-01 12:00:00');
INSERT INTO public.d_vehicle VALUES (36, 'FFF6666', 'Chevrolet', 'Malibu', 'Diesel', 2, '2024-02-21', '2024-02-28', '2024-12-01 12:00:00');
INSERT INTO public.d_vehicle VALUES (37, 'GGG7777', 'Hyundai', 'Elantra', 'Gasoline', 2, '2024-03-01', '2024-03-10', '2024-12-01 12:00:00');
INSERT INTO public.d_vehicle VALUES (38, 'HHH8888', 'Kia', 'Soul', 'Hybrid', 2, '2024-03-11', '2024-03-20', '2024-12-01 12:00:00');
INSERT INTO public.d_vehicle VALUES (39, 'III9999', 'Mazda', 'Mazda3', 'Gasoline', 2, '2024-03-21', '2024-03-30', '2024-12-01 12:00:00');
INSERT INTO public.d_vehicle VALUES (40, 'JJJ1010', 'Volkswagen', 'Passat', 'Diesel', 2, '2024-04-01', '2024-04-10', '2024-12-01 12:00:00');
INSERT INTO public.d_vehicle VALUES (41, 'KKK1212', 'Subaru', 'Impreza', 'Gasoline', 1, '2024-04-11', '2024-04-20', '2024-12-01 12:00:00');
INSERT INTO public.d_vehicle VALUES (42, 'LLL1313', 'BMW', '3 Series', 'Hybrid', 1, '2024-04-21', '2024-04-30', '2024-12-01 12:00:00');
INSERT INTO public.d_vehicle VALUES (43, 'MMM1414', 'Mercedes', 'C-Class', 'Gasoline', 1, '2024-05-01', '2024-05-10', '2024-12-01 12:00:00');
INSERT INTO public.d_vehicle VALUES (44, 'NNN1515', 'Audi', 'A4', 'Diesel', 1, '2024-05-11', '2024-05-20', '2024-12-01 12:00:00');
INSERT INTO public.d_vehicle VALUES (45, 'OOO1616', 'Lexus', 'IS', 'Hybrid', 1, '2024-05-21', '2024-05-30', '2024-12-01 12:00:00');

