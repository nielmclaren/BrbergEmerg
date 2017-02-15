
class World {
  public static final int NEIGHBORHOOD_RADIUS = 80;
  public static final int MIN_DISTANCE = 8;
  public static final int OUT_GROUP_MIN_DISTANCE = 40;

  private ArrayList<Attractor> _attractors;
  private ArrayList<Vehicle> _vehicles;
  private int _width;
  private int _height;
  private int _numGroups;
  private long _age;

  public AttractorImpulse attraction;
  public AlignmentImpulse alignment;
  public CohesionImpulse cohesion;
  public MeanderImpulse meander;
  public SeparationImpulse separation;
  public RepulsionImpulse repulsion;

  World(int width, int height, int numGroups) {
    _attractors = new ArrayList<Attractor>();
    _vehicles = new ArrayList<Vehicle>();
    _width = width;
    _height = height;
    _numGroups = numGroups;
    _age = 0;

    attraction = new AttractorImpulse(this);
    separation = new SeparationImpulse(this);
    alignment = new AlignmentImpulse(this);
    cohesion = new CohesionImpulse(this);
    meander = new MeanderImpulse(this);
    repulsion = new RepulsionImpulse(this);
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

  int numGroups() {
    return _numGroups;
  }

  long age() {
    return _age;
  }

  World age(long v) {
    _age = v;
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
    return this;
  }

  World setupVehicles(IPositioner positioner, int numVehicles) {
    for (int i = 0; i < numVehicles; i++) {
      Vehicle vehicle = new Vehicle(this, 0, 0, random(PI))
        .groupId(floor(random(_numGroups)));

      if (positioner.position(vehicle)) {
        _vehicles.add(vehicle);
      }
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
    return new Neighborhood(this)
      .vehiclesRef(neighborhoodVehicles);
  }

  private boolean areNeighbors(Vehicle a, Vehicle b) {
    return getDistanceBetween(a, b) < NEIGHBORHOOD_RADIUS;
  }

  World step(int numSteps) {
    for (int i = 0; i < numSteps; i++) {
      step();
    }
    return this;
  }

  World step() {
    calculateNeighborhoods();
    prepVehicles();
    stepVehicles();

    _age++;

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
