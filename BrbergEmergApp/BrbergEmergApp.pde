
int imageWidth;
int imageHeight;
int numGroups;

World world;
WorldDrawer drawer;
BrbergEmergImage buffer;
boolean isPaused;
boolean showAttractors;

CenteredPositioner centeredPositioner;
CustomPositioner customPositioner;
DartboardAttractorPositioner dartboardAttractorPositioner;
RandomPositioner randomPositioner;
RingPositioner ringPositioner;
PFont paramFont;

FileNamer animationFolderNamer, fileNamer;

void setup() {
  size(1080, 1080, P3D);

  imageWidth = 1080;
  imageHeight = 1080;
  numGroups = 3;

  world = new World(imageWidth, imageHeight, numGroups);
  drawer = new WorldDrawer();
  buffer = new BrbergEmergImage(imageWidth, imageHeight, ARGB);
  isPaused = false;
  showAttractors = true;

  animationFolderNamer = new FileNamer("output/anim", "/");
  fileNamer = new FileNamer("output/export", "png");

  centeredPositioner = new CenteredPositioner(world);
  customPositioner = new CustomPositioner(world);
  dartboardAttractorPositioner = new DartboardAttractorPositioner(world)
    .rect(imageWidth * 0.15, imageWidth * 0.85, imageHeight * 0.15, imageHeight * 0.85);
  randomPositioner = new RandomPositioner(world);
  ringPositioner = new RingPositioner(world)
    .numPositions(numGroups);
  paramFont = loadFont("InputSansNarrow-Regular-24.vlw");

  reset();
}

void reset() {
  resetWorld();
  buffer.clear();
}

void resetWorld() {
  world.age(0);
  world.clearAttractors();
  world.clearVehicles();
  world.setupAttractors(dartboardAttractorPositioner, numGroups);
  world.setupVehicles(randomPositioner, 400);
}

void draw() {
  if (!isPaused) {
    world.step();

    buffer.fade(0.001);
    drawer.draw(buffer, world);

    image(buffer.getImageRef(), 0, 0);

    if (showAttractors) {
      drawer.drawAttractors(g, world);
    }
  }
}

void clear() {
  buffer.clear();
}

void keyReleased() {
  switch (key) {
    case '1':
      world.step(10);
      break;
    case '2':
      world.step(100);
      break;
    case '3':
      world.step(1000);
      break;
    case '4':
      world.step(5000);
      break;
    case 'a':
      saveAnimation(1000);
      break;
    case 'b':
      clear();
      world.age(0);
      break;
    case 'e':
      clear();
      reset();
      break;
    case 'r':
      buffer.getImageRef().save(fileNamer.next());
      break;
    case 't':
      showAttractors = !showAttractors;
      break;
    case ' ':
      isPaused = !isPaused;
      break;
  }
}

void saveAnimation(int numFrames) {
  isPaused = true;

  FileNamer frameNamer = new FileNamer(animationFolderNamer.next() + "frame", "png");
  for (int i = 0; i < numFrames; i++) {
    world.step();

    buffer.fade(0.001);
    drawer.draw(buffer, world);

    buffer.getImageRef().save(frameNamer.next());
  }

  isPaused = false;
}

///

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

float getAverageRotation(ArrayList<Vehicle> vehicles) {
  if (vehicles.size() <= 0) {
    return 0;
  }

  PVector sum = new PVector();
  for (Vehicle vehicle : vehicles) {
    float r = vehicle.rotation();
    sum.add(cos(r), sin(r));
  }

  return normalizeAngle(atan2(sum.y, sum.x));
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

ArrayList<? extends IPositioned> getItemsWithin(ArrayList<? extends IPositioned> items, IPositioned target, float distance) {
  ArrayList<IPositioned> result = new ArrayList<IPositioned>();
  for (IPositioned item : items) {
    if (getDistanceBetween(target, item) < distance) {
      result.add(item);
    }
  }
  return result;
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
  float dx = bx - ax;
  float dy = by - ay;
  return normalizeAngle(atan2(dy, dx));
}

float getSignedAngleBetween(float angleA, float angleB) {
  float delta = angleB - angleA;

  if (abs(delta) > PI) {
    if (delta > 0) {
      return -2 * PI + delta;
    }
    return 2 * PI + delta;
  }
  return delta;
}

float getRotationToward(float current, float target, float factor) {
  return getRotationToward(current, target, factor, 0);
}

float getRotationToward(float current, float target, float factor, float maxDelta) {
  return normalizeAngle(current + getRotationDeltaToward(current, target, factor, maxDelta));
}

float getRotationDeltaToward(float current, float target, float factor, float maxDelta) {
  float delta = getSignedAngleBetween(current, target) * factor;
  if (maxDelta != 0) {
    delta = constrain(delta, -maxDelta, maxDelta);
  }
  return delta;
}

float normalizeAngle(float v) {
  while (v < 0) {
    v += 2 * PI;
  }
  return v % (2 * PI);
}

