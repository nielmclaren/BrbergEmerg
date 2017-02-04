
PImage chargeImage;
World world;
boolean isPaused;
boolean isDebugMode;

PImage backgroundImage;
ArrayList<PImage> appIcons;

FileNamer animationFolderNamer, fileNamer;

void setup() {
  size(800, 800);

  world = new World(width, height);
  isPaused = false;
  isDebugMode = true;

  animationFolderNamer = new FileNamer("output/anim", "/");
  fileNamer = new FileNamer("output/export", "png");

  backgroundImage = loadImage("attention/background.png");
  appIcons = getAppIcons();

  reset();
}

ArrayList<PImage> getAppIcons() {
  ArrayList<PImage> result = new ArrayList<PImage>();
  result.add(loadImage("attention/facebook-128.png"));
  result.add(loadImage("attention/gmail-128.png"));
  result.add(loadImage("attention/instagram-128.png"));
  result.add(loadImage("attention/snapchat-128.png"));
  result.add(loadImage("attention/tumblr-128.png"));
  result.add(loadImage("attention/twitter-128.png"));
  result.add(loadImage("attention/youtube-128.png"));
  return result;
}

void reset() {
  world.clearAttractors();
  world.clearVehicles();
  world.setupAttractors(appIcons.size());
  world.setupVehicles(500);
  world.calculateNearestAttractors();
}

void draw() {
  if (!isPaused) {
    world.step();
    redraw();
  }
}

void redraw() {
  background(0);

  imageMode(CORNER);
  image(backgroundImage, 0, 0);

  drawAttractors();
  drawVehicles();
  drawAppIcons();
}

void drawAttractors() {
  if (isDebugMode) {
    ArrayList<Attractor> attractors = world.attractorsRef();
    for (Attractor attractor : attractors) {
      colorMode(RGB);
      stroke(64);
      fill(16);
      ellipseMode(RADIUS);
      ellipse(attractor.x(), attractor.y(), attractor.radius(), attractor.radius());
    }
  }
}

void drawVehicles() {
  ArrayList<Vehicle> vehicles = world.vehiclesRef();

  for (Vehicle vehicle : vehicles) {
    if (isDebugMode) {
      drawDebugVehicle(vehicle);
    } else {
      drawVehicle(vehicle);
    }
  }
}

void drawDebugVehicle(Vehicle vehicle) {
  stroke(32);
  strokeWeight(1);
  line(vehicle.x(), vehicle.y(),
      vehicle.nearestAttractor().x(),
      vehicle.nearestAttractor().y());

  stroke(255);
  strokeWeight(2);
  line(vehicle.x(), vehicle.y(),
      vehicle.x() + 5 * cos(vehicle.rotation()),
      vehicle.y() + 5 * sin(vehicle.rotation()));
}

void drawVehicle(Vehicle vehicle) {
  stroke(255);
  strokeWeight(2);
  line(vehicle.x(), vehicle.y(),
      vehicle.x() - 5 * cos(vehicle.rotation()),
      vehicle.y() - 5 * sin(vehicle.rotation()));

  noStroke();
  fill(255);
  ellipseMode(CENTER);
  ellipse(vehicle.x(), vehicle.y(), 4, 4);
}

void drawAppIcons() {
  if (!isDebugMode) {
    ArrayList<Attractor> attractors = world.attractorsRef();
    for (int i = 0; i < attractors.size(); i++) {
      Attractor attractor = attractors.get(i);

      imageMode(CENTER);
      image(appIcons.get(i % appIcons.size()), attractor.x(), attractor.y(), 48, 48);
    }
  }
}

void keyReleased() {
  switch (key) {
    case 'a':
      saveAnimation(100);
      break;
    case 'e':
      reset();
      break;
    case 'r':
      save(fileNamer.next());
      break;
    case 't':
      isDebugMode = !isDebugMode;
      break;
    case ' ':
      isPaused = !isPaused;
      break;
  }
}

void saveAnimation(int numFrames) {
  isPaused = true;

  boolean wasDebugMode = isDebugMode;
  isDebugMode = false;

  FileNamer frameNamer = new FileNamer(animationFolderNamer.next() + "frame", "png");
  for (int i = 0; i < numFrames; i++) {
    world.step();
    world.step();
    redraw();
    save(frameNamer.next());
  }

  isPaused = false;

  isDebugMode = wasDebugMode;
}

void mouseReleased() {
}

int deg(float v) {
  return floor(v * 180/PI);
}

PVector getAveragePosition(ArrayList<? extends IPositioned> items) {
  if (items.size() <= 0) {
    return null;
  }

  PVector result = new PVector();
  for (IPositioned item : items) {
    result.x += item.x();
    result.y += item.y();
  }
  result.div(items.size());
  return result;
}

IPositioned getNearestTo(ArrayList<? extends IPositioned> items, IPositioned target) {
  float nearestDist = Float.MAX_VALUE;
  IPositioned nearest = null;

  for (IPositioned item : items) {
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
  return normalizeAngle(current + getRotationDeltaToward(current, target, factor, maxDelta));
}

float getRotationDeltaToward(float current, float target, float factor, float maxDelta) {
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
  if (maxDelta != 0) {
    delta = constrain(delta, -maxDelta, maxDelta);
  }
  return -delta;
}

float normalizeAngle(float v) {
  while (v < 0) {
    v += 2 * PI;
  }
  return v % (2 * PI);
}

