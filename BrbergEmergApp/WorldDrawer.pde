
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

    for (int i = 0; i < vehicleColors.length; i++) {
      g.fill(vehicleColors[i]);
        g.rect(i * 300, 0, 300, 300);
    }

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
    if (vehicle.neighborhoodRef().inGroupVehicles(vehicle.groupId()).size() <= 0) {
      return;
    }

    colorMode(HSB);

    color c = vehicleColors[vehicle.groupId()];

    float groupRotation = getAverageRotation(vehicle.neighborhoodRef().inGroupVehicles(vehicle.groupId()));
    float rotationFactor = abs(getSignedAngleBetween(vehicle.rotation(), groupRotation)) / PI;

    float h = (hue(c)
        - constrain(map(rotationFactor, 0, 1, 0, 64), 0, 64)
        //- constrain(map(world.age(), 0, 10000, 32, 0), 0, 32)
        ) % 255;
    while (h < 0) {
      h += 255;
    }

    int alpha = floor(0
        + constrain(map(rotationFactor, 0, 1, 0, 32), 0, 32)
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

    g.fill(c);
    g.stroke(c);
    g.strokeWeight(6);
    g.pushMatrix();
    g.translate(vehicle.x(), vehicle.y());
    g.rotate(vehicle.rotation());
    //g.ellipseMode(CENTER);
    //g.ellipse(0, 0, 3, 3);
    g.line(0, 0, -21, 0);
    g.popMatrix();
  }
}

