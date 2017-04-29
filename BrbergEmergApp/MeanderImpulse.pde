
// Steer about in a semi-random way.
class MeanderImpulse extends Impulse {
  private float _noiseScale;
  private float _seed;

  MeanderImpulse(World world) {
    super(world);

    _noiseScale = 0.1;
    _seed = random(1000000);
  }

  float noiseScale() {
    return _noiseScale;
  }

  MeanderImpulse noiseScale(float v) {
    _noiseScale = v;
    return this;
  }

  void step(Vehicle vehicle) {
    float n = noise((_seed + _world.age() + vehicle.id() * 1000000) * _noiseScale) * 2 - 1;
    PVector desired = new PVector(World.MAX_SPEED, 0).rotate(n * 2 * PI);

    PVector steer = PVector.sub(desired, vehicle.velocity());
    steer.limit(World.MAX_FORCE);
    steer.mult(0.8);

    vehicle.accelerate(steer);
  }
}
