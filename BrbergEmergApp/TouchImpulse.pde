
// Steer toward touch.
class TouchImpulse extends Impulse {
  private float _factor;
  private float _maxDelta;

  TouchImpulse(World world) {
    super(world);

    _factor = 1;
    _maxDelta = 0.5;
  }

  float factor() {
    return _factor;
  }

  TouchImpulse factor(float v) {
    _factor = v;
    return this;
  }

  float maxDelta() {
    return _maxDelta;
  }

  TouchImpulse maxDelta(float v) {
    _maxDelta = v;
    return this;
  }

  void step(Vehicle vehicle) {
    if (vehicle.touchRef() != null) {
      float result = getRotationDeltaToward(vehicle, vehicle.touchRef());
      vehicle.nextRotation(vehicle.nextRotation() + result);
    }
  }

  private float getRotationDeltaToward(Vehicle vehicle, Touch touch) {
    float touchAngle = getAngleTo(vehicle, touch);
    return getScaledRotationDeltaToward(vehicle, touchAngle, _factor, _maxDelta);
  }
}
