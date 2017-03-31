
class RingPositioner implements IPositioner {
  private World _world;
  private int _numPositions;
  private float _radius;

  RingPositioner(World world) {
    _world = world;
    _numPositions = 8;
    _radius = 250;
  }

  int numPositions() {
    return _numPositions;
  }

  RingPositioner numPositions(int v) {
    _numPositions = v;
    return this;
  }

  float radius() {
    return _radius;
  }

  RingPositioner radius(float v) {
    _radius = v;
    return this;
  }

  public boolean position(IPositionable target, int index) {
    float angle = (float)index / _numPositions * 2 * PI;
    target
      .x(_world.width() / 2 + _radius * cos(angle))
      .y(_world.height() / 2 + _radius * sin(angle));
    return true;
  }
}
