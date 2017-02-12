
// Steer away from vehicles that are too close.
class SeparationImpulse extends Impulse {
  SeparationImpulse(World world) {
    super(world);
  }

  float steer(Vehicle vehicle) {
    ArrayList<Vehicle> tooCloseVehicles = vehicle.neighborhoodRef().getTooCloseVehicles(vehicle);
    if (tooCloseVehicles.size() > 0) {
      PVector averagePos = getAveragePosition(tooCloseVehicles);
      float tooCloseDirection = getAngleTo(vehicle, averagePos);
      return getScaledRotationDeltaToward(vehicle, tooCloseDirection, -0.1, 0.05);
    }
    return 0;
  }

  float accelerate(Vehicle vehicle) {
    return vehicle.velocity();
  }
}
