
class WorldDrawer {
  private Integer[] vehicleColors;

  WorldDrawer() {
    vehicleColors = ColorManager.getVehicleColors();
  }

  public void draw(PGraphics g, World world) {
    drawVehicles(g, world);
  }

  public void draw(BrbergEmergImage g, World world) {
    drawVehicles(g, world);
  }

  private void drawVehicles(PGraphics g, World world) {
    ArrayList<Vehicle> vehicles = world.vehiclesRef();
    for (Vehicle vehicle : vehicles) {
      drawVehicle(g, world, vehicle);
    }
  }

  private void drawVehicle(PGraphics g, World world, Vehicle vehicle) {
    color c = vehicleColors[vehicle.groupId()];
    int radius = 3;
    float x = vehicle.x();
    float y = vehicle.y();
    float rotation = vehicle.rotation();
    int len = 4;

    g.pushStyle();
    g.colorMode(RGB);
    g.fill(c);
    g.noStroke();
    g.ellipse(x, y, radius, radius);
    g.noFill();
    g.stroke(c);
    g.line(x, y, x - len * cos(rotation), y - len * sin(rotation));

    g.popStyle();
  }

  private void drawVehicles(BrbergEmergImage g, World world) {
    ArrayList<Vehicle> vehicles = world.vehiclesRef();
    for (Vehicle vehicle : vehicles) {
      g.drawVehicle(world, vehicle);
    }
  }

  void drawTouches(PGraphics g, World world) {
    int radius = 50;
    ArrayList<Touch> touches = world.touches();

    g.pushStyle();
    g.ellipseMode(CENTER);
    g.noFill();
    g.stroke(255, 32);

    for (Touch touch : touches) {
      g.strokeWeight(12);
      g.ellipse(touch.x(), touch.y(), radius, radius);
      g.strokeWeight(2);
      g.ellipse(touch.x(), touch.y(), radius * 1.5, radius * 1.5);

      if (touch.vehicleRef() != null) {
        Vehicle vehicle = touch.vehicleRef();
        g.line(touch.x(), touch.y(), vehicle.x(), vehicle.y());
      }
    }
    g.popStyle();
  }
}

