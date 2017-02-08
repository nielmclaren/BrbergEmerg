
class CenteredPositioner implements IPositioner {
  private World _world;
  private int _maxAttempts;

  CenteredPositioner() {
    _maxAttempts = 100000;
  }

  public World world() {
    return _world;
  }

  public CenteredPositioner world(World v) {
    _world = v;
    return this;
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
