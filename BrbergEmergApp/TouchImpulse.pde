
// Steer toward touch.
class TouchImpulse extends Impulse {
  TouchImpulse(World world) {
    super(world);
  }

  void step(Vehicle vehicle) {
    if (vehicle.touchRef() != null) {
      seek(vehicle, new PVector(vehicle.touchRef().x(), vehicle.touchRef().y()));
    }
  }
}
