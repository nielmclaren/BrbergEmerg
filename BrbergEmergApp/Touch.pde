
class Touch implements IPositioned {
  private TuioCursor _cursor;
  private Vehicle _vehicle;

  Touch(TuioCursor cursor, Vehicle vehicle) {
    _cursor = cursor;
    _vehicle = vehicle;
  }

  public Vehicle vehicleRef() {
    return _vehicle;
  }

  public float x() {
    return _cursor.getX() * width;
  }

  public float y() {
    return _cursor.getY() * height;
  }
}
