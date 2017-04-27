
class World {
  public static final int NEIGHBORHOOD_RADIUS = 160;
  public static final int MIN_DISTANCE = 40;
  public static final int OUT_GROUP_MIN_DISTANCE = 80;

  private ArrayList<Vehicle> _vehicles;
  private HashMap<Integer, Touch> _cursorIdToTouch;
  private int _width;
  private int _height;
  private PVector _center;
  private int _numGroups;
  private long _age;

  public AlignmentImpulse alignment;
  public BoundaryImpulse boundary;
  public CohesionImpulse cohesion;
  public MeanderImpulse meander;
  public RepulsionImpulse repulsion;
  public SeparationImpulse separation;
  public TouchImpulse lure;

  World(int width, int height, int numGroups) {
    _vehicles = new ArrayList<Vehicle>();
    _cursorIdToTouch = new HashMap<Integer, Touch>();
    _width = width;
    _height = height;
    _center = new PVector(_width/2, _height/2);
    _numGroups = numGroups;
    _age = 0;

    alignment = new AlignmentImpulse(this);
    boundary = new BoundaryImpulse(this);
    cohesion = new CohesionImpulse(this);
    meander = new MeanderImpulse(this);
    repulsion = new RepulsionImpulse(this);
    separation = new SeparationImpulse(this);
    lure = new TouchImpulse(this);
  }

  ArrayList<Vehicle> vehiclesRef() {
    return _vehicles;
  }

  ArrayList<Touch> touches() {
    return new ArrayList<Touch>(_cursorIdToTouch.values());
  }

  World addTouch(TuioCursor cursor) {
    float x = cursor.getX() * width;
    float y = cursor.getY() * height;
    Vehicle vehicle = getNearestFreeVehicle(x, y);
    float dist = getDistanceBetween(vehicle, x, y);
    Touch touch;
    if (dist < 200) {
      touch = new Touch(cursor, vehicle);
      vehicle.touch(touch);
    } else {
      touch = new Touch(cursor, null);
    }
    _cursorIdToTouch.put(cursor.getCursorID(), touch);
    return this;
  }

  private Vehicle getNearestFreeVehicle(float x, float y) {
    ArrayList<Vehicle> vehicles = (ArrayList<Vehicle>)_vehicles.clone();
    Vehicle vehicle = null;
    while (vehicles.size() > 0) {
      vehicle = (Vehicle)getNearestTo(vehicles, x, y);
      if (vehicle.touchRef() == null) {
        return vehicle;
      }
      vehicles.remove(vehicle);
    }
    return null;
  }

  World updateTouch(TuioCursor cursor) {
    //Touch touch = _cursorIdToTouch.get(cursor.getCursorID());
    return this;
  }

  World removeTouch(TuioCursor cursor) {
    Touch touch = _cursorIdToTouch.get(cursor.getCursorID());
    if (touch.vehicleRef() != null) {
      touch.vehicleRef().touch(null);
    }
    _cursorIdToTouch.remove(cursor.getCursorID());
    return this;
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
    _center = new PVector(_width/2, _height/2);
    return this;
  }

  int height() {
    return _height;
  }

  World height(int v) {
    _height = v;
    _center = new PVector(_width/2, _height/2);
    return this;
  }

  PVector centerRef() {
    return _center;
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

  World clearVehicles() {
    _vehicles = new ArrayList<Vehicle>();
    return this;
  }

  World setupVehicles(IPositioner positioner, int numVehicles) {
    for (int i = 0; i < numVehicles; i++) {
      int groupId = floor(random(_numGroups));
      Vehicle vehicle = new Vehicle(this, i, 0, 0, random(PI))
        .groupId(groupId);

      if (positioner.position(vehicle, i)) {
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
