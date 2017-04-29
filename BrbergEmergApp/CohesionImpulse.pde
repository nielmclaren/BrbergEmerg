
// Steer toward the average position of nearby vehicles.
class CohesionImpulse extends Impulse {
  CohesionImpulse(World world) {
    super(world);
  }

  void step(Vehicle vehicle) {
    ArrayList<Vehicle> groupVehicles = vehicle.neighborhoodRef().inGroupNeighborsRef();
    if (groupVehicles.size() > 0) {
      PVector averagePos = getAveragePosition(groupVehicles);
      seek(vehicle, averagePos);
    }
  }
}
