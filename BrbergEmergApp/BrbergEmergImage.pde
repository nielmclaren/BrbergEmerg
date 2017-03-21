
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

    if (vehicle.neighborhoodRef().inGroupVehicles(vehicle.groupId()).size() <= 0) {
      return;
    }

    colorMode(HSB);

    color c = vehicleColors[vehicle.groupId()];

    float groupRotation = getAverageRotation(vehicle.neighborhoodRef().inGroupVehicles(vehicle.groupId()));
    float rotationFactor = abs(getSignedAngleBetween(vehicle.rotation(), groupRotation)) / PI;

    float h = (hue(c)
        - constrain(map(rotationFactor, 0, 1, 0, 32), 0, 32)
        //- constrain(map(world.age(), 0, 10000, 32, 0), 0, 32)
        ) % 255;
    while (h < 0) {
      h += 255;
    }

    int alpha = floor(0
        + constrain(map(rotationFactor, 0, 1, 32, 128), 32, 128)
        + constrain(map(world.age(), 0, 10000, 0, 64), 0, 64)
        ) % 255;
    while (alpha < 0) {
      alpha += 255;
    }

    c = color(
        h,
        saturation(c),
        brightness(c),
        alpha);

    int radius = floor(map(rotationFactor, 0, 1, 2, 8));
    int radiusSquared = radius * radius;

    int minX = max(0, targetX - radius);
    int maxX = min(targetX + radius, _width - 1);
    int minY = max(0, targetY - radius);
    int maxY = min(targetY + radius, _height - 1);

    for (int x = minX; x < maxX; x++) {
      for (int y = minY; y < maxY; y++) {
        float dx = x - targetX;
        float dy = y - targetY;
        if (dx * dx + dy * dy < radiusSquared) {
          setPixel(x, y, c);
        }
      }
    }
  }
}
