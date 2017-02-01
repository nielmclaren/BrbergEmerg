
class Vehicle {
  public float x;
  public float y;
  public float rotation;

  Vehicle(float xArg, float yArg, float rotationArg) {
    x = xArg;
    y = yArg;
    rotation = rotationArg;
  }

  boolean isColliding(Vehicle v) {
    float dx = x - v.x;
    float dy = y - v.y;
    return dx * dx + dy * dy < 22 * 22;
  }
}
