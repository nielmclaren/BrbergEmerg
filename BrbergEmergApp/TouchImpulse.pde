
// Steer toward touch.
class TouchImpulse extends Impulse {
  TouchImpulse(World world) {
    super(world);
  }

  void step(Vehicle vehicle) {
    if (vehicle.touchRef() != null) {
      PVector target = new PVector(vehicle.touchRef().x(), vehicle.touchRef().y());
      PVector diff = PVector.sub(target, vehicle.position());

      // Scale the velocity to the distance from the touch.
      float dist = diff.mag();
      diff.mult(World.MAX_SPEED / 400);

      PVector steer = PVector.sub(diff, vehicle.velocity());
      steer.limit(World.MAX_FORCE);
      vehicle.accelerate(steer);
    }
  }
}
