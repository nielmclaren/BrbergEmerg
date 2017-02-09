
PImage chargeImage;
World world;
WorldDrawer drawer;
boolean isPaused;

CenteredPositioner positioner;
PFont paramFont;

FileNamer animationFolderNamer, fileNamer;

void setup() {
  size(600, 600, P3D);

  world = new World(width, height);
  drawer = new WorldDrawer();
  isPaused = false;

  animationFolderNamer = new FileNamer("output/anim", "/");
  fileNamer = new FileNamer("output/export", "png");

  positioner = new CenteredPositioner().world(world);
  paramFont = loadFont("InputSansNarrow-Regular-24.vlw");


  reset();
}

void reset() {
  resetWorld();

  background(0);
  drawer.drawInitial(g, world);
}

void resetWorld() {
  world.clearAttractors();
  world.clearVehicles();
  world.setupAttractors(positioner, 7);
  world.setupVehicles(positioner, 1, 8);
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
  FileNamer namer = new FileNamer(animationFolderNamer.next() + "frame", "png");
  for (float maxDelta = 0.1; maxDelta < 1; maxDelta += 0.1) {
    for (float noiseScale = 0.1; noiseScale < 1; noiseScale += 0.1) {
      saveParam(maxDelta, noiseScale, namer.next());
    }
  }
}

void saveParam(float maxDelta, float noiseScale, String savePath) {
  PGraphics canvas = createGraphics(width, height, P3D);
  canvas.beginDraw();


  float quarterW = canvas.width/4;
  float quarterH = canvas.height/4;
  for (int i = 0; i < 16; i++) {
    drawWorld(canvas,
        (i % 4) * quarterW, floor(i / 4) * quarterH,
        quarterW, quarterH, maxDelta, noiseScale);
  }

  canvas.fill(255);
  canvas.textFont(paramFont);
  canvas.text("Max delta: " + (float)floor(maxDelta * 100) / 100, 20, 30);
  canvas.text("Noise scale: " + (float)floor(noiseScale * 100) / 100, 20, 60);

  canvas.endDraw();
  canvas.save(savePath);
}

void drawWorld(PGraphics g, float x, float y, float w, float h, float maxDelta, float noiseScale) {
  PGraphics drawWorldCanvas = createGraphics(width, height, P3D);

  resetWorld();

  MeanderImpulse impulse = (MeanderImpulse)world.vehiclesRef().get(0).impulsesRef().get(0);
  impulse
    .maxDelta(maxDelta)
    .noiseScale(noiseScale);

  drawWorldCanvas.beginDraw();

  drawer.drawInitial(drawWorldCanvas, world);

  for (int i = 0; i < 1000; i++) {
    world.step();
    drawer.draw(drawWorldCanvas, world);
  }

  drawWorldCanvas.endDraw();

  g.image(drawWorldCanvas, x, y, w, h);
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

