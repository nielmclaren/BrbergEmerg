
// Steer toward the average direction that nearby vehicles are going.
class AlignmentImpulse extends Impulse {
  private float _factor;
  private float _maxDelta;

  AlignmentImpulse(World world) {
    super(world);

    _factor = 0.02;
    _maxDelta = 0.04;
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

  void step(Vehicle vehicle) {
    Neighborhood neighborhood = vehicle.neighborhoodRef();
    ArrayList<Vehicle> groupVehicles = neighborhood.inGroupVehicles(vehicle.groupId());
    if (groupVehicles.size() > 0) {
      float neighborhoodRotation = getAverageRotation(groupVehicles);
      float result = getScaledRotationDeltaToward(vehicle, neighborhoodRotation, _factor, _maxDelta);
      vehicle.nextRotation(vehicle.nextRotation() + result);
    }
  }
}

