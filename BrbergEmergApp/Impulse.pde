
class Impulse {
  protected World _world;
  protected Vehicle _vehicle;

  Impulse(World world, Vehicle vehicle) {
    _world = world;
    _vehicle = vehicle;
  }

  World world() {
    return _world;
  }

  Impulse world(World v) {
    _world = v;
    return this;
  }

  Vehicle vehicle() {
    return _vehicle;
  }

  Impulse vehicle(Vehicle v) {
    _vehicle = v;
    return this;
  }

  float steer(float currentRotation, float scale) {
    return currentRotation;
  }

  float accelerate(float currentVelocity, float scale) {
    return currentVelocity;
  }

  Impulse step() {
    return this;
  }

  protected float getScaledRotationDeltaToward(float current, float target, float factor) {
    return getRotationDeltaToward(current, target, factor * _vehicle.velocity(), 0);
  }

  protected float getScaledRotationDeltaToward(float current, float target, float factor, float maxDelta) {
    return getRotationDeltaToward(current, target, factor * _vehicle.velocity(), maxDelta * _vehicle.velocity());
  }
}
