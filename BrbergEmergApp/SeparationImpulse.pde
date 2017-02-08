
// Steer away from vehicles that are too close.
class SeparationImpulse extends Impulse {
  SeparationImpulse(World world, Vehicle vehicle) {
    super(world, vehicle);
  }

  float steer(float currentRotation, float scale) {
    ArrayList<Vehicle> tooCloseVehicles = _vehicle.neighborhoodRef().getTooCloseVehicles(_vehicle);
    if (tooCloseVehicles.size() > 0) {
      PVector averagePos = getAveragePosition(tooCloseVehicles);
      float tooCloseDirection = getAngleTo(_vehicle, averagePos);
      return getScaledRotationDeltaToward(currentRotation, tooCloseDirection, -0.1, 0.02);
    }
    return 0;
  }

  float accelerate(float currentVelocity, float scale) {
    return currentVelocity;
  }
}
