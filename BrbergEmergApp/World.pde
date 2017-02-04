
class World {
  public static final int NEIGHBORHOOD_RADIUS = 40;
  public static final int MIN_DISTANCE = 10;
  public static final int ATTRACTOR_VISIT_THRESHOLD = 10;

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
    int size = 50;
    _attractors.add(new Attractor(321, 234, size));
    _attractors.add(new Attractor(455, 341, size));
    _attractors.add(new Attractor(125, 502, size));
    _attractors.add(new Attractor(380, 543, size));
    _attractors.add(new Attractor(436, 725, size));
    _attractors.add(new Attractor(724, 609, size));
    _attractors.add(new Attractor(673, 486, size));

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
          random(PI));

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
    calculateNeighborhoods();
    prepVehicles();
    stepVehicles();
    updateAttractorVisits();
    return this;
  }

  void calculateNearestAttractors() {
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

  private void updateAttractorVisits() {
    for (Attractor attractor : _attractors) {
      int numVisits = 0;
      for (Vehicle vehicle : _vehicles) {
        if (getDistanceBetween(attractor, vehicle) < attractor.radius()) {
          numVisits++;
        }
      }

      if (numVisits > ATTRACTOR_VISIT_THRESHOLD) {
        attractor.age(0);
        attractor.badgeCount(0);
      } else {
        if (attractor.age() > 100) {
          if (random(1) < 0.004) {
            attractor.badgeCount(attractor.badgeCount() + 1);
          }
        } else if (attractor.age() == 100) {
          attractor.badgeCount(attractor.badgeCount() + 1);
        }
        attractor.step();
      }
    }
  }
}
