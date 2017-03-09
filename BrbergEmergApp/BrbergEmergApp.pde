
int imageWidth;
int imageHeight;
int numGroups;

World world;
WorldDrawer drawer;
PGraphics buffer;
ShortImage shortBuffer;
boolean isPaused;

CenteredPositioner centeredPositioner;
CustomPositioner customPositioner;
DartboardAttractorPositioner dartboardAttractorPositioner;
RandomPositioner randomPositioner;
RingPositioner ringPositioner;
PFont paramFont;

FileNamer animationFolderNamer, fileNamer;

void setup() {
  size(1600, 800, P3D);

  imageWidth = 800;
  imageHeight = 800;
  numGroups = 1;

  world = new World(imageWidth, imageHeight, numGroups);
  drawer = new WorldDrawer();
  buffer = createGraphics(imageWidth, imageHeight, P3D);
  shortBuffer = new ShortImage(imageWidth, imageHeight);
  isPaused = false;

  animationFolderNamer = new FileNamer("output/anim", "/");
  fileNamer = new FileNamer("output/export", "png");

  centeredPositioner = new CenteredPositioner(world);
  customPositioner = new CustomPositioner(world);
  dartboardAttractorPositioner = new DartboardAttractorPositioner(world)
    .rect(imageWidth/2 - 300, imageWidth/2 + 300, imageHeight/2 - 300, imageHeight/2 + 300);
  randomPositioner = new RandomPositioner(world)
    .rect(imageWidth/2 - 100, imageWidth/2 + 100, imageHeight/2 - 100, imageHeight/2 + 100);
  ringPositioner = new RingPositioner(world)
    .numPositions(numGroups);
  paramFont = loadFont("InputSansNarrow-Regular-24.vlw");

  reset();
}

void reset() {
  resetWorld();

  buffer.beginDraw();
  drawer.drawInitial(buffer, world);
  buffer.endDraw();

  shortBuffer.setImage(buffer);
}

void resetWorld() {
  world.age(0);
  world.clearAttractors();
  world.clearVehicles();
  world.setupAttractors(centeredPositioner, numGroups);
  world.setupVehicles(customPositioner, 300);
}

void draw() {
  if (!isPaused) {
    world.step();

    buffer.beginDraw();
    drawer.draw(buffer, world);
    buffer.endDraw();

    image(buffer, 0, 0);

    shortBuffer.addImage(buffer);
    shortBuffer.fade(0.01);
    PImage outputImage = shortBuffer.getImageRef();
    image(outputImage, imageWidth, 0);
  }
}

void clear() {
  background(0);
  buffer.background(0);
  shortBuffer.setImage(buffer);
}

private int shortToFloat(int v) {
  return floor(((float)v - Short.MIN_VALUE) / (Short.MAX_VALUE - Short.MIN_VALUE) * 255);
}

private short byteToShort(float v) {
  return (short)((float)v / 255 * (Short.MAX_VALUE - Short.MIN_VALUE - 1) + Short.MIN_VALUE);
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
      world.step(10000);
      break;
    case 'a':
      saveAnimation(100);
      break;
    case 'b':
      clear();
      world.age(0);
      break;
    case 'e':
      clear();
      reset();
      break;
    case 'f':
      saveParamSpace();
      break;
    case 'r':
      PImage outputImage = shortBuffer.getImageRef();
      outputImage.save(fileNamer.next());
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
    drawer.draw(g, world);
    save(frameNamer.next());
  }

  isPaused = false;
}

void saveParamSpace() {
  PGraphics canvas = createGraphics(3600, 3600, P3D);

  int numCols = 12;
  int numRows = 12;
  float w = (float)canvas.width / numCols;
  float h = (float)canvas.height / numRows;
  for (int col = 0; col < numCols; col++) {
    for (int row = 0; row < numRows; row++) {
      float maxDelta = map(col, 0, numCols, 0.01, 0.3);
      float noiseScale = map(pow((float)row / numRows, 4), 0, 1, 0.05, 5.0);
      drawWorld(canvas, col * w, row * h, w, h, maxDelta, noiseScale);
    }
  }

  canvas.save(fileNamer.next());
}

void drawWorld(PGraphics graphics, float x, float y, float w, float h, float maxDelta, float noiseScale) {
  PGraphics drawWorldCanvas = createGraphics(600, 600, P3D);

  resetWorld();
  world.meander
    .maxDelta(maxDelta)
    .noiseScale(noiseScale);

  drawWorldCanvas.beginDraw();
  drawWorldCanvas.background(0);

  drawer.drawInitial(drawWorldCanvas, world);

  for (int i = 0; i < 1000; i++) {
    world.step();
    drawer.draw(drawWorldCanvas, world);
  }

  drawWorldCanvas.beginDraw();
  drawWorldCanvas.fill(255);
  drawWorldCanvas.textFont(paramFont);
  drawWorldCanvas.text("Max delta: " + (float)floor(maxDelta * 100) / 100, 20, 30);
  drawWorldCanvas.text("Noise scale: " + (float)floor(noiseScale * 100) / 100, 20, 60);
  drawWorldCanvas.endDraw();

  drawWorldCanvas.endDraw();

  graphics.beginDraw();
  graphics.image(drawWorldCanvas, x, y, w, h);
  graphics.endDraw();
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

