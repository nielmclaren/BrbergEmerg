
// Steer away from the boundaries of the world.
class BoundaryImpulse extends Impulse {
  private float _lookAheadDist;
  private float _minDist;
  private int _numTurnSteps;

  BoundaryImpulse(World world) {
    super(world);

    _lookAheadDist = 200;
    _minDist = 100;
    _numTurnSteps = 20;
  }

  void step(Vehicle vehicle) {
    int safety = 5;
    float x = vehicle.position().x;
    float y = vehicle.position().y;
    float minX = 0;
    float maxX = _world.width();
    float minY = 0;
    float maxY = _world.height();

    if (x > maxX) {
      x = maxX - safety;
      vehicle.velocity().x = -vehicle.velocity().x;
    } else if (x < minX) {
      vehicle.x(minX + safety);
      vehicle.velocity().x = -vehicle.velocity().x;
    }

    if (y > maxY) {
      y = maxY - safety;
      vehicle.velocity().y = -vehicle.velocity().y;
    } else if (y < minY) {
      vehicle.y(minY + safety);
      vehicle.velocity().y = -vehicle.velocity().y;
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

      rotateVehicle(vehicle, 0.03 * (rx + ry));
    } else {
      vehicle.resetNumStepsSinceLastTurn();
      if (vehicle.isTurningCw()) {
        rotateVehicle(vehicle, -v);
      } else if (vehicle.isTurningCcw()) {
        rotateVehicle(vehicle, v);
      } else {
        float d = abs(rx) > abs(ry) ? rx : ry;
        if (d < 0) {
          vehicle.isTurningCw(true);
          rotateVehicle(vehicle, -v);
        } else {
          vehicle.isTurningCcw(true);
          rotateVehicle(vehicle, v);
        }
      }
    }
  }

  // Returns a number between -1 and 1 indicating how much and in which direction
  // the boid should turn based on a projected collision with the left and right boundaries.
  private float getLookAheadHorizontalRotationFactor(Vehicle vehicle) {
    float dx;
    float dist;
    float distanceFactor;
    float x = vehicle.position().x;
    float y = vehicle.position().y;
    float vx = vehicle.velocity().x;
    float vy = vehicle.velocity().y;
    PVector dir = vehicle.velocity();
    dir.normalize();
    float nextX = x + _lookAheadDist * dir.x;
    float nextY = y + _lookAheadDist * dir.x;
    float minX = 0;
    float maxX = _world.width();
    float minY = 0;
    float maxY = _world.height();

    if (nextX > maxX && vx > 0) {
      // Right boundary.
      dx = maxX - x;
      dist = dx / vx;
      distanceFactor = reverseDistanceFactor(dist / _lookAheadDist);

      if (vy > 0) {
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
    } else if (nextX < minX && vx < 0) {
      // Left boundary.
      dx = x - minX;
      dist = dx / vx;
      distanceFactor = reverseDistanceFactor(dist / _lookAheadDist);

      if (vy < 0) {
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
    float x = vehicle.position().x;
    float y = vehicle.position().y;
    float vx = vehicle.velocity().x;
    float vy = vehicle.velocity().y;
    PVector dir = vehicle.velocity();
    dir.normalize();
    float nextX = x + _lookAheadDist * dir.x;
    float nextY = y + _lookAheadDist * dir.y;
    float minX = 0;
    float maxX = _world.width();
    float minY = 0;
    float maxY = _world.height();

    if (nextY > maxY && vy > 0) {
      // Bottom boundary.
      dy = maxY - y;
      dist = dy / vy;
      distanceFactor = reverseDistanceFactor(dist / _lookAheadDist);

      if (vx < 0) {
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
    } else if (nextY < minY && vy < 0) {
      // Top boundary.
      dy = y - minY;
      dist = dy / vy;
      distanceFactor = reverseDistanceFactor(dist / _lookAheadDist);

      if (vx > 0) {
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
    float x = vehicle.position().x;
    float vx = vehicle.velocity().x;
    float vy = vehicle.velocity().y;
    float minX = 0;
    float maxX = _world.width();
    float minY = 0;
    float maxY = _world.height();

    if (x + _minDist > maxX) {
      distanceFactor = ((x + _minDist) - maxX) / _minDist;
      if (vy > 0) {
        return distanceFactor;
      }
      return -distanceFactor;
    } else if (x - _minDist < minX) {
      distanceFactor = (minX - (x - _minDist)) / _minDist;
      if (vy < 0) {
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
    float y = vehicle.position().y;
    float vx = vehicle.velocity().x;
    float vy = vehicle.velocity().y;
    float minX = 0;
    float maxX = _world.width();
    float minY = 0;
    float maxY = _world.height();

    if (y + _minDist > maxY) {
      distanceFactor = ((y + _minDist) - maxY) / _minDist;
      if (vx < 0) {
        return distanceFactor;
      }
      return -distanceFactor;
    } else if (y - _minDist < minY) {
      distanceFactor = (minY - (y - _minDist)) / _minDist;
      if (vx > 0) {
        return distanceFactor;
      }
      return -distanceFactor;
    }
    return 0;
  }

  private void rotateVehicle(Vehicle vehicle, float rotation) {
    vehicle.velocity().rotate(rotation);
  }
}

