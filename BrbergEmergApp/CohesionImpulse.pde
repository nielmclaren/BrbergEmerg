
// Steer toward the average position of nearby vehicles.
class CohesionImpulse extends Impulse {
  CohesionImpulse(World world) {
    super(world);
  }

  float steer(Vehicle vehicle) {
    Neighborhood neighborhood = vehicle.neighborhoodRef();
    if (neighborhood.vehiclesRef().size() > 0) {
      PVector averagePos = getAveragePosition(neighborhood.vehiclesRef());
      float neighborsDirection = getAngleTo(vehicle, averagePos);
      return getScaledRotationDeltaToward(vehicle, neighborsDirection, 0.001, 0.001);
    }
    return 0;
  }

  float accelerate(Vehicle vehicle) {
    return vehicle.velocity();
  }
}
