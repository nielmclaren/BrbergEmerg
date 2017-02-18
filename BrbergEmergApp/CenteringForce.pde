
// Pull toward world center.
class CenteringForce extends Force {
  private float _factor;

  CenteringForce(World world) {
    super(world);

    _factor = 0.0000000003;
  }

  float factor() {
    return _factor;
  }

  CenteringForce factor(float v) {
    _factor = v;
    return this;
  }

  PVector accelerate(Vehicle vehicle) {
    float angle = getAngleTo(vehicle, _world.centerRef());
    float distance = getDistanceBetween(vehicle, _world.centerRef());
    float dx = vehicle.x() - _world.centerRef().x;
    float dy = vehicle.y() - _world.centerRef().y;
    float factor = -_factor * distance * distance;
    return vehicle.forceVelocityRef().add(factor * dx, factor * dy);
  }
}
