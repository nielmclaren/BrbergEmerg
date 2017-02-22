
// Steer toward world center.
class CenteringImpulse extends Impulse {
  private float _factor;
  private float _maxDelta;

  CenteringImpulse(World world) {
    super(world);

    _factor = 0.00000001;
    _maxDelta = 0.02;
  }

  float factor() {
    return _factor;
  }

  CenteringImpulse factor(float v) {
    _factor = v;
    return this;
  }

  float maxDelta() {
    return _maxDelta;
  }

  CenteringImpulse maxDelta(float v) {
    _maxDelta = v;
    return this;
  }

  float steer(Vehicle vehicle) {
    float angle = getAngleTo(vehicle, _world.centerRef());
    float distance = getDistanceBetween(vehicle, _world.centerRef());
    float factor = _factor * distance * distance;
    return getScaledRotationDeltaToward(vehicle, angle, factor, _maxDelta);
  }

  float accelerate(Vehicle vehicle) {
    return vehicle.velocity();
  }
}
