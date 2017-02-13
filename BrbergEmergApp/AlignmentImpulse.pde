
// Steer toward the average direction that nearby vehicles are going.
class AlignmentImpulse extends Impulse {
  private float _factor;
  private float _maxDelta;

  AlignmentImpulse(World world) {
    super(world);

    _factor = 0.1;
    _maxDelta = 0.02;
  }

  float factor() {
    return _factor;
  }

  AlignmentImpulse factor(float v) {
    _factor = v;
    return this;
  }

  float maxDelta() {
    return _maxDelta;
  }

  AlignmentImpulse maxDelta(float v) {
    _maxDelta = v;
    return this;
  }

  float steer(Vehicle vehicle) {
    Neighborhood neighborhood = vehicle.neighborhoodRef();
    if (neighborhood.vehiclesRef().size() > 0) {
      float neighborhoodRotation = neighborhood.getAverageRotation();
      return getScaledRotationDeltaToward(vehicle, neighborhoodRotation, _factor, _maxDelta);
    }
    return 0;
  }

  float accelerate(Vehicle vehicle) {
    return vehicle.velocity();
  }
}

