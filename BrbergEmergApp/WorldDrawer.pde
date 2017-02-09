
class WorldDrawer {
  private color[] vehicleColors;

  WorldDrawer() {
    vehicleColors = new color[8];
    vehicleColors[0] = color(0, 188, 157);
    vehicleColors[1] = color(0, 203, 119);
    vehicleColors[2] = color(0, 154, 217);
    vehicleColors[3] = color(160, 90, 178);
    vehicleColors[4] = color(44, 74, 93);
    vehicleColors[5] = color(252, 194, 44);
    vehicleColors[6] = color(246, 124, 40);
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
      g.stroke(64);
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
    int vehicleColor = vehicleColors[vehicle.groupId()];

    long age = world.age();
    color c = color((128 + floor(age / 10)) % 255, 255, 255);

    g.colorMode(HSB);
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

