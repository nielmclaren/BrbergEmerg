
class DartboardAttractorPositioner implements IPositioner {
  private World _world;
  private int _maxAttempts;
  private float _minX;
  private float _maxX;
  private float _minY;
  private float _maxY;

  DartboardAttractorPositioner(World world) {
    _world = world;
    _maxAttempts = 100000;
    _minX = 0;
    _maxX = world.width();
    _minY = 0;
    _maxY = world.height();
  }

  public int maxAttempts() {
    return _maxAttempts;
  }

  public DartboardAttractorPositioner maxAttempts(int v) {
    _maxAttempts = v;
    return this;
  }

  public DartboardAttractorPositioner rect(float minX, float maxX, float minY, float maxY) {
    _minX = minX;
    _maxX = maxX;
    _minY = minY;
    _maxY = maxY;
    return this;
  }

  public boolean position(IPositioned target, int index) {
    int numAttempts = 0;
    int maxAttempts = 100000;

    float positionX;
    float positionY;
    float radius = ((Attractor)target).radius();

    ArrayList<Attractor> attractors = _world.attractorsRef();
    while (numAttempts < maxAttempts) {
      positionX = random(_minX, _maxX);
      positionY = random(_minY, _maxY);

      if (hasAttractorCollision(positionX, positionY, radius)) {
        numAttempts++;
        continue;
      } else {
        target
          .x(positionX)
          .y(positionY);
        return true;
      }
    }
    return false;
  }

  private boolean hasAttractorCollision(float x, float y, float radius) {
    ArrayList<Attractor> attractors = _world.attractorsRef();
    for (Attractor attractor : attractors) {
      if (attractor.isColliding(x, y, radius)) {
        return true;
      }
    }
    return false;
  }
}

