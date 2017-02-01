
class Vehicle {
  private float _x;
  private float _y;
  private float _prevRotation;
  private float _rotation;
  private Neighborhood _neighborhood;

  private float _vehicleSizeSq;

  Vehicle(float x, float y, float rotation) {
    _x = x;
    _y = y;
    _prevRotation = rotation;
    _rotation = rotation;
    _neighborhood = new Neighborhood();

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

  Neighborhood neighborhoodRef() {
    return _neighborhood;
  }

  Vehicle neighborhoodRef(Neighborhood v) {
    _neighborhood = v;
    return this;
  }

  Vehicle update() {
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
}
