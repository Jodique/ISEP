-- Customers Table
CREATE TABLE Customers (
    CustomerID INT PRIMARY KEY,
    FirstName VARCHAR(50),
    LastName VARCHAR(50),
    Email VARCHAR(100) UNIQUE,
    Phone VARCHAR(20),
    Address VARCHAR(200),
    DateOfBirth DATE,
    DriversLicenseNumber VARCHAR(50) UNIQUE,
    RegistrationDate DATETIME
);

-- Vehicle Categories Table
CREATE TABLE VehicleCategories (
    CategoryID INT PRIMARY KEY,
    CategoryName VARCHAR(50),
    DailyRate DECIMAL(10,2),
    WeeklyRate DECIMAL(10,2),
    MonthlyRate DECIMAL(10,2)
);

-- Vehicles Table
CREATE TABLE Vehicles (
    VehicleID INT PRIMARY KEY,
    CategoryID INT,
    Make VARCHAR(50),
    Model VARCHAR(50),
    Year INT,
    LicensePlate VARCHAR(20) UNIQUE,
    VIN VARCHAR(50) UNIQUE,
    Color VARCHAR(30),
    Mileage INT,
    Status ENUM('Available', 'Rented', 'Maintenance', 'Unavailable'),
    LastServiceDate DATE,
    FOREIGN KEY (CategoryID) REFERENCES VehicleCategories(CategoryID)
);

-- Rental Agreements Table
CREATE TABLE RentalAgreements (
    RentalID INT PRIMARY KEY,
    CustomerID INT,
    VehicleID INT,
    RentalStartDate DATETIME,
    ExpectedReturnDate DATETIME,
    ActualReturnDate DATETIME,
    PickupLocation VARCHAR(100),
    ReturnLocation VARCHAR(100),
    RentalStatus ENUM('Active', 'Completed', 'Cancelled'),
    TotalCost DECIMAL(10,2),
    AdditionalServices TEXT,
    FOREIGN KEY (CustomerID) REFERENCES Customers(CustomerID),
    FOREIGN KEY (VehicleID) REFERENCES Vehicles(VehicleID)
);

-- Payments Table
CREATE TABLE Payments (
    PaymentID INT PRIMARY KEY,
    RentalID INT,
    PaymentDate DATETIME,
    PaymentAmount DECIMAL(10,2),
    PaymentMethod ENUM('Credit Card', 'Debit Card', 'Cash', 'Bank Transfer'),
    PaymentStatus ENUM('Completed', 'Pending', 'Failed'),
    FOREIGN KEY (RentalID) REFERENCES RentalAgreements(RentalID)
);

-- Maintenance Log Table
CREATE TABLE MaintenanceLogs (
    MaintenanceID INT PRIMARY KEY,
    VehicleID INT,
    MaintenanceDate DATE,
    MaintenanceType VARCHAR(100),
    Description TEXT,
    Cost DECIMAL(10,2),
    ServicedBy VARCHAR(100),
    NextServiceDate DATE,
    FOREIGN KEY (VehicleID) REFERENCES Vehicles(VehicleID)
);

-- Insurance Policies Table
CREATE TABLE InsurancePolicies (
    PolicyID INT PRIMARY KEY,
    PolicyName VARCHAR(100),
    CoverageType VARCHAR(100),
    DailyRate DECIMAL(10,2),
    Description TEXT
);

-- Rental Insurance Table
CREATE TABLE RentalInsurances (
    RentalInsuranceID INT PRIMARY KEY,
    RentalID INT,
    PolicyID INT,
    InsuranceCost DECIMAL(10,2),
    FOREIGN KEY (RentalID) REFERENCES RentalAgreements(RentalID),
    FOREIGN KEY (PolicyID) REFERENCES InsurancePolicies(PolicyID)
);
