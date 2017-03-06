
// Steer toward the average position of nearby vehicles.
class CohesionImpulse extends Impulse {
  private float _factor;
  private float _maxDelta;

  CohesionImpulse(World world) {
    super(world);

    _factor = 0.000001;
    _maxDelta = 0.01;
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

  float steer(Vehicle vehicle) {
    Neighborhood neighborhood = vehicle.neighborhoodRef();
    ArrayList<Vehicle> groupVehicles = neighborhood.inGroupVehicles(vehicle.groupId());
    if (groupVehicles.size() > 0) {
      PVector averagePos = getAveragePosition(groupVehicles);
      float neighborsDirection = getAngleTo(vehicle, averagePos);
      return getScaledRotationDeltaToward(vehicle, neighborsDirection, _factor, _maxDelta);
    }
    return 0;
  }

  float accelerate(Vehicle vehicle) {
    return vehicle.velocity();
  }
}
