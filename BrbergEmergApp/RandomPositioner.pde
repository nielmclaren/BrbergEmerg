
class RandomPositioner implements IPositioner {
  private World _world;

  RandomPositioner() {
  }

  public World world() {
    return _world;
  }

  public RandomPositioner world(World v) {
    _world = v;
    return this;
  }

  public boolean position(IPositioned target) {
    target
      .x(random(_world.width()))
      .y(random(_world.height()));
    return true;
  }
}
