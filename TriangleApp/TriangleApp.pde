
PVector p0, p1, p2;
PVector point;

FileNamer fileNamer;

void setup() {
  size(800, 800, P3D);

  point = new PVector();
  fileNamer = new FileNamer("output/export", "png");

  reset();
  redraw();
}

void reset() {
  point = new PVector(random(width), random(height));
  
  p0 = new PVector(200, 100);
  p1 = new PVector(700, 500);
  p2 = new PVector(300, 700);
}

void redraw() {
  background(0);

  noFill();
  stroke(255, 0, 0);
  triangle(p0.x, p0.y, p1.x, p1.y, p2.x, p2.y);

  fill(255, 255, 0);
  noStroke();
  ellipse(point.x, point.y, 20, 20);

  println(getTriangleArea(p0, p1, p2, 0));
}

void draw() {}

void keyReleased() {
  switch (key) {
    case 'e':
      reset();
      redraw();
      break;
    case 'r':
      save(savePath(fileNamer.next()));
      break;
  }
}
/*
public boolean contains(float x, float y) {
  // FIXME: Only works for convex quadrilaterals!
  PVector p = new PVector(x, y);
  float pointArea = getTriangleArea(_topLeft, _topRight, p, 0)
    + getTriangleArea(_topRight, _bottomRight, p, 1)
    + getTriangleArea(_bottomRight, _bottomLeft, p, 2)
    + getTriangleArea(_bottomRight, _topRight, p, 3);
  return pointArea <= area();
}

public float area() {
  return getTriangleArea(_topLeft, _topRight, _bottomRight, -1) + getTriangleArea(_topLeft, _bottomRight, _bottomLeft, -1);
}
*/
private float getTriangleArea(PVector p0, PVector p1, PVector p2, int index) {
  // Heron's Formula.
  float s0 = p0.dist(p1);
  float s1 = p1.dist(p2);
  float s2 = p2.dist(p0);
  float p = (s0 + s1 + s2) / 2;
  
  if (index >= 0) {
    PVector center = p0.copy();
    center.add(p1);
    center.add(p2);
    center.div(3.);

    float k = 0.05;
    float kv = 1 - k;

    p0 = PVector.add(PVector.mult(center, k), PVector.mult(p0, kv));
    p1 = PVector.add(PVector.mult(center, k), PVector.mult(p1, kv));
    p2 = PVector.add(PVector.mult(center, k), PVector.mult(p2, kv));

    pushStyle();
    stroke(255);
    noFill();
    ellipse(center.x, center.y, 20, 20);

    stroke(128);
    noFill();
    triangle(p0.x, p0.y, p1.x, p1.y, p2.x, p2.y);
    popStyle();
  }
  
  return sqrt(p * (p - s0) * (p - s1) * (p - s2));
}