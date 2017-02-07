
class CenteredAttractorPositioner implements IPositioner {
  private World _world;
  private int _maxAttempts;

  CenteredAttractorPositioner() {
    _maxAttempts = 100000;
  }

  public World world() {
    return _world;
  }

  public CenteredAttractorPositioner world(World v) {
    _world = v;
    return this;
  }

  public int maxAttempts() {
    return _maxAttempts;
  }

  public CenteredAttractorPositioner maxAttempts(int v) {
    _maxAttempts = v;
    return this;
  }

  public boolean position(IPositioned target) {
    if (_world.attractorsRef().size() <= 0) {
      target
        .x(_world.width() / 2)
        .y(_world.height() / 2);
      return true;
    }
    return false;
  }
}
