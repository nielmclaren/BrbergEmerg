
class Vehicle implements IPositioned {
  private float _x;
  private float _y;
  private float _nextX;
  private float _nextY;
  private float _velocity;
  private float _rotation;
  private float _nextRotation;

  private int _groupId;

  private Neighborhood _neighborhood;
  private Attractor _attractor;

  private float _vehicleSizeSq;

  Vehicle(float x, float y, float rotation) {
    _x = x;
    _y = y;
    _nextX = x;
    _nextY = y;
    _rotation = rotation;
    _nextRotation = rotation;
    _velocity = 3;

    _groupId = -1;

    _neighborhood = new Neighborhood();
    _attractor = null;

    _vehicleSizeSq = 20 * 20;
  }

  float x() {
    return _x;
  }

  Vehicle x(float v) {
    _x = v;
    return this;
  }

  float y() {
    return _y;
  }

  Vehicle y(float v) {
    _y = v;
    return this;
  }

  float nextX() {
    return _nextX;
  }

  Vehicle nextX(float v) {
    _nextX = v;
    return this;
  }

  float nextY() {
    return _nextY;
  }

  Vehicle nextY(float v) {
    _nextY = v;
    return this;
  }

  float rotation() {
    return _rotation;
  }

  Vehicle rotation(float v) {
    _rotation = v;
    return this;
  }

  float nextRotation() {
    return _nextRotation;
  }

  Vehicle nextRotation(float v) {
    _nextRotation = v;
    return this;
  }

  float velocity() {
    return _velocity;
  }

  Vehicle velocity(float v) {
    _velocity = v;
    return this;
  }

  int groupId() {
    return _groupId;
  }

  Vehicle groupId(int v) {
    _groupId = v;
    return this;
  }

  Neighborhood neighborhoodRef() {
    return _neighborhood;
  }

  Vehicle neighborhoodRef(Neighborhood v) {
    _neighborhood = v;
    return this;
  }

  Attractor attractor() {
    return _attractor.clone();
  }

  Vehicle attractor(Attractor v) {
    _attractor = v;
    return this;
  }

  Vehicle prep() {
    float attraction = getAttractionRotationDelta();
    float separation = getSeparationRotationDelta();
    float alignment = getAlignmentRotationDelta();
    float cohesion = getCohesionRotationDelta();

    attraction *= 1;
    separation *= 1;
    alignment *= 1;
    cohesion *= 1;

    _nextRotation = normalizeAngle(_rotation + attraction + separation + alignment + cohesion);

    _nextX += _velocity * cos(_nextRotation);
    _nextY += _velocity * sin(_nextRotation);

    updateGroup();

    return this;
  }

  // Steer toward attractors.
  private float getAttractionRotationDelta() {
    if (_attractor != null) {
      float attractorAngle = getAngleTo(this, _attractor);
      return getScaledRotationDeltaToward(_rotation, attractorAngle, 0.1, 0.02);
    }
    return 0;
  }

  // Steer away from vehicles that are too close.
  private float getSeparationRotationDelta() {
    ArrayList<Vehicle> tooCloseVehicles = _neighborhood.getTooCloseVehicles(this);
    if (tooCloseVehicles.size() > 0) {
      PVector averagePos = getAveragePosition(tooCloseVehicles);
      float tooCloseDirection = getAngleTo(this, averagePos);
      return getScaledRotationDeltaToward(_rotation, tooCloseDirection, -0.1, 0.02);
    }
    return 0;
  }

  // Steer toward the average direction that nearby vehicles are going.
  private float getAlignmentRotationDelta() {
    if (_neighborhood.vehiclesRef().size() > 0) {
      float neighborhoodRotation = _neighborhood.getAverageRotation();
      return getScaledRotationDeltaToward(_rotation, neighborhoodRotation, -0.1, 0.02);
    }
    return 0;
  }

  // Steer toward the average position of nearby vehicles.
  private float getCohesionRotationDelta() {
    if (_neighborhood.vehiclesRef().size() > 0) {
      PVector averagePos = getAveragePosition(_neighborhood.vehiclesRef());
      float neighborsDirection = getAngleTo(this, averagePos);
      return getScaledRotationDeltaToward(_rotation, neighborsDirection, 0.1, 0.02);
    }
    return 0;
  }

  private float getScaledRotationDeltaToward(float current, float target, float factor) {
    return getRotationDeltaToward(current, target, factor * _velocity, 0);
  }

  private float getScaledRotationDeltaToward(float current, float target, float factor, float maxDelta) {
    return getRotationDeltaToward(current, target, factor * _velocity, maxDelta * _velocity);
  }

  private void updateGroup() {
    if (random(1) < 0.01) {
      int groupId = getRandomGroup(_neighborhood.getGroupStats());
      if (groupId >= 0) {
        _groupId = groupId;
      } else {
        _groupId = _attractor.id();
      }
    }
  }

  private int getRandomGroup(GroupStats groupStats) {
    ArrayList<Integer> groupIds = groupStats.groupIds();
    if (groupIds.size() <= 0) {
      return -1;
    }

    return groupIds.get(floor(random(groupIds.size())));
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
}
