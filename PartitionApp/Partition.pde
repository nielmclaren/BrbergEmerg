
class Partition {
  private float _x;
  private float _y;
  private float _width;
  private float _height;
  private int _depth;
  private ArrayList<Partition> _children;

  Partition(float x, float y, float width, float height, int depth) {
    _x = x;
    _y = y;
    _width = width;
    _height = height;
    _depth = depth;
    _children = new ArrayList<Partition>();
  }

  public float x() {
    return _x;
  }

  public float y() {
    return _y;
  }

  public float width() {
    return _width;
  }

  public float height() {
    return _height;
  }

  public int depth() {
    return _depth;
  }

  public boolean contains(float x, float y) {
    return x >= _x && x < _x + _width
      && y >= _y && y < _y + _height;
  }

  public boolean hasChildren() {
    return _children.size() > 0;
  }

  public ArrayList<Partition> children() {
    return _children;
  }

  public void partition(float x, float y) {
    int d = _depth + 1;
    _children = new ArrayList<Partition>();
    _children.add(new Partition(_x, _y, x - _x, y - _y, d));
    _children.add(new Partition(_x, y, x - _x, _y + _height - y, d));
    _children.add(new Partition(x, _y, _x + _width - x, y - _y, d));
    _children.add(new Partition(x, y, _x + _width - x, _y + _height - y, d));
  }
}
