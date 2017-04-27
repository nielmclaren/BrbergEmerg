
// Steer away from the boundaries of the world.
class BoundaryImpulse extends Impulse {
  private float _lookAheadDist;
  private float _minDist;
  private int _numTurnSteps;

  BoundaryImpulse(World world) {
    super(world);

    _lookAheadDist = 60;
    _minDist = 60;
    _numTurnSteps = 20;
  }

  float steer(Vehicle vehicle) {
    int safety = 5;
    float x = vehicle.x();
    float y = vehicle.y();
    float rotation = vehicle.rotation();
    float minX = 0;
    float maxX = _world.width();
    float minY = 0;
    float maxY = _world.height();

    if (x > maxX) {
      x = maxX - safety;
      return mirrorRotationHorizontally(rotation) - rotation;
    } else if (x < minX) {
      vehicle.x(minX + safety);
      return mirrorRotationHorizontally(rotation) - rotation;
    }

    if (y > maxY) {
      y = maxY - safety;
      return mirrorRotationVertically(rotation) - rotation;
    } else if (y < minY) {
      vehicle.y(minY + safety);
      return mirrorRotationVertically(rotation) - rotation;
    }

    float rx = getLookAheadHorizontalRotationFactor(vehicle);
    float ry = getLookAheadVerticalRotationFactor(vehicle);
    float v = map(abs(rx) + abs(ry), 0, 2, 0, PI/4);

    if (rx == 0 && ry == 0) {
      if (vehicle.numStepsSinceLastTurn() > _numTurnSteps) {
        vehicle.isTurningCw(false);
        vehicle.isTurningCcw(false);
      }
      vehicle.incrementNumStepsSinceLastTurn();

      rx = getHorizontalRotationFactor(vehicle);
      ry = getVerticalRotationFactor(vehicle);

      return 0.01 * (rx + ry);
    } else {
      vehicle.resetNumStepsSinceLastTurn();
      if (vehicle.isTurningCw()) {
        return -v;
      } else if (vehicle.isTurningCcw()) {
        return v;
      } else {
        float d = abs(rx) > abs(ry) ? rx : ry;
        if (d < 0) {
          vehicle.isTurningCw(true);
          return -v;
        } else {
          vehicle.isTurningCcw(true);
          return v;
        }
      }
    }
  }

  private float mirrorRotationHorizontally(float r) {
    if (r < PI) {
      return PI - r;
    }
    return 3 * PI - r;
  }

  private float mirrorRotationVertically(float r) {
    return 2 * PI - r;
  }

  // Returns a number between -1 and 1 indicating how much and in which direction
  // the boid should turn based on a projected collision with the left and right boundaries.
  private float getLookAheadHorizontalRotationFactor(Vehicle vehicle) {
    float dx;
    float dist;
    float distanceFactor;
    float x = vehicle.x();
    float y = vehicle.y();
    float rotation = vehicle.rotation();
    float nextX = x + _lookAheadDist * cos(rotation);
    float nextY = y + _lookAheadDist * sin(rotation);
    float minX = 0;
    float maxX = _world.width();
    float minY = 0;
    float maxY = _world.height();

    if (nextX > maxX && cos(rotation) > 0) {
      // Right boundary.
      dx = maxX - x;
      dist = dx / cos(rotation);
      distanceFactor = reverseDistanceFactor(dist / _lookAheadDist);

      if (normalizeAngle(rotation) < PI) {
        // Turning right (down).
        if (y + _minDist > maxY) {
          return -distanceFactor;
        }
        return distanceFactor;
      }

      // Turning left (up).
      if (y - _minDist < minY) {
        return distanceFactor;
      }
      return -distanceFactor;
    } else if (nextX < minX && cos(rotation) < 0) {
      // Left boundary.
      dx = x - minX;
      dist = dx / cos(rotation);
      distanceFactor = reverseDistanceFactor(dist / _lookAheadDist);

      if (normalizeAngle(rotation + PI) < PI) {
        // Turning right (up).
        if (y - _minDist < minY) {
          return distanceFactor;
        }
        return -distanceFactor;
      }

      // Turning left (down).
      if (y + _minDist > maxY) {
        return -distanceFactor;
      }
      return distanceFactor;
    }
    return 0;
  }

  // Returns a number between -1 and 1 indicating how much and in which direction
  // the boid should turn based on a projected collision with the top and bottom boundaries.
  private float getLookAheadVerticalRotationFactor(Vehicle vehicle) {
    float dy;
    float dist;
    float distanceFactor;
    float x = vehicle.x();
    float y = vehicle.y();
    float rotation = vehicle.rotation();
    float nextX = x + _lookAheadDist * cos(rotation);
    float nextY = y + _lookAheadDist * sin(rotation);
    float minX = 0;
    float maxX = _world.width();
    float minY = 0;
    float maxY = _world.height();

    if (nextY > maxY && sin(rotation) > 0) {
      // Bottom boundary.
      dy = maxY - y;
      dist = dy / sin(rotation);
      distanceFactor = reverseDistanceFactor(dist / _lookAheadDist);

      if (normalizeAngle(rotation - PI/2) < PI) {
        // Turning right (to screen left).
        if (x - _minDist < minX) {
          return -distanceFactor;
        }
        return distanceFactor;
      }

      // Turning left (to screen right).
      if (x + _minDist > maxX) {
        return distanceFactor;
      }
      return -distanceFactor;
    } else if (nextY < minY && sin(rotation) < 0) {
      // Top boundary.
      dy = y - minY;
      dist = dy / sin(rotation);
      distanceFactor = reverseDistanceFactor(dist / _lookAheadDist);

      if (normalizeAngle(rotation + PI/2) < PI) {
        // Turning right (to screen right).
        if (x + _minDist > maxX) {
          return distanceFactor;
        }
        return -distanceFactor;
      }

      // Turning left (to screen left).
      if (x - _minDist < minX) {
        return -distanceFactor;
      }
      return distanceFactor;
    }
    return 0;
  }

  private float reverseDistanceFactor(float d) {
    return d / abs(d) * (1 - abs(d));
  }

  // Returns a number between -1 and 1 indicating how much and in which direction
  // the boid should turn based on its distance to the left and right boundaries.
  private float getHorizontalRotationFactor(Vehicle vehicle) {
    float distanceFactor;
    float x = vehicle.x();
    float rotation = vehicle.rotation();
    float minX = 0;
    float maxX = _world.width();
    float minY = 0;
    float maxY = _world.height();

    if (x + _minDist > maxX) {
      distanceFactor = ((x + _minDist) - maxX) / _minDist;
      if (normalizeAngle(rotation) < PI) {
        return distanceFactor;
      }
      return -distanceFactor;
    } else if (x - _minDist < minX) {
      distanceFactor = (minX - (x - _minDist)) / _minDist;
      if (normalizeAngle(rotation + PI) < PI) {
        return distanceFactor;
      }
      return -distanceFactor;
    }
    return 0;
  }

  // Returns a number between -1 and 1 indicating how much and in which direction
  // the boid should turn based on its distance to the top and bottom boundaries.
  private float getVerticalRotationFactor(Vehicle vehicle) {
    float distanceFactor;
    float y = vehicle.y();
    float rotation = vehicle.rotation();
    float minX = 0;
    float maxX = _world.width();
    float minY = 0;
    float maxY = _world.height();

    if (y + _minDist > maxY) {
      distanceFactor = ((y + _minDist) - maxY) / _minDist;
      if (normalizeAngle(rotation - PI/2) < PI) {
        return distanceFactor;
      }
      return -distanceFactor;
    } else if (y - _minDist < minY) {
      distanceFactor = (minY - (y - _minDist)) / _minDist;
      if (normalizeAngle(rotation + PI/2) < PI) {
        return distanceFactor;
      }
      return -distanceFactor;
    }
    return 0;
  }

  float accelerate(Vehicle vehicle) {
    return vehicle.velocity();
  }
}

