
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

  public boolean isConvex() {
    ArrayList<PVector> points = new ArrayList<PVector>();
    points.add(_topLeft);
    points.add(_topRight);
    points.add(_bottomRight);
    points.add(_bottomLeft);
    return ConvexHull.isConvex(points);
  }

  public boolean contains(float x, float y) {
    // FIXME: Only works for convex quadrilaterals!
    PVector p = new PVector(x, y);
    float pointArea = getTriangleArea(_topLeft, _topRight, p)
      + getTriangleArea(_topRight, _bottomRight, p)
      + getTriangleArea(_bottomRight, _bottomLeft, p)
      + getTriangleArea(_bottomLeft, _topLeft, p);
    float error = 1;
    return pointArea <= area() + 1;
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

  public boolean hasChildren() {
    return _children.size() > 0;
  }

  public ArrayList<QuadPartition> children() {
    return _children;
  }

  public void partition(float x, float y) {
    int d = _depth + 1;
    float k = 0.02;

    int maxTries = 100;
    _children = new ArrayList<QuadPartition>();
    for (int i = 0; i < maxTries; i++) {
      PVector top = PVector.sub(_topRight, _topLeft);
      top.mult(random(0.5 - k * 0.5, 0.5 + k * 0.5));
      top.add(_topLeft);

      PVector right = PVector.sub(_bottomRight, _topRight);
      right.mult(random(0.5 - k * 0.5, 0.5 + k * 0.5));
      right.add(_topRight);

      PVector bottom = PVector.sub(_bottomLeft, _bottomRight);
      bottom.mult(random(0.5 - k * 0.5, 0.5 + k * 0.5));
      bottom.add(_bottomRight);

      PVector left = PVector.sub(_topLeft, _bottomLeft);
      left.mult(random(0.5 - k * 0.5, 0.5 + k * 0.5));
      left.add(_bottomLeft);

      float w = (top.x + bottom.x) / 2;
      float h = (left.y + bottom.y) / 2;

      PVector center = new PVector(random(x - k * w/2, x + k * w/2), random(y - k * h/2, y + k * h/2));

      QuadPartition topLeftQuad = new QuadPartition(_topLeft, top, center, left, d);
      QuadPartition topRightQuad = new QuadPartition(top, _topRight, right, center, d);
      QuadPartition bottomRightQuad = new QuadPartition(center, right, _bottomRight, bottom, d);
      QuadPartition bottomLeftQuad = new QuadPartition(left, center, bottom, _bottomLeft, d);

      if (topLeftQuad.isConvex() && topRightQuad.isConvex() && bottomRightQuad.isConvex() && bottomLeftQuad.isConvex()) {
        _children.add(topLeftQuad);
        _children.add(topRightQuad);
        _children.add(bottomRightQuad);
        _children.add(bottomLeftQuad);
        break;
      }
    }
  }
}
