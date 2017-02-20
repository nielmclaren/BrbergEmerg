
class WorldDrawer {
  private color[] vehicleColors;

  WorldDrawer() {
    vehicleColors = new color[8];
    vehicleColors[0] = color(0, 188, 157);
    vehicleColors[1] = color(246, 124, 40);
    vehicleColors[2] = color(160, 90, 178);
    vehicleColors[3] = color(44, 74, 93);
    vehicleColors[4] = color(0, 203, 119);
    vehicleColors[5] = color(252, 194, 44);
    vehicleColors[6] = color(0, 154, 217);
    vehicleColors[7] = color(250, 73, 59);
  }

  public void drawInitial(PGraphics g, World world) {
    g.background(0);
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

    color c = vehicleColors[vehicle.groupId()];
    if (vehicle.neighborhoodRef().inGroupVehicles(vehicle.groupId()).size() <= 0) {
      c = color(hue(c), saturation(c), brightness(c), 2);
    } else {
      float groupRotation = getAverageRotation(vehicle.neighborhoodRef().inGroupVehicles(vehicle.groupId()));
      float rotationFactor = abs(getSignedAngleBetween(vehicle.rotation(), groupRotation)) / PI;

      c = color(
          (hue(c) + map(rotationFactor, 0, 1, 0, 32)) % 255,
          saturation(c),
          brightness(c),
          map(rotationFactor, 0, 1, 0, 64));
    }

    g.stroke(c);
    g.strokeWeight(2);
    g.line(vehicle.x(), vehicle.y(),
        vehicle.x() - 5 * cos(vehicle.rotation()),
        vehicle.y() - 5 * sin(vehicle.rotation()));

    g.noStroke();
    g.fill(c);
    g.ellipseMode(CENTER);
    g.ellipse(vehicle.x(), vehicle.y(), 4, 4);
  }
}

