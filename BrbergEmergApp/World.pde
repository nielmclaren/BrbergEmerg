
class World {
  public static final int NEIGHBORHOOD_RADIUS = 200;

  private ArrayList<Attractor> _attractors;
  private ArrayList<Vehicle> _vehicles;
  private int _width;
  private int _height;

  World(int width, int height) {
    _attractors = new ArrayList<Attractor>();
    _vehicles = new ArrayList<Vehicle>();
    _width = width;
    _height = height;
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
    for (Attractor a : _attractors) {
      if (attractor.isColliding(a)) {
        return true;
      }
    }
    return false;
  }

  World setupVehicles(int numVehicles) {
    for (int i = 0; i < numVehicles; i++) {
      Vehicle vehicle = new Vehicle(
          random(width),
          random(height),
          random(2 * PI));

      _vehicles.add(vehicle);
    }

    return this;
  }

  private boolean hasVehicleCollision(Vehicle vehicle) {
    for (Vehicle v : _vehicles) {
      if (vehicle.isColliding(v)) {
        return true;
      }
    }
    return false;
  }

  private Neighborhood getNeighborhood(ArrayList<Vehicle> vehicles, Vehicle vehicle) {
    ArrayList<Vehicle> neighborhoodVehicles = new ArrayList<Vehicle>();
    for (Vehicle v : _vehicles) {
      if (vehicle != v && areNeighbors(vehicle, v)) {
        neighborhoodVehicles.add(v);
      }
    }
    return new Neighborhood()
      .nearestVehicle((Vehicle)getNearestTo(vehicles, vehicle))
      .vehiclesRef(neighborhoodVehicles);
  }

  private boolean areNeighbors(Vehicle a, Vehicle b) {
    return getDistanceBetween(a, b) < NEIGHBORHOOD_RADIUS;
  }

  World step() {
    calculateNearestAttractors();
    calculateNeighborhoods();
    stepVehicles();
    prepVehicles();
    return this;
  }

  private void calculateNearestAttractors() {
    for (Vehicle vehicle : _vehicles) {
      vehicle.nearestAttractor((Attractor)getNearestTo(_attractors, vehicle));
    }
  }

  private void calculateNeighborhoods() {
    for (Vehicle vehicle : _vehicles) {
      Neighborhood neighborhood = getNeighborhood(_vehicles, vehicle);
      vehicle.neighborhoodRef(neighborhood);
    }
  }

  private void prepVehicles() {
    for (Vehicle vehicle : _vehicles) {
      vehicle.prep();
    }
  }

  private void stepVehicles() {
    for (Vehicle vehicle : _vehicles) {
      vehicle.step();
    }
  }
}
