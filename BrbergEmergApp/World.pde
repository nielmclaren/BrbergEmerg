
class World {
  public static final int NEIGHBORHOOD_RADIUS = 150;
  public static final int MIN_DISTANCE = 10;
  public static final int OUT_GROUP_MIN_DISTANCE = 40;

  private ArrayList<Vehicle> _vehicles;
  private HashMap<Integer, Touch> _cursorIdToTouch;
  private int _width;
  private int _height;
  private PVector _center;
  private int _numGroups;
  private long _age;

  private Partition _partition;

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

    _partition = new Partition(_width, _height, NEIGHBORHOOD_RADIUS);

    initImpulses();
  }

  World(JSONObject worldJson) {
    updateFromJson(worldJson);
    initImpulses();
  }

  private void initImpulses() {
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

  World vehiclesRef(ArrayList<Vehicle> v) {
    _vehicles = v;
    return this;
  }

  int numVehicles() {
    return _vehicles.size();
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

  World step(int numSteps) {
    for (int i = 0; i < numSteps; i++) {
      step();
    }
    return this;
  }

  World step() {
    updatePartition();
    calculateNeighborhoods();
    prepVehicles();
    stepVehicles();

    _age++;

    return this;
  }

  private void updatePartition() {
    _partition.update(_vehicles);
  }

  private void calculateNeighborhoods() {
    for (Vehicle v : _vehicles) {
      v.neighborhoodRef()
        .inGroupNeighborsRef(_partition.getInGroupVehiclesWithin(v.x(), v.y(), NEIGHBORHOOD_RADIUS, v.groupId(), v))
        .inGroupTooCloseRef(_partition.getInGroupVehiclesWithin(v.x(), v.y(), MIN_DISTANCE, v.groupId(), v))
        .outGroupTooCloseRef(_partition.getOutGroupVehiclesWithin(v.x(), v.y(), OUT_GROUP_MIN_DISTANCE, v.groupId(), v));
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

  private World updateFromJson(JSONObject json) {
    _vehicles = new ArrayList<Vehicle>();

    JSONArray vehiclesJson = json.getJSONArray("vehicles");
    for (int i = 0; i < vehiclesJson.size(); i++) {
      _vehicles.add(new Vehicle(this, vehiclesJson.getJSONObject(i)));
    }

    _cursorIdToTouch = new HashMap<Integer, Touch>();

    _width = json.getInt("width");
    _height = json.getInt("height");
    _center = new PVector(_width/2, _height/2);
    _numGroups = json.getInt("numGroups");
    _age = json.getLong("age");

    _partition = new Partition(_width, _height, NEIGHBORHOOD_RADIUS);

    return this;
  }

  JSONObject toJson() {
    JSONArray vehiclesJson = new JSONArray();
    ArrayList<Vehicle> vehicles = world.vehiclesRef();
    for (int i = 0; i < vehicles.size(); i++) {
      Vehicle v = vehicles.get(i);
      vehiclesJson.setJSONObject(i, v.toJson());
    }

    JSONObject result = new JSONObject();
    result.setJSONArray("vehicles", vehiclesJson);
    result.setInt("width", _width);
    result.setInt("height", _height);
    result.setInt("numGroups", _numGroups);
    result.setLong("age", _age);
    return result;
  }
}
