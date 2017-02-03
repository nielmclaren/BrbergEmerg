
class Attractor {
  private float _x;
  private float _y;
  private float _radius;

  Attractor(float x, float y, float radius) {
    _x = x;
    _y = y;
    _radius = radius;
  }

  public float x() {
    return _x;
  }

  public Attractor x(float v) {
    _x = v;
    return this;
  }

  public float y() {
    return _y;
  }

  public Attractor y(float v) {
    _y = v;
    return this;
  }

  float radius() {
    return _radius;
  }

  public Attractor radius(float v) {
    _radius = v;
    return this;
  }

  public boolean isColliding(Attractor a) {
    float dx = _x - a.x();
    float dy = _y - a.y();
    float r = _radius + a.radius();
    return dx * dx + dy * dy < r * r;
  }
}
