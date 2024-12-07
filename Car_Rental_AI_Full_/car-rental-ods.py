import datetime
from typing import List, Optional
from enum import Enum, auto
from dataclasses import dataclass, field

class VehicleType(Enum):
    COMPACT = auto()
    SEDAN = auto()
    SUV = auto()
    LUXURY = auto()
    TRUCK = auto()

class VehicleStatus(Enum):
    AVAILABLE = auto()
    RENTED = auto()
    MAINTENANCE = auto()
    UNDER_REPAIR = auto()

class ReservationStatus(Enum):
    CONFIRMED = auto()
    CANCELLED = auto()
    COMPLETED = auto()

@dataclass
class Vehicle:
    """Represents a vehicle in the rental fleet."""
    vehicle_id: str
    license_plate: str
    make: str
    model: str
    year: int
    mileage: float
    vehicle_type: VehicleType
    daily_rate: float
    status: VehicleStatus = VehicleStatus.AVAILABLE
    maintenance_history: List[dict] = field(default_factory=list)

    def update_mileage(self, new_mileage: float):
        """Update vehicle mileage after a rental."""
        self.mileage = new_mileage

    def add_maintenance_record(self, maintenance_details: dict):
        """Add a maintenance record for the vehicle."""
        self.maintenance_history.append(maintenance_details)
        if maintenance_details.get('major_repair', False):
            self.status = VehicleStatus.UNDER_REPAIR

@dataclass
class Customer:
    """Represents a customer in the rental system."""
    customer_id: str
    name: str
    email: str
    phone: str
    driver_license: str
    rental_history: List['Reservation'] = field(default_factory=list)

    def add_rental_to_history(self, reservation: 'Reservation'):
        """Add a completed reservation to customer's rental history."""
        self.rental_history.append(reservation)

@dataclass
class Reservation:
    """Represents a vehicle rental reservation."""
    reservation_id: str
    customer: Customer
    vehicle: Vehicle
    start_date: datetime.date
    end_date: datetime.date
    total_cost: float
    status: ReservationStatus = ReservationStatus.CONFIRMED
    additional_drivers: List[str] = field(default_factory=list)
    insurance_type: Optional[str] = None

    def calculate_total_cost(self) -> float:
        """Calculate the total rental cost based on rental duration and vehicle rate."""
        rental_days = (self.end_date - self.start_date).days + 1
        return rental_days * self.vehicle.daily_rate

    def update_status(self, new_status: ReservationStatus):
        """Update the status of the reservation."""
        self.status = new_status

class RentalAgency:
    """Main class managing the car rental operations."""
    def __init__(self, name: str):
        self.name = name
        self.vehicles: List[Vehicle] = []
        self.customers: List[Customer] = []
        self.active_reservations: List[Reservation] = []

    def add_vehicle(self, vehicle: Vehicle):
        """Add a new vehicle to the fleet."""
        self.vehicles.append(vehicle)

    def remove_vehicle(self, vehicle: Vehicle):
        """Remove a vehicle from the fleet."""
        self.vehicles.remove(vehicle)

    def register_customer(self, customer: Customer):
        """Register a new customer in the system."""
        self.customers.append(customer)

    def find_available_vehicles(self, vehicle_type: VehicleType, start_date: datetime.date, end_date: datetime.date) -> List[Vehicle]:
        """Find available vehicles of a specific type for given dates."""
        return [
            vehicle for vehicle in self.vehicles 
            if vehicle.vehicle_type == vehicle_type and 
               vehicle.status == VehicleStatus.AVAILABLE and
               not self._is_vehicle_reserved(vehicle, start_date, end_date)
        ]

    def _is_vehicle_reserved(self, vehicle: Vehicle, start_date: datetime.date, end_date: datetime.date) -> bool:
        """Check if a vehicle is already reserved for the given period."""
        for reservation in self.active_reservations:
            if (reservation.vehicle == vehicle and 
                reservation.status == ReservationStatus.CONFIRMED and
                not (end_date < reservation.start_date or start_date > reservation.end_date)):
                return True
        return False

    def create_reservation(self, customer: Customer, vehicle: Vehicle, start_date: datetime.date, end_date: datetime.date) -> Reservation:
        """Create a new reservation."""
        if vehicle.status != VehicleStatus.AVAILABLE:
            raise ValueError("Vehicle is not available for reservation")

        reservation = Reservation(
            reservation_id=f"RES-{len(self.active_reservations) + 1}",
            customer=customer,
            vehicle=vehicle,
            start_date=start_date,
            end_date=end_date,
            total_cost=0  # Will be calculated later
        )
        
        reservation.total_cost = reservation.calculate_total_cost()
        vehicle.status = VehicleStatus.RENTED
        self.active_reservations.append(reservation)
        customer.add_rental_to_history(reservation)

        return reservation

    def complete_reservation(self, reservation: Reservation, final_mileage: float):
        """Complete a reservation and update vehicle status."""
        reservation.update_status(ReservationStatus.COMPLETED)
        reservation.vehicle.update_mileage(final_mileage)
        reservation.vehicle.status = VehicleStatus.AVAILABLE
        self.active_reservations.remove(reservation)

# Example Usage
def main():
    # Create a rental agency
    hertz = RentalAgency("Hertz Rental")

    # Add some vehicles
    camry = Vehicle(
        vehicle_id="V001", 
        license_plate="ABC123", 
        make="Toyota", 
        model="Camry", 
        year=2022, 
        mileage=15000, 
        vehicle_type=VehicleType.SEDAN, 
        daily_rate=50.0
    )
    hertz.add_vehicle(camry)

    # Register a customer
    john = Customer(
        customer_id="C001", 
        name="John Doe", 
        email="john@example.com", 
        phone="555-1234", 
        driver_license="DL12345"
    )
    hertz.register_customer(john)

    # Create a reservation
    start_date = datetime.date(2024, 7, 1)
    end_date = datetime.date(2024, 7, 5)
    reservation = hertz.create_reservation(john, camry, start_date, end_date)

    # Complete the reservation
    hertz.complete_reservation(reservation, 15500)

if __name__ == "__main__":
    main()
