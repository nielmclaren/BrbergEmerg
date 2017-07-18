
class Partition {
  private Partition _parent;
  private float _x;
  private float _y;
  private float _width;
  private float _height;
  private int _depth;
  private ArrayList<Partition> _children;

  Partition(float x, float y, float width, float height, int depth) {
    _parent = null;
    _x = x;
    _y = y;
    _width = width;
    _height = height;
    _depth = depth;
    _children = new ArrayList<Partition>();
  }

  Partition(Partition parent, float x, float y, float width, float height, int depth) {
    _parent = parent;
    _x = x;
    _y = y;
    _width = width;
    _height = height;
    _depth = depth;
    _children = new ArrayList<Partition>();
  }

  public Partition parent() {
    return _parent;
  }

  public ArrayList<Partition> ancestors() {
    ArrayList<Partition> result = new ArrayList<Partition>();
    Partition p = _parent;
    while (p != null) {
      result.add(p);
      p = p.parent();
    }
    return result;
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

  public float midX() {
    return _x + _width/2;
  }

  public float midY() {
    return _y + _height/2;
  }

  public int depth() {
    return _depth;
  }

  public float area() {
    return _width * _height;
  }

  public boolean contains(float x, float y) {
    return x >= _x && x < _x + _width
      && y >= _y && y < _y + _height;
  }

  public Partition getLeafPartitionAt(float x, float y) {
    if (hasChildren()) {
      for (Partition childPartition : _children) {
        if (childPartition.contains(x, y)) {
          return childPartition.getLeafPartitionAt(x, y);
        }
      }
    }

    return this;
  }

  public boolean intersectsLine(float x0, float y0, float x1, float y1) {
    return lineIntersectsLine(x0, y0, x1, y1, _x, _y, _x + _width, _y)
      || lineIntersectsLine(x0, y0, x1, y1, _x, _y, _x, _y + _height)
      || lineIntersectsLine(x0, y0, x1, y1, _x + _width, _y, _x + _width, _y + _height)
      || lineIntersectsLine(x0, y0, x1, y1, _x, _y + _height, _x + _width, _y + _height);
  }

  private boolean lineIntersectsLine(
      float ax0, float ay0, float ax1, float ay1,
      float bx0, float by0, float bx1, float by1) {
    ax1 -= ax0;
    ay1 -= ay0;
    bx1 -= bx0;
    by1 -= by0;
    float d = bx1 * ay1 - ax1 * by1;
    if (d == 0) return false;
    float id = 1 / d;
    float s = id * ((ax0 - bx0) * ay1 - (ay0 - by0) * ax1);
    float t = id * -(-(ax0 - bx0) * by1 + (ay0 - by0) * bx1);
    return s >= 0 && s <= 1 && t >= 0 && t <= 1;
  }

  public boolean hasChildren() {
    return _children.size() > 0;
  }

  public ArrayList<Partition> children() {
    return _children;
  }

  public void partition(float x, float y) {
    _children = new ArrayList<Partition>();
    if (random(1) < 0.25) {
      _children = getHorizontalPartition(x, y, _depth);
    } else {
      _children = getVerticalPartition(x, y, _depth);
    }
  }

  private ArrayList<Partition> getHorizontalPartition(float x, float y, int depth) {
    int d = depth + 1;
    ArrayList<Partition> result = new ArrayList<Partition>();
    result.add(new Partition(this, _x, _y, x - _x, _height, d));
    result.add(new Partition(this, x, _y, _x + _width - x, _height, d));
    return result;
  }

  private ArrayList<Partition> getVerticalPartition(float x, float y, int depth) {
    int d = depth + 1;
    ArrayList<Partition> result = new ArrayList<Partition>();
    result.add(new Partition(this, _x, _y, _width, y - _y, d));
    result.add(new Partition(this, _x, y, _width, _y + _height - y, d));
    return result;
  }
}
