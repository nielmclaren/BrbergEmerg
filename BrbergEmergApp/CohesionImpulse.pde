
// Steer toward the average position of nearby vehicles.
class CohesionImpulse extends Impulse {
  CohesionImpulse(World world, Vehicle vehicle) {
    super(world, vehicle);
  }

  float steer(float currentRotation, float scale) {
    Neighborhood neighborhood = _vehicle.neighborhoodRef();
    if (neighborhood.vehiclesRef().size() > 0) {
      PVector averagePos = getAveragePosition(neighborhood.vehiclesRef());
      float neighborsDirection = getAngleTo(_vehicle, averagePos);
      return getScaledRotationDeltaToward(currentRotation, neighborsDirection, 0.1, 0.02);
    }
    return 0;
  }

  float accelerate(float currentVelocity, float scale) {
    return currentVelocity;
  }
}
