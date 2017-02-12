
// Steer toward the average direction that nearby vehicles are going.
class AlignmentImpulse extends Impulse {
  AlignmentImpulse(World world) {
    super(world);
  }

  float steer(Vehicle vehicle) {
    Neighborhood neighborhood = vehicle.neighborhoodRef();
    if (neighborhood.vehiclesRef().size() > 0) {
      float neighborhoodRotation = neighborhood.getAverageRotation();
      return getScaledRotationDeltaToward(vehicle, neighborhoodRotation, -0.1, 0.02);
    }
    return 0;
  }

  float accelerate(Vehicle vehicle) {
    return vehicle.velocity();
  }
}

