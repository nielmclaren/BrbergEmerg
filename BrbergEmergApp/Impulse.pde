
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

  protected float getScaledRotationDeltaToward(Vehicle vehicle, float target, float factor, float maxDelta) {
    float current = vehicle.nextRotation();
    float velocity = vehicle.velocity();
    return getRotationDeltaToward(current, target, factor * velocity, maxDelta * velocity);
  }
}
