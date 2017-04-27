
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
    int targetX = floor(vehicle.x());
    int targetY = floor(vehicle.y());

    float groupRotation = getScaledAverageRotation(vehicle, vehicle.rotation(), World.NEIGHBORHOOD_RADIUS,
        vehicle.neighborhoodRef().inGroupVehicles(vehicle.groupId()));
    float rotationFactor = abs(getSignedAngleBetween(vehicle.rotation(), groupRotation)) / PI;
    if (vehicle.neighborhoodRef().inGroupVehicles(vehicle.groupId()).size() <= 0) {
      rotationFactor = 0;
    }

    pushStyle();

    color c = vehicleColors[vehicle.groupId()];

    int minRadius = 12;
    int radius;
    if (vehicle.touchRef() == null) {
      radius = floor(map(rotationFactor, 0, 1, minRadius, 24));
    } else {
      radius = 40;
      c = color(255);
    }

    float alpha = (0
        + constrain(map(rotationFactor, 0, 1, 0.125, 0.5), 0.125, 0.5)
        + constrain(map(world.age(), 0, 100000, 0, 0.25), 0, 0.25)
        ) % 1;
    while (alpha < 0) {
      alpha += 1;
    }

    colorMode(RGB, 1);
    drawCircleFalloff(targetX, targetY, radius, c, floor(alpha));
    drawCircle(targetX, targetY, 2, c, alpha);

    _isImageDirty = true;
    popStyle();
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
