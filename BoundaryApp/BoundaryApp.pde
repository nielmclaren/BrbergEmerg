
PVector point;
float velocity;
float rotation;
float lookAheadDist;
float minDist;

int minX;
int minY;
int maxX;
int maxY;

boolean isTurningCw;
boolean isTurningCcw;
int noTurnCount;
int turnDuration;

boolean isPaused;

FileNamer fileNamer;

void setup() {
  size(800, 800);
  background(0);

  point = getInitialPoint();
  velocity = 3;
  rotation = getInitialRotation();
  lookAheadDist = 60;
  minDist = 60;
  isTurningCw = false;
  isTurningCcw = false;
  noTurnCount = 0;
  turnDuration = 20;

  isPaused = false;

  minX = floor(0.25 * width);
  minY = floor(0.25 * height);
  maxX = floor(0.75 * width);
  maxY = floor(0.75 * height);

  fileNamer = new FileNamer("output/export", "png");
}

void draw() {
  if (isPaused) return;

  int radius = 5;
  int length = 15;

  noFill();
  strokeWeight(2);
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

  rotation = normalizeAngle(rotation + steer());

  point.x += velocity * cos(rotation);
  point.y += velocity * sin(rotation);
}

float steer() {
  int safety = 5;

  if (point.x > maxX) {
    point.x = maxX - safety;
    return mirrorRotationHorizontally(rotation) - rotation;
  } else if (point.x < minX) {
    point.x = minX + safety;
    return mirrorRotationHorizontally(rotation) - rotation;
  }

  if (point.y > maxY) {
    point.y = maxY - safety;
    return mirrorRotationVertically(rotation) - rotation;
  } else if (point.y < minY) {
    point.y = minY + safety;
    return mirrorRotationVertically(rotation) - rotation;
  }

  float rx = getLookAheadHorizontalRotationFactor(point, rotation);
  float ry = getLookAheadVerticalRotationFactor(point, rotation);
  float v = map(abs(rx) + abs(ry), 0, 2, 0, PI/4);

  if (rx == 0 && ry == 0) {
    if (noTurnCount > turnDuration) {
      isTurningCw = false;
      isTurningCcw = false;
    }
    noTurnCount++;
    return 0;
  } else {
    noTurnCount = 0;
    if (isTurningCw) {
      return -v;
    } else if (isTurningCcw) {
      return v;
    } else {
      float d = abs(rx) > abs(ry) ? rx : ry;
      if (d < 0) {
        isTurningCw = true;
        return -v;
      } else {
        isTurningCcw = true;
        return v;
      }
    }
  }
}

float mirrorRotationHorizontally(float r) {
  if (r < PI) {
    return PI - r;
  }
  return 3 * PI - r;
}

float mirrorRotationVertically(float r) {
  return 2 * PI - r;
}

// Returns a number between -1 and 1 indicating how much and in which direction
// the boid should turn based on a projected collision with the left and right boundaries.
float getLookAheadHorizontalRotationFactor(PVector point, float rotation) {
  float dx;
  float dist;
  float distanceFactor;
  float x = point.x + lookAheadDist * cos(rotation);

  if (x > maxX && cos(rotation) > 0) {
    // Right boundary.
    dx = maxX - point.x;
    dist = dx / cos(rotation);
    distanceFactor = reverseDistanceFactor(dist / lookAheadDist);

    strokeWeight(4);
    stroke(255, 255, 0, 128);
    line(point.x, point.y, point.x + dx, point.y + dx * tan(rotation));

    if (normalizeAngle(rotation) < PI) {
      // Turning right (down).
      if (point.y + minDist > maxY) {
        return -distanceFactor;
      }
      return distanceFactor;
    }

    // Turning left (up).
    if (point.y - minDist < minY) {
      return distanceFactor;
    }
    return -distanceFactor;
  } else if (x < minX && cos(rotation) < 0) {
    // Left boundary.
    dx = point.x - minX;
    dist = dx / cos(rotation);
    distanceFactor = reverseDistanceFactor(dist / lookAheadDist);

    strokeWeight(4);
    stroke(255, 255, 0, 128);
    line(point.x, point.y, point.x - dx, point.y - dx * tan(rotation));

    if (normalizeAngle(rotation + PI) < PI) {
      // Turning right (up).
      if (point.y - minDist < minY) {
        return distanceFactor;
      }
      return -distanceFactor;
    }

    // Turning left (down).
    if (point.y + minDist > maxY) {
      return -distanceFactor;
    }
    return distanceFactor;
  }
  return 0;
}

// Returns a number between -1 and 1 indicating how much and in which direction
// the boid should turn based on a projected collision with the top and bottom boundaries.
float getLookAheadVerticalRotationFactor(PVector point, float rotation) {
  float dy;
  float dist;
  float distanceFactor;
  float x = point.x + lookAheadDist * cos(rotation);
  float y = point.y + lookAheadDist * sin(rotation);

  if (y > maxY && sin(rotation) > 0) {
    // Bottom boundary.
    dy = maxY - point.y;
    dist = dy / sin(rotation);
    distanceFactor = reverseDistanceFactor(dist / lookAheadDist);

    strokeWeight(4);
    stroke(255, 255, 0, 128);
    line(point.x, point.y, point.x + dy / tan(rotation), point.y + dy);

    if (normalizeAngle(rotation - PI/2) < PI) {
      // Turning right (to screen left).
      if (point.x - minDist < minX) {
        return -distanceFactor;
      }
      return distanceFactor;
    }

    // Turning left (to screen right).
    if (point.x + minDist > maxX) {
      return distanceFactor;
    }
    return -distanceFactor;
  } else if (y < minY && sin(rotation) < 0) {
    // Top boundary.
    dy = point.y - minY;
    dist = dy / sin(rotation);
    distanceFactor = reverseDistanceFactor(dist / lookAheadDist);

    strokeWeight(4);
    stroke(255, 255, 0, 128);
    line(point.x, point.y, point.x - dy / tan(rotation), point.y - dy);

    if (normalizeAngle(rotation + PI/2) < PI) {
      // Turning right (to screen right).
      if (point.x + minDist > maxX) {
        return distanceFactor;
      }
      return -distanceFactor;
    }

    // Turning left (to screen left).
    if (point.x - minDist < minX) {
      return -distanceFactor;
    }
    return distanceFactor;
  }
  return 0;
}

float reverseDistanceFactor(float d) {
  return d / abs(d) * (1 - abs(d));
}

// Returns a number between -1 and 1 indicating how much and in which direction
// the boid should turn based on its distance to the left and right boundaries.
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
// the boid should turn based on its distance to the top and bottom boundaries.
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

String deg(float v) {
  return "" + floor(v * 180 / PI * 10) / 10;
}

void keyReleased() {
  switch (key) {
    case ' ':
      isPaused = !isPaused;
      break;
    case 'e':
      background(0);
      point = getInitialPoint();
      rotation = getInitialRotation();
      break;
    case 'r':
      save(fileNamer.next());
      break;
  }
}

PVector getInitialPoint() {
  return new PVector(random(minX, maxX), random(minY, maxY));
}

float getInitialRotation() {
  return random(2 * PI);
}
