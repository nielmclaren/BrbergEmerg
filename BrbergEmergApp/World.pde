
class World {
  public static final int NEIGHBORHOOD_RADIUS = 40;
  public static final int MIN_DISTANCE = 10;

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

  int width() {
    return _width;
  }

  World width(int v) {
    _width = v;
    return this;
  }

  int height() {
    return _height;
  }

  World height(int v) {
    _height = v;
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

  World setupAttractors(IPositioner positioner, int numAttractors) {
    for (int i = 0; i < numAttractors; i++) {
      Attractor attractor = new Attractor(i, 0, 0, 50);
      if (positioner.position(attractor)) {
        _attractors.add(attractor);
      } else {
        break;
      }
    }
    println("Resulting number of attractors: " + _attractors.size());
    return this;
  }

  World setupVehicles(int numVehicles, int numGroups) {
    for (int i = 0; i < numVehicles; i++) {
      Vehicle vehicle = new Vehicle(
          random(_width),
          random(_height),
          random(PI))
        .groupId(floor(random(numGroups)));

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
      .vehiclesRef(neighborhoodVehicles);
  }

  private boolean areNeighbors(Vehicle a, Vehicle b) {
    return getDistanceBetween(a, b) < NEIGHBORHOOD_RADIUS;
  }

  World step() {
    calculateNeighborhoods();
    prepVehicles();
    stepVehicles();
    return this;
  }

  void calculateNearestAttractors() {
    for (Vehicle vehicle : _vehicles) {
      Attractor attractor = (Attractor)getNearestTo(_attractors, vehicle);
      vehicle.attractor(attractor);
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
