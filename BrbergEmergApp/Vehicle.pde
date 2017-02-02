
class Vehicle {
  private float _prevX;
  private float _prevY;
  private float _x;
  private float _y;
  private float _velocity;
  private float _prevRotation;
  private float _rotation;
  private Neighborhood _neighborhood;

  private float _vehicleSizeSq;

  Vehicle(float x, float y, float rotation) {
    _prevX = x;
    _prevY = y;
    _x = x;
    _y = y;
    _prevRotation = rotation;
    _rotation = rotation;
    _velocity = 3;
    _neighborhood = new Neighborhood();

    _vehicleSizeSq = 20 * 20;
  }

  float prevX() {
    return _prevX;
  }

  Vehicle prevX(float v) {
    _prevX = v;
    return this;
  }

  float prevY() {
    return _prevY;
  }

  Vehicle prevY(float v) {
    _prevY = v;
    return this;
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

  float prevRotation() {
    return _prevRotation;
  }

  Vehicle prevRotation(float v) {
    _prevRotation = v;
    return this;
  }

  float rotation() {
    return _rotation;
  }

  Vehicle rotation(float v) {
    _rotation = v;
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

  Vehicle step() {
    float neighborhoodRotation = _neighborhood.getAveragePrevRotation();
    _rotation = getRotationToward(_rotation, neighborhoodRotation, 0.1);

    _x += _velocity * cos(_rotation);
    _y += _velocity * sin(_rotation);
    return this;
  }

  private float getRotationToward(float current, float target, float factor) {
    float originalDelta = target - current;
    float result;

    float delta = originalDelta;
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

  private float normalizeAngle(float v) {
    while (v < 0) {
      v += 2 * PI;
    }
    return v % (2 * PI);
  }

  Vehicle update() {
    _prevX = _x;
    _prevY = _y;
    _prevRotation = _rotation;
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

  float getDistanceTo(Vehicle v) {
    float dx = _x - v.x();
    float dy = _y - v.y();
    return sqrt(dx * dx + dy * dy);
  }

  float getAngleTo(Vehicle v) {
    float dx = _x - v.x();
    float dy = _y - v.y();
    return normalizeAngle(atan2(dy, dx));
  }
}
