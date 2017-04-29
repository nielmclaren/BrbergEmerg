
class BrbergEmergImage extends ShortImage {
  private Integer[] vehicleColors;

  BrbergEmergImage(int w, int h, int format) {
    super(w, h, format);

    vehicleColors = ColorManager.getVehicleColors();
  }

  void clear() {
    for (int i = 0; i < _width * _height * _numChannels; i++) {
      _values[i] = Short.MIN_VALUE;
    }
  }

  void drawVehicle(World world, Vehicle vehicle) {
    int targetX = floor(vehicle.position().x);
    int targetY = floor(vehicle.position().y);

    ArrayList<Vehicle> inGroupVehicles = vehicle.neighborhoodRef().inGroupNeighborsRef();
    float alignmentFactor = getAlignmentFactor(vehicle, inGroupVehicles);

    pushStyle();
    colorMode(RGB, 1);

    color c = vehicleColors[vehicle.groupId()];

    int minRadius = 12;
    int radius;
    if (vehicle.touchRef() == null) {
      radius = floor(map(alignmentFactor, 0, 1, minRadius, 24));
    } else {
      radius = 40;
      c = color(255);
    }

    float alpha = map(alignmentFactor, 0, 1, 0.125, 0.5);
    drawCircleFalloff(targetX, targetY, radius, c, alpha);
    drawCircle(targetX, targetY, 2, c, alpha);

    _isImageDirty = true;
    popStyle();
  }

  private float getAlignmentFactor(Vehicle vehicle, ArrayList<Vehicle> vehicles) {
    if (vehicles.size() <= 0) {
      return 0;
    }

    PVector dir = vehicle.velocity().copy();
    dir.normalize();
    PVector groupDir = getWeightedAverageVelocity(vehicle, vehicles);
    groupDir.normalize();

    return PVector.sub(dir, groupDir).mag() / 2;
  }

  private PVector getWeightedAverageVelocity(Vehicle vehicle, ArrayList<Vehicle> vehicles) {
    PVector sum = vehicle.velocity().copy();
    for (Vehicle v : vehicles) {
      float dist = PVector.dist(v.position(), vehicle.position());
      PVector weightedVelocity = v.velocity().copy();
      weightedVelocity.mult(1 - dist / World.NEIGHBORHOOD_RADIUS);

      sum.add(weightedVelocity);
    }
    if (vehicles.size() > 0) {
      sum.div(vehicles.size() + 1);
    }

    return sum;
  }

  private void drawCircle(int targetX, int targetY, int radius, color c) {
    drawCircle(targetX, targetY, radius, c, 255);
  }

  private void drawCircle(int targetX, int targetY, int radius, color c, float alpha) {
    float radiusSquared = radius * radius;
    for (int x = -radius; x <= radius; x++) {
      for (int y = -radius; y <= radius; y++) {
        if (targetX + x < 0 || targetX + x >= g.width || targetY + y < 0 || targetY + y >= g.height) {
          continue;
        }

        float rSquared = (x + 0.5) * (x + 0.5) + (y + 0.5) * (y + 0.5);
        if (rSquared < radiusSquared) {
          float error = radius - sqrt(rSquared);
          int pixelIndex = (targetY + y) * _width + (targetX + x);
          setColor(pixelIndex, c, error * alpha);
        }
      }
    }
  }

  private void drawCircleFalloff(int targetX, int targetY, int radius, color c, float alpha) {
    float falloff = 0.88;
    float radiusSquared = radius * radius;
    for (int x = -radius; x <= radius; x++) {
      for (int y = -radius; y <= radius; y++) {
        if (targetX + x < 0 || targetX + x >= g.width || targetY + y < 0 || targetY + y >= g.height) {
          continue;
        }

        float rSquared = (x + 0.5) * (x + 0.5) + (y + 0.5) * (y + 0.5);
        if (rSquared < radiusSquared) {
          float v = sqrt(rSquared) / radius;
          v = 1 + 1 / pow(v + falloff, 2) - 1 / pow(falloff, 2);
          v = constrain(v, 0, 1);

          int pixelIndex = (targetY + y) * _width + (targetX + x);
          setColor(pixelIndex, c, v * 0.2 * alpha);
        }
      }
    }
  }
}
