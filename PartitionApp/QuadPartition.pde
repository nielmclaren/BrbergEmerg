
class QuadPartition {
  private QuadPartition _parent;
  private PVector _topLeft;
  private PVector _topRight;
  private PVector _bottomRight;
  private PVector _bottomLeft;
  private int _depth;
  private ArrayList<QuadPartition> _children;

  QuadPartition(PVector topLeft, PVector topRight, PVector bottomRight, PVector bottomLeft, int depth) {
    _parent = null;
    _topLeft = topLeft.copy();
    _topRight = topRight.copy();
    _bottomRight = bottomRight.copy();
    _bottomLeft = bottomLeft.copy();
    _depth = depth;
    _children = new ArrayList<QuadPartition>();
  }

  QuadPartition(QuadPartition parent, PVector topLeft, PVector topRight, PVector bottomRight, PVector bottomLeft, int depth) {
    _parent = parent;
    _topLeft = topLeft.copy();
    _topRight = topRight.copy();
    _bottomRight = bottomRight.copy();
    _bottomLeft = bottomLeft.copy();
    _depth = depth;
    _children = new ArrayList<QuadPartition>();
  }

  public QuadPartition parent() {
    return _parent;
  }

  public ArrayList<QuadPartition> ancestors() {
    ArrayList<QuadPartition> result = new ArrayList<QuadPartition>();
    QuadPartition p = _parent;
    while (p != null) {
      result.add(p);
      p = p.parent();
    }
    return result;
  }

  public PVector topLeftRef() {
    return _topLeft;
  }

  public PVector topRightRef() {
    return _topRight;
  }

  public PVector bottomRightRef() {
    return _bottomRight;
  }

  public PVector bottomLeftRef() {
    return _bottomLeft;
  }

  public float midX() {
    return (_topLeft.x + _topRight.x + _bottomRight.x + _bottomLeft.x) / 4;
  }

  public float midY() {
    return (_topLeft.y + _topRight.y + _bottomRight.y + _bottomLeft.y) / 4;
  }

  public int depth() {
    return _depth;
  }

  public boolean contains(float x, float y) {
    // FIXME: Only works for convex quadrilaterals!
    PVector p = new PVector(x, y);
    float pointArea = getTriangleArea(_topLeft, _topRight, p)
      + getTriangleArea(_topRight, _bottomRight, p)
      + getTriangleArea(_bottomRight, _bottomLeft, p)
      + getTriangleArea(_bottomRight, _topRight, p);
    return pointArea <= area();
  }

  public float area() {
    return getTriangleArea(_topLeft, _topRight, _bottomRight) + getTriangleArea(_topLeft, _bottomRight, _bottomLeft);
  }

  private float getTriangleArea(PVector p0, PVector p1, PVector p2) {
    // Heron's Formula.
    float s0 = p0.dist(p1);
    float s1 = p1.dist(p2);
    float s2 = p2.dist(p0);
    float p = (s0 + s1 + s2) / 2;
    return sqrt(p * (p - s0) * (p - s1) * (p - s2));
  }

  public QuadPartition getLeafPartitionAt(float x, float y) {
    if (hasChildren()) {
      for (QuadPartition childPartition : _children) {
        if (childPartition.contains(x, y)) {
          return childPartition.getLeafPartitionAt(x, y);
        }
      }
    }

    return this;
  }
/*
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
*/
  public boolean hasChildren() {
    return _children.size() > 0;
  }

  public ArrayList<QuadPartition> children() {
    return _children;
  }

  public void partition(float x, float y) {
    PVector center = new PVector(x, y);

    PVector top = PVector.sub(_topRight, _topLeft);
    top.mult(random(1));
    top.add(_topLeft);

    PVector right = PVector.sub(_bottomRight, _topRight);
    right.mult(random(1));
    right.add(_topRight);

    PVector bottom = PVector.sub(_bottomLeft, _bottomRight);
    bottom.mult(random(1));
    bottom.add(_bottomRight);

    PVector left = PVector.sub(_topLeft, _bottomLeft);
    left.mult(random(1));
    left.add(_bottomLeft);

    int d = _depth + 1;

    _children.add(new QuadPartition(_topLeft, top, center, left, d));
    _children.add(new QuadPartition(top, _topRight, right, center, d));
    _children.add(new QuadPartition(center, right, _bottomRight, bottom, d));
    _children.add(new QuadPartition(left, center, bottom, _bottomLeft, d));
  }
}
