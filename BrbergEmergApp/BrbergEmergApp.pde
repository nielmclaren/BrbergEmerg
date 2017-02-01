
PImage chargeImage;
World world;

void setup() {
  size(800, 800);

  chargeImage = loadImage("charge-t.png");
  world = new World(width, height);

  reset();
}

void reset() {
  world.clearVehicles();
  world.setupVehicles();
  world.calculateNeighborhoods();

  redraw();
}

void redraw() {
  background(0);
  ArrayList<Vehicle> vehicles = world.vehiclesRef();

  for (int i = 0; i < vehicles.size(); i++) {
    Vehicle vehicle = vehicles.get(i);

    vehicle.rotation(vehicle.neighborhoodRef().getAveragePrevRotation());

    pushMatrix();
    translate(vehicle.x(), vehicle.y());
    rotate(vehicle.rotation());
    imageMode(CENTER);
    image(chargeImage, 0, 0);
    popMatrix();
  }

  world.update();
}

void draw() {
}

void keyReleased() {
  switch (key) {
    case 'e':
      reset();
      break;
    case 'r':
      save("render.png");
      break;
  }
}

