
class BrbergEmergImage extends ShortImage {
  private color[] vehicleColors;

  BrbergEmergImage(int w, int h, int format) {
    super(w, h, format);

    vehicleColors = new color[8];
    vehicleColors[0] = color(246, 124, 40);
    vehicleColors[1] = color(250, 73, 59);
    vehicleColors[2] = color(0, 154, 217);
    vehicleColors[3] = color(160, 90, 178);
    vehicleColors[4] = color(44, 74, 93);
    vehicleColors[5] = color(0, 188, 157);
    vehicleColors[6] = color(0, 203, 119);
    vehicleColors[7] = color(252, 194, 44);
  }

  void clear() {
    for (int i = 0; i < _width * _height * _numChannels; i++) {
      _values[i] = Short.MIN_VALUE;
    }
  }

  void drawVehicle(World world, Vehicle vehicle) {
    int targetX = floor(vehicle.x());
    int targetY = floor(vehicle.y());

    float groupRotation = getScaledAverageRotation(vehicle, World.NEIGHBORHOOD_RADIUS,
        vehicle.neighborhoodRef().inGroupVehicles(vehicle.groupId()));
    float rotationFactor = abs(getSignedAngleBetween(vehicle.rotation(), groupRotation)) / PI;

    color c = vehicleColors[vehicle.groupId()];
    float h = (hue(c)
        - constrain(map(rotationFactor, 0, 1, 0, 32), 0, 32)
        //- constrain(map(world.age(), 0, 10000, 32, 0), 0, 32)
        ) % 255;
    while (h < 0) {
      h += 255;
    }

    pushStyle();
    colorMode(HSB);
    c = color(
        h,
        saturation(c),
        brightness(c));

    int minRadius = 12;
    int radius = floor(map(rotationFactor, 0, 1, minRadius, 24));
    if (vehicle.neighborhoodRef().inGroupVehicles(vehicle.groupId()).size() <= 0) {
      radius = minRadius;
    }

    colorMode(RGB, 1);

    int alpha = floor(0
        + constrain(map(rotationFactor, 0, 1, 32, 128), 32, 128)
        + constrain(map(world.age(), 0, 100000, 0, 64), 0, 64)
        ) % 255;
    while (alpha < 0) {
      alpha += 255;
    }

    drawCircleFalloff(targetX, targetY, radius, c, floor(alpha));
    drawCircle(targetX, targetY, 2, c, alpha);

    _isImageDirty = true;
    popStyle();
  }

  private void drawCircle(int targetX, int targetY, int radius, color c, int alpha) {
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
          setColor(pixelIndex, c, error * alpha/255);
        }
      }
    }
  }

  private void drawCircleFalloff(int targetX, int targetY, int radius, color c, int alpha) {
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
          setColor(pixelIndex, c, v * 0.2 * alpha/255);
        }
      }
    }
  }
}
