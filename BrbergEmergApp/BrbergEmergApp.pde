
PImage chargeImage;
World world;
boolean isPaused;

void setup() {
  size(800, 800);

  chargeImage = loadImage("charge-t.png");
  world = new World(width, height);
  isPaused = false;

  reset();
}

void reset() {
  world.clearVehicles();
  world.setupVehicles(10000);
  world.calculateNeighborhoods();
}

void draw() {
  if (!isPaused) {
    redraw();
  }
}

void redraw() {
  background(0);
  ArrayList<Vehicle> vehicles = world.vehiclesRef();

  for (int i = 0; i < vehicles.size(); i++) {
    Vehicle vehicle = vehicles.get(i);


    colorMode(HSB);
    tint(vehicle.rotation() * 255 / (2 * PI), 128, 255);

    pushMatrix();
    translate(vehicle.x(), vehicle.y());
    rotate(vehicle.rotation());
    imageMode(CENTER);
    image(chargeImage, 0, 0);
    popMatrix();
/*
    strokeWeight(2);
    stroke(255);
    line(vehicle.x(), vehicle.y(),
        vehicle.x() + 20 * cos(vehicle.rotation()),
        vehicle.y() + 20 * sin(vehicle.rotation()));

    strokeWeight(1);
    stroke(64);
    noFill();
    ellipseMode(CENTER);
    ellipse(vehicle.x(), vehicle.y(), Vehicle.MIN_NEIGHBOR_DIST, Vehicle.MIN_NEIGHBOR_DIST);
*/
  }

  world.step();
}

int deg(float v) {
  return floor(v * 180/PI);
}

void keyReleased() {
  switch (key) {
    case 'e':
      reset();
      break;
    case 'r':
      save("render.png");
      break;
    case ' ':
      isPaused = !isPaused;
      break;
  }
}
