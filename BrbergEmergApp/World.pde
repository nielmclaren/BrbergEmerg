
class World {
  private ArrayList<Vehicle> _vehicles;
  private int _width;
  private int _height;
  private int _neighborhoodSizeSq;

  World(int width, int height) {
    _vehicles = new ArrayList<Vehicle>();
    _width = width;
    _height = height;

    _neighborhoodSizeSq = 50 * 50;
  }

  ArrayList<Vehicle> vehiclesRef() {
    return _vehicles;
  }

  World vehiclesRef(ArrayList<Vehicle> v) {
    _vehicles = v;
    return this;
  }

  World clearVehicles() {
    _vehicles = new ArrayList<Vehicle>();
    return this;
  }

  World setupVehicles() {
    int maxVehicles = 100000;
    int numAttempts = 0;
    int maxAttempts = 100000;

    while (_vehicles.size() < maxVehicles && numAttempts < maxAttempts) {
      Vehicle vehicle = new Vehicle(random(width), random(height), random(2 * PI));

      if (hasVehicleCollision(vehicle)) {
        numAttempts++;
        continue;
      }

      _vehicles.add(vehicle);
      numAttempts = 0;
    }

    println("Resulting number of vehicles: " + _vehicles.size());
    return this;
  }

  private boolean hasVehicleCollision(Vehicle vehicle) {
    for (int i = 0; i < _vehicles.size(); i++) {
      Vehicle v = _vehicles.get(i);
      if (vehicle.isColliding(v)) {
        return true;
      }
    }
    return false;
  }

  World calculateNeighborhoods() {
    for (int i = 0; i < _vehicles.size(); i++) {
      Vehicle vehicle = _vehicles.get(i);
      Neighborhood neighborhood = getNeighborhood(_vehicles, vehicle);
      vehicle.neighborhoodRef(neighborhood);
    }
    return this;
  }

  private Neighborhood getNeighborhood(ArrayList<Vehicle> vehicles, Vehicle vehicle) {
    ArrayList<Vehicle> neighborhoodVehicles = new ArrayList<Vehicle>();
    for (int i = 0; i < vehicles.size(); i++) {
      Vehicle v = vehicles.get(i);
      if (vehicle != v && areNeighbors(vehicle, v)) {
        neighborhoodVehicles.add(v);
      }
    }
    return new Neighborhood()
      .vehiclesRef(neighborhoodVehicles);
  }

  private boolean areNeighbors(Vehicle a, Vehicle b) {
    float dx = b.x() - a.x();
    float dy = b.y() - a.y();
    float dSq = dx * dx + dy * dy;
    return dSq < _neighborhoodSizeSq;
  }

  World update() {
    for (int i = 0; i < _vehicles.size(); i++) {
      Vehicle vehicle = _vehicles.get(i);
      vehicle.update();
    }
    return this;
  }
}