
// Steer toward the average position of nearby vehicles.
class CohesionImpulse extends Impulse {
  private float _factor;
  private float _maxDelta;

  CohesionImpulse(World world) {
    super(world);

    _factor = 0.0000002;
    _maxDelta = 0.006;
  }

  float factor() {
    return _factor;
  }

  CohesionImpulse factor(float v) {
    _factor = v;
    return this;
  }

  float maxDelta() {
    return _maxDelta;
  }

  CohesionImpulse maxDelta(float v) {
    _maxDelta = v;
    return this;
  }

  void step(Vehicle vehicle) {
    Neighborhood neighborhood = vehicle.neighborhoodRef();
    ArrayList<Vehicle> groupVehicles = neighborhood.inGroupVehicles(vehicle.groupId());
    if (groupVehicles.size() > 0) {
      PVector averagePos = getAveragePosition(groupVehicles);
      float neighborsDirection = getAngleTo(vehicle, averagePos);
      float result = getScaledRotationDeltaToward(vehicle, neighborsDirection, _factor, _maxDelta);
      vehicle.nextRotate(result);
    }
  }
}
