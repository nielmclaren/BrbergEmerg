
// Steer away from vehicles that are too close.
class SeparationImpulse extends Impulse {
  private float _factor;
  private float _maxDelta;

  SeparationImpulse(World world) {
    super(world);

    _factor = 0.1;
    _maxDelta = 0.05;
  }

  float factor() {
    return _factor;
  }

  SeparationImpulse factor(float v) {
    _factor = v;
    return this;
  }

  float maxDelta() {
    return _maxDelta;
  }

  SeparationImpulse maxDelta(float v) {
    _maxDelta = v;
    return this;
  }

  float steer(Vehicle vehicle) {
    ArrayList<Vehicle> tooCloseVehicles = vehicle.neighborhoodRef().getTooCloseVehicles(vehicle);
    if (tooCloseVehicles.size() > 0) {
      PVector averagePos = getAveragePosition(tooCloseVehicles);
      float tooCloseDirection = getAngleTo(vehicle, averagePos);
      return getScaledRotationDeltaToward(vehicle, tooCloseDirection, -_factor, _maxDelta);
    }
    return 0;
  }

  float accelerate(Vehicle vehicle) {
    return vehicle.velocity();
  }
}
