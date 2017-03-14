
class CustomPositioner implements IPositioner {
  private World _world;

  CustomPositioner(World world) {
    _world = world;
  }

  public boolean position(IPositioned target, int index) {
    int numTargets = 3;
    float angle = (float)index / numTargets * 2 * PI;
    float radius = 150;

    target
      .x(_world.width()/2 + radius * cos(angle))
      .y(_world.height()/2 + radius * sin(angle));

    return true;
  }
}
