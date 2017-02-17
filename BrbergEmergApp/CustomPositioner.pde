
class CustomPositioner implements IPositioner {
  private World _world;

  CustomPositioner(World world) {
    _world = world;
  }

  public boolean position(IPositioned target) {
    float angle = random(2 * PI);
    float radius = _world.width() * 0.35;

    Vehicle vehicle = (Vehicle)target;
    if (vehicle != null) {
      vehicle
        .x(_world.width()/2 + radius * cos(angle))
        .y(_world.height()/2 + radius * sin(angle))
        .rotation(normalizeAngle(angle + PI));
    }

    return true;
  }
}
