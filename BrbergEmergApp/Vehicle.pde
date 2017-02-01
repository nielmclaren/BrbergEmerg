
class Vehicle {
  private float _x;
  private float _y;
  private float _rotation;

  Vehicle(float x, float y, float rotation) {
    _x = x;
    _y = y;
    _rotation = rotation;
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

  float rotation() {
    return _rotation;
  }

  Vehicle rotation(float v) {
    _rotation = v;
    return this;
  }

  boolean isColliding(Vehicle v) {
    float dx = _x - v.x();
    float dy = _y - v.y();
    return dx * dx + dy * dy < 22 * 22;
  }
}
