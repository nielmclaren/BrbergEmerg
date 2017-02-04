
PImage chargeImage;
World world;
boolean isPaused;

FileNamer fileNamer;

void setup() {
  size(800, 800);

  chargeImage = loadImage("charge-t.png");
  world = new World(width, height);
  isPaused = false;

  fileNamer = new FileNamer("output/export", "png");

  reset();
}

void reset() {
  world.clearAttractors();
  world.clearVehicles();
  world.setupAttractors(5);
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

  ArrayList<Attractor> attractors = world.attractorsRef();
  for (int i = 0; i < attractors.size(); i++) {
    Attractor attractor = attractors.get(i);

    colorMode(RGB);
    stroke(64);
    fill(16);
    ellipseMode(RADIUS);
    ellipse(attractor.x(), attractor.y(), attractor.radius(), attractor.radius());
  }

  ArrayList<Vehicle> vehicles = world.vehiclesRef();

  for (int i = 0; i < vehicles.size(); i++) {
    Vehicle vehicle = vehicles.get(i);

    colorMode(HSB);
    tint(vehicle.rotation() * 255 / (2 * PI), 128, 255);

    if (false) {
      pushMatrix();
      translate(vehicle.x(), vehicle.y());
      rotate(vehicle.rotation());
      imageMode(CENTER);
      image(chargeImage, 0, 0);
      popMatrix();
    } else {
      strokeWeight(2);
      stroke(255);
      line(vehicle.x(), vehicle.y(),
          vehicle.x() + 20 * cos(vehicle.rotation()),
          vehicle.y() + 20 * sin(vehicle.rotation()));

      //strokeWeight(1);
      //stroke(64);
      //noFill();
      //ellipseMode(CENTER);
      //ellipse(vehicle.x(), vehicle.y(), Vehicle.MIN_NEIGHBOR_DIST, Vehicle.MIN_NEIGHBOR_DIST);
    }
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
      save(fileNamer.next());
      break;
    case ' ':
      isPaused = !isPaused;
      break;
  }
}



float distanceBetween(IPositioned a, IPositioned b) {
  float dx = b.x() - a.x();
  float dy = b.y() - a.y();
  return sqrt(dx * dx + dy * dy);
}

float getAngleTo(IPositioned a, IPositioned b) {
  float dx = a.x() - b.x();
  float dy = a.y() - b.y();
  return normalizeAngle(atan2(dy, dx));
}

float normalizeAngle(float v) {
  while (v < 0) {
    v += 2 * PI;
  }
  return v % (2 * PI);
}

