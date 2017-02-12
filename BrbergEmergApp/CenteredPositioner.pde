
class CenteredPositioner implements IPositioner {
  private World _world;
  private int _maxAttempts;

  CenteredPositioner(World world) {
    _world = world;
    _maxAttempts = 100000;
  }

  public int maxAttempts() {
    return _maxAttempts;
  }

  public CenteredPositioner maxAttempts(int v) {
    _maxAttempts = v;
    return this;
  }

  public boolean position(IPositioned target) {
    target
      .x(_world.width() / 2)
      .y(_world.height() / 2);
    return true;
  }
}
