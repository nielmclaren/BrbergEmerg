
class Vehicle implements IPositioned {
  private float _x;
  private float _y;
  private float _nextX;
  private float _nextY;
  private float _velocity;
  private float _rotation;
  private float _nextRotation;
  private Neighborhood _neighborhood;
  private Attractor _nearestAttractor;

  private float _vehicleSizeSq;

  Vehicle(float x, float y, float rotation) {
    _x = x;
    _y = y;
    _nextX = x;
    _nextY = y;
    _rotation = rotation;
    _nextRotation = rotation;
    _velocity = 3;
    _neighborhood = new Neighborhood();
    _nearestAttractor = null;

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

  Neighborhood neighborhoodRef() {
    return _neighborhood;
  }

  Vehicle neighborhoodRef(Neighborhood v) {
    _neighborhood = v;
    return this;
  }

  Attractor nearestAttractor() {
    return _nearestAttractor.clone();
  }

  Vehicle nearestAttractor(Attractor v) {
    _nearestAttractor = v;
    return this;
  }

  Vehicle prep() {
    float averageAngleFrom = _neighborhood.getAverageAngleFrom(this);

    if (_nearestAttractor != null) {
      float attractorDirection = getAngleTo(this, _nearestAttractor);
      _rotation = getRotationToward(_rotation, attractorDirection, -0.02);
    }

    float neighborhoodRotation = _neighborhood.getAverageRotation();
    _nextRotation = getRotationToward(_rotation, neighborhoodRotation, 0.1);

    _nextX += _velocity * cos(_nextRotation);
    _nextY += _velocity * sin(_nextRotation);

    return this;
  }

  private float getRotationToward(float current, float target, float factor) {
    float delta = target - current;
    float result;

    if (abs(delta) > PI) {
      if (delta > 0) {
        delta = -2 * PI + delta;
      } else {
        delta = 2 * PI + delta;
      }
    }
    result = current + delta * factor;

    return normalizeAngle(result);
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
