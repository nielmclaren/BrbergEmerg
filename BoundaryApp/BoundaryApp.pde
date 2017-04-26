
PVector point;
float velocity;
float rotation;
float minDist;
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

  fileNamer = new FileNamer("output/export", "png");
}

void draw() {
  int radius = 2;
  int length = 5;

  noFill();
  stroke(32);
  rect(0.25 * width, 0.25 * height, 0.5 * width, 0.5 * height);

  noStroke();
  fill(255);
  ellipse(point.x, point.y, radius, radius);

  if (isTurningCw) {
    stroke(255, 0, 0);
  } else if (isTurningCcw) {
    stroke(0, 0, 255);
  } else {
    stroke(255);
  }

  strokeWeight(2);
  line(point.x, point.y, point.x - length * cos(rotation), point.y - length * sin(rotation));

  rotation += steer(point, rotation);

  point.x += velocity * cos(rotation);
  point.y += velocity * sin(rotation);
}

float steer(PVector point, float rotation) {
  float steerAmount = 0.3;
  float dx = getDx(point, rotation) / minDist;
  float dy = getDy(point, rotation) / minDist;

  if (dx == 0 && dy == 0) {
    isTurningCw = false;
    isTurningCcw = false;
  } else {
    if (isTurningCw) {
      return -abs(steerAmount * (dx + dy));
    } else if (isTurningCcw) {
      return abs(steerAmount * (dx + dy));
    } else {
      float d = abs(dx) > abs(dy) ? dx : dy;
      if (d < 0) {
        isTurningCw = true;
        return -abs(steerAmount * (dx + dy));
      } else {
        isTurningCcw = true;
        return abs(steerAmount * (dx + dy));
      }
    }
  }

  if (dx != 0 && dy != 0) {
    if (abs(dx) > abs(dy)) {
      return 2 * steerAmount * dy;
    } else {
      return 2 * steerAmount * dx;
    }
  }
  return steerAmount * dx + steerAmount * dy;
}

float getDx(PVector point, float rotation) {
  float dx;
  if (point.x + minDist > 0.75 * width) {
    dx = (point.x + minDist) - 0.75 * width;
    if (normalizeAngle(rotation) < PI) {
      return dx;
    }
    return -dx;
  } else if (point.x - minDist < 0.25 * width) {
    dx = 0.25 * width - (point.x - minDist);
    if (normalizeAngle(rotation + PI) < PI) {
      return dx;
    }
    return -dx;
  }
  return 0;
}

float getDy(PVector point, float rotation) {
  float dy;
  if (point.y + minDist > 0.75 * height) {
    dy = (point.y + minDist) - 0.75 * height;
    if (normalizeAngle(rotation - PI/2) < PI) {
      return dy;
    }
    return -dy;
  } else if (point.y - minDist < 0.25 * height) {
    dy = 0.25 * height - (point.y - minDist);
    if (normalizeAngle(rotation + PI/2) < PI) {
      return dy;
    }
    return -dy;
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
