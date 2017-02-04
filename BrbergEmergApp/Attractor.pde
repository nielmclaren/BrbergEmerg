
class Attractor implements IPositioned {
  private float _x;
  private float _y;
  private float _radius;
  private long _age;
  private int _badgeCount;

  Attractor() {
    _x = 0;
    _y = 0;
    _radius = 0;
    _age = 0;
    _badgeCount = 0;
  }

  Attractor(float x, float y, float radius) {
    _x = x;
    _y = y;
    _radius = radius;
    _age = 0;
    _badgeCount = 0;
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

  long age() {
    return _age;
  }

  public Attractor age(long v) {
    _age = v;
    return this;
  }

  int badgeCount() {
    return _badgeCount;
  }

  public Attractor badgeCount(int v) {
    _badgeCount = v;
    return this;
  }

  public void step() {
    _age++;
  }

  public boolean isColliding(Attractor a) {
    float dx = _x - a.x();
    float dy = _y - a.y();
    float r = _radius + a.radius();
    return dx * dx + dy * dy < r * r;
  }

  public Attractor clone() {
    return new Attractor()
      .x(_x)
      .y(_y)
      .radius(_radius);
  }
}
