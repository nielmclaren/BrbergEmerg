
class WorldDrawer {
  private color[] vehicleColors;
  private String[] vehicleGlyphs;

  WorldDrawer() {
    vehicleColors = new color[8];
    vehicleColors[0] = color(0, 188, 157);
    vehicleColors[1] = color(246, 124, 40);
    vehicleColors[2] = color(250, 73, 59);
    vehicleColors[3] = color(0, 154, 217);
    vehicleColors[4] = color(160, 90, 178);
    vehicleColors[5] = color(44, 74, 93);
    vehicleColors[6] = color(0, 203, 119);
    vehicleColors[7] = color(252, 194, 44);

    vehicleGlyphs = new String[17];
    vehicleGlyphs[0] = "\u2192";
    vehicleGlyphs[1] = "\u219B";
    vehicleGlyphs[2] = "\u27F6";
    vehicleGlyphs[3] = "\u21D2";
    vehicleGlyphs[4] = "\u21E2";
    vehicleGlyphs[5] = "\u21C9";
    vehicleGlyphs[6] = "\u21C0";
    vehicleGlyphs[7] = "\u21FC";
    vehicleGlyphs[8] = "\u21A0";
    vehicleGlyphs[9] = "\u2907";
    vehicleGlyphs[10] = "\u2911";
    vehicleGlyphs[11] = "\u291A";
    vehicleGlyphs[12] = "\u290F";
    vehicleGlyphs[13] = "\u291C";
    vehicleGlyphs[14] = "\u2945";
    vehicleGlyphs[15] = "\u219D";
    vehicleGlyphs[16] = "\u2971";
  }

  public void drawInitial(PGraphics g, World world) {
    drawAttractors(g, world);
  }

  public void draw(PGraphics g, World world) {
    drawVehicles(g, world);
  }

  private void drawAttractors(PGraphics g, World world) {
    ArrayList<Attractor> attractors = world.attractorsRef();
    for (Attractor attractor : attractors) {
      g.colorMode(RGB);
      g.noStroke();
      g.fill(16);
      g.ellipseMode(RADIUS);
      g.ellipse(attractor.x(), attractor.y(), attractor.radius(), attractor.radius());
    }
  }

  private void drawVehicles(PGraphics g, World world) {
    ArrayList<Vehicle> vehicles = world.vehiclesRef();

    for (Vehicle vehicle : vehicles) {
      drawVehicle(g, world, vehicle);
    }
  }

  private void drawVehicle(PGraphics g, World world, Vehicle vehicle) {
    g.colorMode(HSB);

    int alpha = 255;
    color c = vehicleColors[vehicle.groupId()];
    if (vehicle.neighborhoodRef().inGroupVehicles(vehicle.groupId()).size() <= 0) {
      c = color(hue(c), saturation(c), brightness(c), alpha);
    } else {
      float groupRotation = getAverageRotation(vehicle.neighborhoodRef().inGroupVehicles(vehicle.groupId()));
      float rotationFactor = abs(getSignedAngleBetween(vehicle.rotation(), groupRotation)) / PI;

      float h = (hue(c) - map(rotationFactor, 0, 1, 0, 48)) % 255;
      while (h < 0) {
        h += 255;
      }

      c = color(
          h,
          saturation(c),
          brightness(c),
          alpha);
    }

    g.fill(c);
    g.pushMatrix();
    g.translate(vehicle.x(), vehicle.y());
    g.rotate(vehicle.rotation());
    g.textSize(24);
    g.text(vehicleGlyphs[vehicle.groupId()], 0, 0);
    g.popMatrix();
  }
}

