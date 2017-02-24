
// Steer about in a semi-random way.
class MeanderImpulse extends Impulse {
  private float _maxDelta;
  private float _noiseScale;
  private float _seed;

  MeanderImpulse(World world) {
    super(world);

    _maxDelta = 0.04;
    _noiseScale = 0.1;
    _seed = random(1000);
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

  float steer(Vehicle vehicle) {
    return (noise(_seed * _noiseScale + _world.age() * _noiseScale) - 0.5) * _maxDelta * 2 * PI;
  }

  float accelerate(Vehicle vehicle) {
    return vehicle.velocity();
  }
}
