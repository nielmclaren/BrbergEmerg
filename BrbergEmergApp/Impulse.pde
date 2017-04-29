
class Impulse {
  protected World _world;

  Impulse(World world) {
    _world = world;
  }

  World world() {
    return _world;
  }

  Impulse world(World v) {
    _world = v;
    return this;
  }

  void step(Vehicle vehicle) {
  }

  protected void seek(Vehicle vehicle, PVector target) {
    PVector desired = PVector.sub(target, vehicle.position());
    desired.setMag(World.MAX_SPEED);

    PVector steer = PVector.sub(desired, vehicle.velocity());
    steer.limit(World.MAX_FORCE);
    vehicle.accelerate(steer);
  }
}
