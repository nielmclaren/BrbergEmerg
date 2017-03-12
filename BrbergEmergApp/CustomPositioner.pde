
class CustomPositioner implements IPositioner {
  private World _world;

  CustomPositioner(World world) {
    _world = world;
  }

  public boolean position(IPositioned target, int index) {
    if (index == 0) {
      target
        .x(_world.width()/2 - 150)
        .y(_world.height()/2);
    } else if (index == 1) {
      target
        .x(_world.width()/2 + 150)
        .y(_world.height()/2);
    }

    return true;
  }
}
