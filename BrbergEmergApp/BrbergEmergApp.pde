
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
  world.setupVehicles();
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

    float neighborhoodRotation = vehicle.neighborhoodRef().getAveragePrevRotation();
    vehicle.rotation(getRotationToward(vehicle.rotation(), neighborhoodRotation));

    pushMatrix();
    translate(vehicle.x(), vehicle.y());
    rotate(vehicle.rotation());
    imageMode(CENTER);
    image(chargeImage, 0, 0);
    popMatrix();
  }

  world.update();
}

float getRotationToward(float current, float target) {
  float factor = 0.1;
  float originalDelta = target - current;
  float result;

  float delta = originalDelta;
  if (abs(delta) > PI) {
    if (delta > 0) {
      delta = -2 * PI + delta;
    } else {
      delta = 2 * PI + delta;
    }
  }
  result = current + delta * factor;

  return normalizeAngle(result);
}

float normalizeAngle(float v) {
  while (v < 0) {
    v += 2 * PI;
  }
  return v % (2 * PI);
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