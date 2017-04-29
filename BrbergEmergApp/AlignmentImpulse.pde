
// Steer toward the average direction that nearby vehicles are going.
class AlignmentImpulse extends Impulse {
  AlignmentImpulse(World world) {
    super(world);
  }

  void step(Vehicle vehicle) {
    ArrayList<Vehicle> groupVehicles = vehicle.neighborhoodRef().inGroupNeighborsRef();
    if (groupVehicles.size() <= 0) return;

    PVector averageVelocity = getAverageVelocity(groupVehicles);
    averageVelocity.setMag(World.MAX_SPEED);

    PVector steer = PVector.sub(averageVelocity, vehicle.velocity());
    steer.limit(World.MAX_FORCE);

    vehicle.accelerate(steer);
  }

  private PVector getAverageVelocity(ArrayList<Vehicle> vehicles) {
    PVector sum = new PVector();
    for (Vehicle v : vehicles) {
      sum.add(v.velocity());
    }
    if (vehicles.size() > 0) {
      sum.div(vehicles.size());
    }
    return sum;
  }
}

