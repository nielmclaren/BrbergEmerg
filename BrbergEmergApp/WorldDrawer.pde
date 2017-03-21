
class WorldDrawer {
  private color[] vehicleColors;

  WorldDrawer() {
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

  public void drawInitial(PGraphics g, World world) {
    g.background(0);
    drawAttractors(g, world);
  }

  public void draw(BrbergEmergImage g, World world) {
    drawVehicles(g, world);
  }

  public void drawAttractors(PGraphics g, World world) {
    ArrayList<Attractor> attractors = world.attractorsRef();
    for (Attractor attractor : attractors) {
      g.colorMode(RGB);
      g.stroke(32);
      g.strokeWeight(8);
      g.noFill();
      g.ellipseMode(RADIUS);
      g.ellipse(attractor.x(), attractor.y(), attractor.radius(), attractor.radius());
    }
  }

  private void drawVehicles(BrbergEmergImage g, World world) {
    ArrayList<Vehicle> vehicles = world.vehiclesRef();

    for (Vehicle vehicle : vehicles) {
      g.drawVehicle(world, vehicle);
    }
  }
}

