
// Steer toward attractors. Farther attractors have more influence.
class InverseAttractorImpulse extends Impulse {
  private float _factor;
  private float _maxAngleBetween;
  private float _maxDelta;
  private boolean _isSingleAttractor;

  InverseAttractorImpulse(World world) {
    super(world);

    _factor = 0.0000004;
    _maxAngleBetween = PI  * 0.45;
    _maxDelta = 0.012;
    _isSingleAttractor = false;
  }

  float factor() {
    return _factor;
  }

  InverseAttractorImpulse factor(float v) {
    _factor = v;
    return this;
  }

  float maxAngleBetween() {
    return _maxAngleBetween;
  }

  InverseAttractorImpulse maxAngleBetween(float v) {
    _maxAngleBetween = v;
    return this;
  }

  float maxDelta() {
    return _maxDelta;
  }

  InverseAttractorImpulse maxDelta(float v) {
    _maxDelta = v;
    return this;
  }

  boolean isSingleAttractor() {
    return _isSingleAttractor;
  }

  InverseAttractorImpulse isSingleAttractor(boolean v) {
    _isSingleAttractor = v;
    return this;
  }

  float steer(Vehicle vehicle) {
    if (_isSingleAttractor) {
      return getRotationDeltaToward(vehicle, vehicle.attractor());
    }

    float result = 0;
    ArrayList<Attractor> attractors = _world.attractorsRef();
    for (Attractor attractor : attractors) {
      result += getRotationDeltaToward(vehicle, attractor);
    }
    return result;
  }

  private float getRotationDeltaToward(Vehicle vehicle, Attractor attractor) {
    float attractorAngle = getAngleTo(vehicle, attractor);
    if (abs(getSignedAngleBetween(vehicle.rotation(), attractorAngle)) > _maxAngleBetween) {
      float distance = getDistanceBetween(vehicle, attractor);
      float factor = _factor * distance * distance;
      return getScaledRotationDeltaToward(vehicle, attractorAngle, factor, _maxDelta);
    }
    return 0;
  }

  float accelerate(Vehicle vehicle) {
    return vehicle.velocity();
  }
}
