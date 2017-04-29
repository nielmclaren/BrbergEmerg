
class Vehicle implements IPositionable {
  private World _world;
  private int _id;
  private PVector _position;
  private PVector _velocity;
  private PVector _acceleration;

  private int _groupId;

  private boolean _isTurningCw;
  private boolean _isTurningCcw;
  private int _numStepsSinceLastTurn;

  private Neighborhood _neighborhood;
  private Touch _touch;
  private float _maxSpeed;

  Vehicle(World world, int id) {
    _world = world;
    _id = id;
    _position = new PVector();
    _velocity = new PVector();
    _acceleration = new PVector();

    _groupId = -1;

    _isTurningCw = false;
    _isTurningCcw = false;
    _numStepsSinceLastTurn = 0;

    _neighborhood = new Neighborhood();
    _touch = null;
    _maxSpeed = 3;
  }

  Vehicle(World world, JSONObject vehicleJson) {
    _world = world;
    _position = new PVector();
    _velocity = new PVector();
    _acceleration = new PVector();

    updateFromJson(vehicleJson);

    _neighborhood = new Neighborhood();
    _touch = null;
    _maxSpeed = 3;
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
    return _position.x;
  }

  Vehicle x(float v) {
    _position.x = v;
    return this;
  }

  float y() {
    return _position.y;
  }

  Vehicle y(float v) {
    _position.y = v;
    return this;
  }

  PVector position() {
    return _position;
  }

  PVector velocity() {
    return _velocity;
  }

  PVector acceleration() {
    return _acceleration;
  }

  Vehicle accelerate(PVector force) {
    _acceleration.add(force);
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

  Vehicle step() {
    if (_touch == null) {
      _world.alignment.step(this);
      _world.boundary.step(this);
      _world.cohesion.step(this);
      _world.meander.step(this);
      _world.repulsion.step(this);
      _world.separation.step(this);
    } else {
      _world.lure.step(this);
    }

    _velocity.add(_acceleration);
    _velocity.limit(World.MAX_SPEED);
    _position.add(_velocity);
    _acceleration.mult(0);

    return this;
  }

  private Vehicle updateFromJson(JSONObject json) {
    _id = json.getInt("id");
    _position.x = json.getFloat("x");
    _position.y = json.getFloat("y");
    _velocity.x = json.getFloat("vx");
    _velocity.y = json.getFloat("vy");
    _acceleration.x = json.getFloat("ax");
    _acceleration.y = json.getFloat("ay");

    _groupId = json.getInt("groupId");

    _isTurningCw = json.getBoolean("isTurningCw");
    _isTurningCcw = json.getBoolean("isTurningCcw");
    _numStepsSinceLastTurn = json.getInt("numStepsSinceLastTurn");
    return this;
  }

  JSONObject toJson() {
    JSONObject result = new JSONObject();
    result.setInt("id", _id);
    result.setFloat("x", _position.x);
    result.setFloat("y", _position.y);
    result.setFloat("vx", _velocity.x);
    result.setFloat("vy", _velocity.y);
    result.setFloat("ax", _acceleration.x);
    result.setFloat("ay", _acceleration.y);

    result.setInt("groupId", _groupId);

    result.setBoolean("isTurningCw", _isTurningCw);
    result.setBoolean("isTurningCcw", _isTurningCcw);
    result.setInt("numStepsSinceLastTurn", _numStepsSinceLastTurn);

    return result;
  }
}
