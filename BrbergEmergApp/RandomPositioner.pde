
class RandomPositioner implements IPositioner {
  private World _world;
  private float _minX;
  private float _maxX;
  private float _minY;
  private float _maxY;

  RandomPositioner(World world) {
    _world = world;
    _minX = 0;
    _maxX = world.width();
    _minY = 0;
    _maxY = world.height();
  }

  public RandomPositioner rect(float minX, float maxX, float minY, float maxY) {
    _minX = minX;
    _maxX = maxX;
    _minY = minY;
    _maxY = maxY;
    return this;
  }

  public boolean position(IPositioned target, int index) {
    target
      .x(random(_minX, _maxX))
      .y(random(_minY, _maxY));
    return true;
  }
}
