
// Steer toward attractors.
class AttractorImpulse extends Impulse {
  AttractorImpulse(World world, Vehicle vehicle) {
    super(world, vehicle);
  }

  float steer(float currentRotation, float scale) {
    Attractor attractor = _vehicle.attractor();
    if (attractor != null) {
      float attractorAngle = getAngleTo(_vehicle, attractor);
      return getScaledRotationDeltaToward(currentRotation, attractorAngle, 0.1, 0.02);
    }
    return 0;
  }

  float accelerate(float currentVelocity, float scale) {
    return currentVelocity;
  }
}
