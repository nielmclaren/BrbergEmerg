
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

  float steer(Vehicle vehicle) {
    return 0;
  }

  float accelerate(Vehicle vehicle) {
    return vehicle.velocity();
  }

  Impulse step() {
    return this;
  }

  protected float getScaledRotationDeltaToward(Vehicle vehicle, float target, float factor, float maxDelta) {
    float current = vehicle.rotation();
    float velocity = vehicle.velocity();
    return getRotationDeltaToward(current, target, factor * velocity, maxDelta * velocity);
  }
}
