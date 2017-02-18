
class Force {
  protected World _world;

  Force(World world) {
    _world = world;
  }

  World world() {
    return _world;
  }

  Force world(World v) {
    _world = v;
    return this;
  }

  PVector accelerate(Vehicle vehicle) {
    return vehicle.forceVelocityRef();
  }

  Force step() {
    return this;
  }
}
