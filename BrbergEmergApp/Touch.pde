
class Touch implements IPositioned {
  private long MAX_AGE = 30 * 1000;
  private TuioCursor _cursor;
  private Vehicle _vehicle;
  private long _created;
  private float _prevX;
  private float _prevY;

  Touch(TuioCursor cursor, Vehicle vehicle) {
    _cursor = cursor;
    _vehicle = vehicle;
    _created = millis();
    _prevX = 0;
    _prevY = 0;
  }

  public Vehicle vehicleRef() {
    return _vehicle;
  }

  public int id() {
    return _cursor.getCursorID();
  }

  public float x() {
    return _cursor.getX() * width;
  }

  public float y() {
    return _cursor.getY() * height;
  }

  public Touch step() {
    if (x() != _prevX || y() != _prevY) {
      _created = millis();
    }
    _prevX = x();
    _prevY = y();
    return this;
  }

  public boolean isValid() {
    return millis() < _created + MAX_AGE;
  }
}
