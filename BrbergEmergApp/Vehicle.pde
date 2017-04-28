
class Vehicle implements IPositionable {
  // nextX, nextY, nextRotation are not exposed externally.
  private World _world;
  private int _id;
  private float _x;
  private float _y;
  private float _nextX;
  private float _nextY;
  private float _velocity;
  private float _rotation;
  private float _nextRotation;

  private int _groupId;

  private boolean _isTurningCw;
  private boolean _isTurningCcw;
  private int _numStepsSinceLastTurn;

  private Neighborhood _neighborhood;
  private Touch _touch;
  private float _vehicleSizeSq;

  Vehicle(World world, int id, float x, float y, float rotation) {
    _world = world;
    _id = id;
    _x = x;
    _y = y;
    _nextX = x;
    _nextY = y;
    _velocity = 1;
    _rotation = rotation;
    _nextRotation = rotation;

    _groupId = -1;

    _isTurningCw = false;
    _isTurningCcw = false;
    _numStepsSinceLastTurn = 0;

    _neighborhood = new Neighborhood();
    _touch = null;
    _vehicleSizeSq = 20 * 20;
  }

  Vehicle(World world, JSONObject vehicleJson) {
    _world = world;

    updateFromJson(vehicleJson);

    _neighborhood = new Neighborhood();
    _touch = null;
    _vehicleSizeSq = 20 * 20;
  }

  World world() {
    return _world;
  }

  Vehicle world(World v) {
    _world = v;
    return this;
  }

  int id() {
    return _id;
  }

  Vehicle id(int v) {
    _id = v;
    return this;
  }

  float x() {
    return _x;
  }

  Vehicle x(float v) {
    _x = v;
    _nextX = v;
    return this;
  }

  float y() {
    return _y;
  }

  Vehicle y(float v) {
    _y = v;
    _nextY = v;
    return this;
  }

  float velocity() {
    return _velocity;
  }

  Vehicle velocity(float v) {
    _velocity = v;
    return this;
  }

  float rotation() {
    return _rotation;
  }

  Vehicle rotation(float v) {
    v = normalizeAngle(v);
    _rotation = v;
    _nextRotation = v;
    return this;
  }

  Vehicle rotate(float v) {
    _rotation = normalizeAngle(_rotation + v);
    return this;
  }

  float nextRotation() {
    return _nextRotation;
  }

  Vehicle nextRotation(float v) {
    v = normalizeAngle(v);
    _nextRotation = v;
    return this;
  }

  Vehicle nextRotate(float v) {
    _nextRotation = normalizeAngle(_nextRotation + v);
    return this;
  }

  int groupId() {
    return _groupId;
  }

  Vehicle groupId(int v) {
    _groupId = v;
    return this;
  }

  boolean isTurningCw() {
    return _isTurningCw;
  }

  Vehicle isTurningCw(boolean v) {
    _isTurningCw = v;
    return this;
  }

  boolean isTurningCcw() {
    return _isTurningCcw;
  }

  Vehicle isTurningCcw(boolean v) {
    _isTurningCcw = v;
    return this;
  }

  int numStepsSinceLastTurn() {
    return _numStepsSinceLastTurn;
  }

  Vehicle incrementNumStepsSinceLastTurn() {
    _numStepsSinceLastTurn++;
    return this;
  }

  Vehicle resetNumStepsSinceLastTurn() {
    _numStepsSinceLastTurn = 0;
    return this;
  }

  Neighborhood neighborhoodRef() {
    return _neighborhood;
  }

  Vehicle neighborhoodRef(Neighborhood v) {
    _neighborhood = v;
    return this;
  }

  Touch touchRef() {
    return _touch;
  }

  Vehicle touch(Touch v) {
    _touch = v;
    return this;
  }

  Vehicle prep() {
    if (_touch == null) {
      _world.alignment.step(this);
      _world.boundary.step(this);
      _world.cohesion.step(this);
      //_world.meander.step(this);
      _world.repulsion.step(this);
      _world.separation.step(this);
    } else {
      _world.lure.step(this);
    }

    _nextX += _velocity * cos(_nextRotation);
    _nextY += _velocity * sin(_nextRotation);

    return this;
  }

  Vehicle step() {
    _x = _nextX;
    _y = _nextY;
    _rotation = _nextRotation;
    return this;
  }

  boolean isColliding(Vehicle v) {
    float dx = _x - v.x();
    float dy = _y - v.y();
    return dx * dx + dy * dy < _vehicleSizeSq;
  }

  boolean isColliding(int x, int y) {
    float dx = _x - x;
    float dy = _y - y;
    return dx * dx + dy * dy < _vehicleSizeSq / 4;
  }

  private Vehicle updateFromJson(JSONObject json) {
    _id = json.getInt("id");
    _x = json.getFloat("x");
    _y = json.getFloat("y");
    _nextX = json.getFloat("nextX");
    _nextY = json.getFloat("nextY");
    _velocity = json.getFloat("velocity");
    _rotation = json.getFloat("rotation");
    _nextRotation = json.getFloat("nextRotation");

    _groupId = json.getInt("groupId");

    _isTurningCw = json.getBoolean("isTurningCw");
    _isTurningCcw = json.getBoolean("isTurningCcw");
    _numStepsSinceLastTurn = json.getInt("numStepsSinceLastTurn");
    return this;
  }

  JSONObject toJson() {
    JSONObject result = new JSONObject();
    result.setInt("id", _id);
    result.setFloat("x", _x);
    result.setFloat("y", _y);
    result.setFloat("nextX", _nextX);
    result.setFloat("nextY", _nextY);
    result.setFloat("velocity", _velocity);
    result.setFloat("rotation", _rotation);
    result.setFloat("nextRotation", _nextRotation);

    result.setInt("groupId", _groupId);

    result.setBoolean("isTurningCw", _isTurningCw);
    result.setBoolean("isTurningCcw", _isTurningCcw);
    result.setInt("numStepsSinceLastTurn", _numStepsSinceLastTurn);

    return result;
  }
}
