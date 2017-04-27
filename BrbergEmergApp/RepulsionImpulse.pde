
// Steer away from nearby vehicles.
class RepulsionImpulse extends Impulse {
  private float _factor;
  private float _maxDelta;

  RepulsionImpulse(World world) {
    super(world);

    _factor = 0.01;
    _maxDelta = 0.015;
  }

  float factor() {
    return _factor;
  }

  RepulsionImpulse factor(float v) {
    _factor = v;
    return this;
  }

  float maxDelta() {
    return _maxDelta;
  }

  RepulsionImpulse maxDelta(float v) {
    _maxDelta = v;
    return this;
  }

  void step(Vehicle vehicle) {
    ArrayList<Vehicle> tooCloseVehicles = (ArrayList<Vehicle>)getItemsWithin(vehicle.neighborhoodRef().outGroupVehicles(vehicle.groupId()), vehicle, World.OUT_GROUP_MIN_DISTANCE);
    if (tooCloseVehicles.size() > 0) {
      PVector averagePos = getAveragePosition(tooCloseVehicles);
      float tooCloseDirection = getAngleTo(vehicle, averagePos);
      float result = getScaledRotationDeltaToward(vehicle, tooCloseDirection, -_factor, _maxDelta);
      vehicle.nextRotation(vehicle.nextRotation() + result);
    }
  }
}
