
// Steer toward attractors. Nearer attractors have more influence.
class AttractorImpulse extends Impulse {
  private float _factor;
  private float _maxAngleBetween;
  private float _maxDelta;
  private boolean _isSingleAttractor;

  AttractorImpulse(World world) {
    super(world);

    _factor = 50;
    _maxAngleBetween = PI  * 0.2;
    _maxDelta = 0.03;
    _isSingleAttractor = false;
  }

  float factor() {
    return _factor;
  }

  AttractorImpulse factor(float v) {
    _factor = v;
    return this;
  }

  float maxAngleBetween() {
    return _maxAngleBetween;
  }

  AttractorImpulse maxAngleBetween(float v) {
    _maxAngleBetween = v;
    return this;
  }

  float maxDelta() {
    return _maxDelta;
  }

  AttractorImpulse maxDelta(float v) {
    _maxDelta = v;
    return this;
  }

  boolean isSingleAttractor() {
    return _isSingleAttractor;
  }

  AttractorImpulse isSingleAttractor(boolean v) {
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
      float factor = _factor / (distance * distance);
      return getScaledRotationDeltaToward(vehicle, attractorAngle, factor, _maxDelta);
    }
    return 0;
  }

  float accelerate(Vehicle vehicle) {
    return vehicle.velocity();
  }
}
