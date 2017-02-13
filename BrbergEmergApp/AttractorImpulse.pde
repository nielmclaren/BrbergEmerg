
// Steer toward attractors.
class AttractorImpulse extends Impulse {
  private float _factor;
  private float _maxDelta;

  AttractorImpulse(World world) {
    super(world);

    _factor = 0.1;
    _maxDelta = 0.02;
  }

  float factor() {
    return _factor;
  }

  AttractorImpulse factor(float v) {
    _factor = v;
    return this;
  }

  float maxDelta() {
    return _maxDelta;
  }

  AttractorImpulse maxDelta(float v) {
    _maxDelta = v;
    return this;
  }

  float steer(Vehicle vehicle) {
    Attractor attractor = vehicle.attractor();
    if (attractor != null) {
      float attractorAngle = getAngleTo(vehicle, attractor);
      if (abs(getSignedAngleBetween(vehicle.rotation(), attractorAngle)) > PI  * 0.4) {
        float distance = getDistanceBetween(vehicle, attractor);
        float factor = _factor * distance * distance;
        return getScaledRotationDeltaToward(vehicle, attractorAngle, factor, _maxDelta);
      }
    }
    return 0;
  }

  float accelerate(Vehicle vehicle) {
    return vehicle.velocity();
  }
}
