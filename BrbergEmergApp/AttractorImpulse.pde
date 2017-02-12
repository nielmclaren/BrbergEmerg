
// Steer toward attractors.
class AttractorImpulse extends Impulse {
  AttractorImpulse(World world) {
    super(world);
  }

  float steer(Vehicle vehicle) {
    Attractor attractor = vehicle.attractor();
    if (attractor != null) {
      float attractorAngle = getAngleTo(vehicle, attractor);
      return getScaledRotationDeltaToward(vehicle, attractorAngle, 0.5, 0.05);
    }
    return 0;
  }

  float accelerate(Vehicle vehicle) {
    return vehicle.velocity();
  }
}
