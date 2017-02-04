
class World {
  private ArrayList<Attractor> _attractors;
  private ArrayList<Vehicle> _vehicles;
  private int _width;
  private int _height;
  private int _neighborhoodSizeSq;

  World(int width, int height) {
    _attractors = new ArrayList<Attractor>();
    _vehicles = new ArrayList<Vehicle>();
    _width = width;
    _height = height;

    _neighborhoodSizeSq = 50 * 50;
  }

  ArrayList<Attractor> attractorsRef() {
    return _attractors;
  }

  World attractorsRef(ArrayList<Attractor> v) {
    _attractors = v;
    return this;
  }

  ArrayList<Vehicle> vehiclesRef() {
    return _vehicles;
  }

  World vehiclesRef(ArrayList<Vehicle> v) {
    _vehicles = v;
    return this;
  }

  World clearAttractors() {
    _attractors = new ArrayList<Attractor>();
    return this;
  }

  World clearVehicles() {
    _vehicles = new ArrayList<Vehicle>();
    return this;
  }

  World setupAttractors(int numAttractors) {
    int numAttempts = 0;
    int maxAttempts = 100000;

    while (_attractors.size() < numAttractors && numAttempts < maxAttempts) {
      Attractor attractor = new Attractor(random(width), random(height), 150);

      if (hasAttractorCollision(attractor)) {
        numAttempts++;
        continue;
      }

      _attractors.add(attractor);
      numAttempts = 0;
    }

    println("Resulting number of attractors: " + _attractors.size());
    return this;
  }

  private boolean hasAttractorCollision(Attractor attractor) {
    for (int i = 0; i < _attractors.size(); i++) {
      Attractor a = _attractors.get(i);
      if (attractor.isColliding(a)) {
        return true;
      }
    }
    return false;
  }

  World setupVehicles(int numVehicles) {
    int numAttempts = 0;
    int maxAttempts = 100000;

    while (_vehicles.size() < numVehicles && numAttempts < maxAttempts) {
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

  private Neighborhood getNeighborhood(ArrayList<Vehicle> vehicles, Vehicle vehicle) {
    ArrayList<Vehicle> neighborhoodVehicles = new ArrayList<Vehicle>();
    for (int i = 0; i < vehicles.size(); i++) {
      Vehicle v = vehicles.get(i);
      if (vehicle != v && areNeighbors(vehicle, v)) {
        neighborhoodVehicles.add(v);
      }
    }
    return new Neighborhood()
      .nearestVehicle((Vehicle)getNearestTo(vehicles, vehicle))
      .vehiclesRef(neighborhoodVehicles);
  }

  private boolean areNeighbors(Vehicle a, Vehicle b) {
    float dx = b.x() - a.x();
    float dy = b.y() - a.y();
    float dSq = dx * dx + dy * dy;
    return dSq < _neighborhoodSizeSq;
  }

  World step() {
    calculateNearestAttractors();
    calculateNeighborhoods();
    stepVehicles();
    prepVehicles();
    return this;
  }

  private void calculateNearestAttractors() {
    for (int i = 0; i < _vehicles.size(); i++) {
      Vehicle vehicle = _vehicles.get(i);
      vehicle.nearestAttractor((Attractor)getNearestTo(_attractors, vehicle));
    }
  }

  private void calculateNeighborhoods() {
    for (int i = 0; i < _vehicles.size(); i++) {
      Vehicle vehicle = _vehicles.get(i);
      Neighborhood neighborhood = getNeighborhood(_vehicles, vehicle);
      vehicle.neighborhoodRef(neighborhood);
    }
  }

  private void prepVehicles() {
    for (int i = 0; i < _vehicles.size(); i++) {
      Vehicle vehicle = _vehicles.get(i);
      vehicle.prep();
    }
  }

  private void stepVehicles() {
    for (int i = 0; i < _vehicles.size(); i++) {
      Vehicle vehicle = _vehicles.get(i);
      vehicle.step();
    }
  }
}
