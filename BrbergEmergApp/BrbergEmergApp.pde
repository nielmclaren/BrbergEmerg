
import TUIO.*;

int imageWidth;
int imageHeight;
float imageScale;

World world;
WorldDrawer drawer;
BrbergEmergImage buffer;
boolean isPaused;
boolean isHighQualityMode;

CenteredPositioner centeredPositioner;
CustomPositioner customPositioner;
GroupPositioner groupPositioner;
RandomPositioner randomPositioner;
PFont paramFont;

TuioProcessing tuioClient;
FileNamer animationFolderNamer, fileNamer;

void setup() {
  noCursor();
  fullScreen();
  frameRate(60);

  imageWidth = 1920;
  imageHeight = 1080;
  imageScale = min((float)width / imageWidth, (float)height / imageHeight);

  JSONObject worldJson = loadJSONObject("data/world.json");
  world = new World(worldJson);
  drawer = new WorldDrawer();
  buffer = new BrbergEmergImage(imageWidth, imageHeight, ARGB);
  isPaused = false;
  isHighQualityMode = false;

  animationFolderNamer = new FileNamer("output/anim", "/");
  fileNamer = new FileNamer("output/export", "png");

  centeredPositioner = new CenteredPositioner(world);
  customPositioner = new CustomPositioner(world);
  groupPositioner = new GroupPositioner(world);
  randomPositioner = new RandomPositioner(world);
  paramFont = loadFont("InputSansNarrow-Regular-24.vlw");

  tuioClient  = new TuioProcessing(this);
}

void reset() {
  JSONObject worldJson = loadJSONObject("data/world.json");
  world.updateFromJson(worldJson);

  buffer.clear();
}

void draw() {
  if (!isPaused) {
    step();
  }
}

void step() {
  world.step();

  if (isHighQualityMode) {
    buffer.fade(0.001);
    drawer.draw(buffer, world);

    image(buffer.getImageRef(), 0, 0);
  } else {
    pushMatrix();
    scale(imageScale);
    translate(
        (width - imageWidth * imageScale) / 2,
        (height - imageHeight * imageScale) / 2);

    background(0);

    drawer.draw(g, world);
    popMatrix();
  }

  drawer.drawTouches(g, world);
}

void clear() {
  background(0);
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
      step();
      break;
    case 'f':
      isHighQualityMode = !isHighQualityMode;
      break;
    case 'r':
      buffer.getImageRef().save(savePath(fileNamer.next()));
      break;
    case 'w':
      writeWorld();
      break;
    case ' ':
      isPaused = !isPaused;
      break;
  }
}

void refresh(TuioTime t) {}
void addTuioObject(TuioObject o) {}
void updateTuioObject(TuioObject o) {}
void removeTuioObject(TuioObject o) {}
void addTuioBlob(TuioBlob b) {}
void updateTuioBlob(TuioBlob b) {}
void removeTuioBlob(TuioBlob b) {}

void addTuioCursor(TuioCursor tcur) {
  println("add cur "+tcur.getCursorID()+" ("+tcur.getSessionID()+ ") "
    +tcur.getX()+" "+tcur.getY());
  world.addTouch(tcur);
}

// called when a cursor is moved
void updateTuioCursor (TuioCursor tcur) {
  println("set cur "+tcur.getCursorID()+" ("+tcur.getSessionID()+ ") "
    +tcur.getX()+" "+tcur.getY()
    +" "+tcur.getMotionSpeed()+" "+tcur.getMotionAccel());
  world.updateTouch(tcur);
}

// called when a cursor is removed from the scene
void removeTuioCursor(TuioCursor tcur) {
  println("del cur "+tcur.getCursorID()+" ("+tcur.getSessionID()+")");
  world.removeTouch(tcur);
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

void writeWorld() {
  JSONObject worldJson = world.toJson();
  saveJSONObject(worldJson, "data/world.json");
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

IPositioned getNearestTo(ArrayList<? extends IPositioned> items, IPositioned target) {
  return getNearestTo(items, target.x(), target.y());
}

IPositioned getNearestTo(ArrayList<? extends IPositioned> items, float targetX, float targetY) {
  float nearestDist = Float.MAX_VALUE;
  IPositioned nearest = null;

  for (IPositioned item : items) {
    float dist = getDistanceBetween(item, targetX, targetY);

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

float getDistanceBetween(IPositioned a, float bx, float by) {
  return getDistanceBetween(a.x(), a.y(), bx, by);
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
