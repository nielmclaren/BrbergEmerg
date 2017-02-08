
// Steer about in a semi-random way.
class MeanderImpulse extends Impulse {
  private float _maxDelta;
  private float _noiseScale;

  MeanderImpulse(World world, Vehicle vehicle) {
    super(world, vehicle);

    _maxDelta = 0.1;
    _noiseScale = 0.1;
  }

  float maxDelta() {
    return _maxDelta;
  }

  MeanderImpulse maxDelta(float v) {
    _maxDelta = v;
    return this;
  }

  float noiseScale() {
    return _noiseScale;
  }

  MeanderImpulse noiseScale(float v) {
    _noiseScale = v;
    return this;
  }

  float steer(float currentRotation, float scale) {
    return (noise(_world.age() * _noiseScale) - 0.5) * _maxDelta * 2 * PI;
  }

  float accelerate(float currentVelocity, float scale) {
    return currentVelocity;
  }
}
