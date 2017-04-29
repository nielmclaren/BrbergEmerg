
// Steer away from vehicles that are too close.
class SeparationImpulse extends Impulse {
  SeparationImpulse(World world) {
    super(world);
  }

  void step(Vehicle vehicle) {
    ArrayList<Vehicle> tooCloseVehicles = vehicle.neighborhoodRef().inGroupTooCloseRef();
    if (tooCloseVehicles.size() <= 0) return;

    PVector steer = getWeightedDirectionTo(vehicle, tooCloseVehicles);
    if (steer.mag() <= 0) return;

    steer.setMag(World.MAX_SPEED);

    steer.sub(vehicle.velocity());
    steer.limit(World.MAX_FORCE);
    steer.mult(1.5);

    if (steer.mag() > 0) {
      vehicle.accelerate(steer);
    }
  }

  private PVector getWeightedDirectionTo(Vehicle vehicle, ArrayList<Vehicle> vehicles) {
    PVector result = new PVector();
    int count = 0;
    for (Vehicle v : vehicles) {
      float d = PVector.dist(vehicle.position(), v.position());
      if (d > 0) {
        PVector diff = PVector.sub(vehicle.position(), v.position());
        diff.normalize();
        diff.div(d);
        result.add(diff);
        count++;
      }
    }

    if (count > 0) {
      result.div((float)count);
    }

    return result;
  }
}
