
PVector point;
float velocity;
float rotation;
float minDist;

int minX;
int minY;
int maxX;
int maxY;

boolean isTurningCw;
boolean isTurningCcw;

FileNamer fileNamer;

void setup() {
  size(800, 800);
  background(0);

  point = new PVector(width/2, height/2);
  velocity = 3;
  rotation = 0;
  minDist = 60;
  isTurningCw = false;
  isTurningCcw = false;

  minX = floor(0.25 * width);
  minY = floor(0.25 * height);
  maxX = floor(0.75 * width);
  maxY = floor(0.75 * height);

  fileNamer = new FileNamer("output/export", "png");
}

void draw() {
  int radius = 5;
  int length = 15;

  noFill();
  stroke(32);
  rect(minX, minY, maxX - minX, maxY - minY);

  color c;
  if (isTurningCw) {
    c = color(255, 0, 0);
  } else if (isTurningCcw) {
    c = color(0, 0, 255);
  } else {
    c = color(255);
  }

  noStroke();
  fill(c);
  ellipse(point.x, point.y, radius, radius);

  stroke(c);
  strokeWeight(2);
  line(point.x, point.y, point.x - length * cos(rotation), point.y - length * sin(rotation));

  rotation += steer(point, rotation);

  point.x += velocity * cos(rotation);
  point.y += velocity * sin(rotation);
}

float steer(PVector point, float rotation) {
  float steerAmount = 0.3;
  float rx = getHorizontalRotationFactor(point, rotation);
  float ry = getVerticalRotationFactor(point, rotation);

  if (rx == 0 && ry == 0) {
    isTurningCw = false;
    isTurningCcw = false;
    return 0;
  } else {
    if (isTurningCw) {
      return -abs(steerAmount * (rx + ry));
    } else if (isTurningCcw) {
      return abs(steerAmount * (rx + ry));
    } else {
      float d = abs(rx) > abs(ry) ? rx : ry;
      if (d < 0) {
        isTurningCw = true;
        return -abs(steerAmount * (rx + ry));
      } else {
        isTurningCcw = true;
        return abs(steerAmount * (rx + ry));
      }
    }
  }
}

// Returns a number between -1 and 1 indicating how much and in which direction
// the left and right boundaries want to influence the boid's rotation.
float getHorizontalRotationFactor(PVector point, float rotation) {
  float distanceFactor;
  if (point.x + minDist > maxX) {
    distanceFactor = ((point.x + minDist) - maxX) / minDist;
    if (normalizeAngle(rotation) < PI) {
      return distanceFactor;
    }
    return -distanceFactor;
  } else if (point.x - minDist < minX) {
    distanceFactor = (minX - (point.x - minDist)) / minDist;
    if (normalizeAngle(rotation + PI) < PI) {
      return distanceFactor;
    }
    return -distanceFactor;
  }
  return 0;
}

// Returns a number between -1 and 1 indicating how much and in which direction
// the top and bottom boundaries want to influence the boid's rotation.
float getVerticalRotationFactor(PVector point, float rotation) {
  float distanceFactor;
  if (point.y + minDist > maxY) {
    distanceFactor = ((point.y + minDist) - maxY) / minDist;
    if (normalizeAngle(rotation - PI/2) < PI) {
      return distanceFactor;
    }
    return -distanceFactor;
  } else if (point.y - minDist < minY) {
    distanceFactor = (minY - (point.y - minDist)) / minDist;
    if (normalizeAngle(rotation + PI/2) < PI) {
      return distanceFactor;
    }
    return -distanceFactor;
  }
  return 0;
}

float normalizeAngle(float v) {
  while (v < 0) {
    v += 2 * PI;
  }
  return v % (2 * PI);
}

void keyReleased() {
  switch (key) {
    case 'e':
      background(0);
      point = new PVector(width/2, height/2);
      rotation = PI/4 + random(-0.02, 0.02);
      break;
    case 'r':
      save(fileNamer.next());
      break;
  }
}
