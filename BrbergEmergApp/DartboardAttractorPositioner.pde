
class DartboardAttractorPositioner implements IPositioner {
  private World _world;
  private int _maxAttempts;

  DartboardAttractorPositioner() {
    _maxAttempts = 100000;
  }

  public World world() {
    return _world;
  }

  public DartboardAttractorPositioner world(World v) {
    _world = v;
    return this;
  }

  public int maxAttempts() {
    return _maxAttempts;
  }

  public DartboardAttractorPositioner maxAttempts(int v) {
    _maxAttempts = v;
    return this;
  }

  public boolean position(IPositioned target) {
    int numAttempts = 0;
    int maxAttempts = 100000;

    float positionX;
    float positionY;
    float radius = ((Attractor)target).radius();

    ArrayList<Attractor> attractors = _world.attractorsRef();
    while (numAttempts < maxAttempts) {
      positionX = random(width);
      positionY = random(height);

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

