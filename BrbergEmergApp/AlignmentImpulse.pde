
// Steer toward the average direction that nearby vehicles are going.
class AlignmentImpulse extends Impulse {
  AlignmentImpulse(World world, Vehicle vehicle) {
    super(world, vehicle);
  }

  float steer(float currentRotation, float scale) {
    Neighborhood neighborhood = _vehicle.neighborhoodRef();
    if (neighborhood.vehiclesRef().size() > 0) {
      float neighborhoodRotation = neighborhood.getAverageRotation();
      return getScaledRotationDeltaToward(currentRotation, neighborhoodRotation, -0.1, 0.02);
    }
    return 0;
  }

  float accelerate(float currentVelocity, float scale) {
    return currentVelocity;
  }
}

