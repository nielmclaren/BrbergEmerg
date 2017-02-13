
PImage chargeImage;
World world;
WorldDrawer drawer;
boolean isPaused;

CenteredPositioner centeredPositioner;
DartboardAttractorPositioner dartboardAttractorPositioner;
RandomPositioner randomPositioner;
PFont paramFont;

FileNamer animationFolderNamer, fileNamer;

void setup() {
  size(800, 800, P3D);

  world = new World(width, height);
  drawer = new WorldDrawer();
  isPaused = false;

  animationFolderNamer = new FileNamer("output/anim", "/");
  fileNamer = new FileNamer("output/export", "png");

  centeredPositioner = new CenteredPositioner(world);
  dartboardAttractorPositioner = new DartboardAttractorPositioner(world)
    .rect(width/2 - 200, width/2 + 200, height/2 - 200, height/2 + 200);
  randomPositioner = new RandomPositioner(world)
    .rect(width/2 - 100, width/2 + 100, height/2 - 100, height/2 + 100);
  paramFont = loadFont("InputSansNarrow-Regular-24.vlw");


  reset();
}

void reset() {
  resetWorld();

  background(0);
  drawer.drawInitial(g, world);
}

void resetWorld() {
  world.age(0);
  world.clearAttractors();
  world.clearVehicles();
  world.setupAttractors(dartboardAttractorPositioner, 3);
  world.setupVehicles(randomPositioner, 200, 8);
  world.calculateNearestAttractors();
}

void draw() {
  if (!isPaused) {
    world.step();
    drawer.draw(g, world);
  }
}

void keyReleased() {
  switch (key) {
    case 'a':
      saveAnimation(100);
      break;
    case 'b':
      background(0);
      break;
    case 'e':
      reset();
      break;
    case 'f':
      saveParamSpace();
      break;
    case 'r':
      save(fileNamer.next());
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

