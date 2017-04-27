
class GroupPositioner implements IPositioner {
  private World _world;

  GroupPositioner(World world) {
    _world = world;
  }

  public boolean position(IPositionable target, int index) {
    Vehicle vehicle = (Vehicle)target;

    int numGroups = _world.numGroups();
    int groupId = vehicle.groupId();
    float w = _world.width() / numGroups;
    target
      .x(random(groupId * w, (groupId + 1) * w))
      .y(random(0.45 * _world.height(), 0.55 * _world.height()));
    return true;
  }
}
