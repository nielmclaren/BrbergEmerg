
class CenteredPositioner implements IPositioner {
  private World _world;

  CenteredPositioner(World world) {
    _world = world;
  }

  public boolean position(IPositioned target, int index) {
    target
      .x(_world.width() / 2)
      .y(_world.height() / 2);
    return true;
  }
}
