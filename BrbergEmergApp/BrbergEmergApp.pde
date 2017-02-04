
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
  world.setupVehicles(20);
  world.calculateNeighborhoods();
}

void draw() {
  if (!isPaused) {
    redraw();
  }
}

void redraw() {
  background(0);

  int selectedIndex = 0;

  if (true) {
    ArrayList<Attractor> attractors = world.attractorsRef();
    for (int i = 0; i < attractors.size(); i++) {
      Attractor attractor = attractors.get(i);

      colorMode(RGB);
      stroke(64);
      fill(16);
      ellipseMode(RADIUS);
      ellipse(attractor.x(), attractor.y(), attractor.radius(), attractor.radius());
    }
  }

  ArrayList<Vehicle> vehicles = world.vehiclesRef();

  blendMode(LIGHTEST);
  for (int i = 0; i < vehicles.size(); i++) {
    Vehicle vehicle = vehicles.get(i);

    colorMode(HSB);
    tint(vehicle.rotation() * 255 / (2 * PI), 128, 255);

    if (false) {
      pushMatrix();
      translate(vehicle.x(), vehicle.y());
      rotate(vehicle.rotation() + 80 * PI / 180);
      imageMode(CENTER);
      image(chargeImage, 0, 0);
      popMatrix();
    } else {
      if (i == selectedIndex) {
        strokeWeight(8);
        stroke(255);
      } else {
        strokeWeight(2);
        stroke(255);
      }

      line(vehicle.x(), vehicle.y(),
          vehicle.x() + 20 * cos(vehicle.rotation()),
          vehicle.y() + 20 * sin(vehicle.rotation()));

      //strokeWeight(1);
      //stroke(64);
      //noFill();
      //ellipseMode(CENTER);
      //ellipse(vehicle.x(), vehicle.y(), Vehicle.MIN_NEIGHBOR_DIST, Vehicle.MIN_NEIGHBOR_DIST);
    }

    if (i == selectedIndex) {
      // Draw minimum distance circle
      strokeWeight(1);
      stroke(64);
      fill(16);
      ellipseMode(RADIUS);
      ellipse(vehicle.x(), vehicle.y(), Vehicle.MIN_DISTANCE, Vehicle.MIN_DISTANCE);

      ArrayList<Vehicle> tooCloseVehicles = vehicle.neighborhoodRef().getTooCloseVehicles(vehicle);
      if (tooCloseVehicles.size() > 0) {
        PVector averagePos = getAveragePosition(tooCloseVehicles);
        if (getDistanceBetween(vehicle, averagePos) > 0) {
          float tooCloseDirection = getAngleTo(vehicle, averagePos);
          println(vehicle.x(), vehicle.y(), averagePos);

          fill(255);
          stroke(0);
          ellipseMode(RADIUS);
          ellipse(averagePos.x, averagePos.y, 5, 5);
        }
      }
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

PVector getAveragePosition(ArrayList<? extends IPositioned> items) {
  if (items.size() <= 0) {
    return null;
  }

  PVector result = new PVector();
  for (int i = 0; i < items.size(); i++) {
    IPositioned item = items.get(i);
    result.x += item.x();
    result.y += item.y();
  }
  result.div(items.size());
  return result;
}

IPositioned getNearestTo(ArrayList<? extends IPositioned> items, IPositioned target) {
  float nearestDist = Float.MAX_VALUE;
  IPositioned nearest = null;

  for (int i = 0; i < items.size(); i++) {
    IPositioned item = items.get(i);
    float dist = getDistanceBetween(item, target);

    if (dist < nearestDist) {
      nearestDist = dist;
      nearest = item;
    }
  }

  return nearest;
}

float getDistanceBetween(IPositioned a, IPositioned b) {
  return getDistanceBetween(a.x(), a.y(), b.x(), b.y());
}

float getDistanceBetween(PVector a, IPositioned b) {
  return getDistanceBetween(a.x, a.y, b.x(), b.y());
}

float getDistanceBetween(IPositioned a, PVector b) {
  return getDistanceBetween(a.x(), a.y(), b.x, b.y);
}

float getDistanceBetween(PVector a, PVector b) {
  return getDistanceBetween(a.x, a.y, b.x, b.y);
}

float getDistanceBetween(float ax, float ay, float bx, float by) {
  float dx = bx - ax;
  float dy = by - ay;
  return sqrt(dx * dx + dy * dy);
}

float getAngleTo(IPositioned a, IPositioned b) {
  return getAngleTo(a.x(), a.y(), b.x(), b.y());
}

float getAngleTo(PVector a, IPositioned b) {
  return getAngleTo(a.x, a.y, b.x(), b.y());
}

float getAngleTo(IPositioned a, PVector b) {
  return getAngleTo(a.x(), a.y(), b.x, b.y);
}

float getAngleTo(PVector a, PVector b) {
  return getAngleTo(a.x, a.y, b.x, b.y);
}

float getAngleTo(float ax, float ay, float bx, float by) {
  float dx = ax - bx;
  float dy = ay - by;
  return normalizeAngle(atan2(dy, dx));
}

float getRotationToward(float current, float target, float factor) {
  return getRotationToward(current, target, factor, 0);
}

float getRotationToward(float current, float target, float factor, float maxDelta) {
  float delta = target - current;
  float result;

  if (abs(delta) > PI) {
    if (delta > 0) {
      delta = -2 * PI + delta;
    } else {
      delta = 2 * PI + delta;
    }
  }
  delta = delta * factor;
  if (maxDelta > 0) {
    delta = constrain(delta, -maxDelta, maxDelta);
  }
  result = current - delta;

  return normalizeAngle(result);
}

float normalizeAngle(float v) {
  while (v < 0) {
    v += 2 * PI;
  }
  return v % (2 * PI);
}

