
Partition partition;
ArrayList<Line> lines;
PVector lineStart;

FileNamer fileNamer;

void setup() {
  size(800, 800, P3D);

  lineStart = new PVector();
  fileNamer = new FileNamer("output/export", "png");

  reset();
}

void reset() {
  resetPartitions();
  resetLines();
}

void resetPartitions() {
  partition = new Partition(0, 0, width, height, 0);

  float k = 0.2;
  float ik = 1 - k;
  int numPartitions = 20000;
  for (int i = 0; i < numPartitions; i++) {
    float x = random(width);
    float y = random(height);
    Partition p = getLeafPartitionAt(x, y, partition);
    p.partition(p.x() + random(k * p.width(), ik * p.width()), p.y() + random(k * p.height(), ik * p.height()));
  }
}

void resetLines() {
  lines = new ArrayList<Line>();

  int numLines = 20;
  for (int i = 0; i < numLines; i++) {
    lines.add(new Line(random(width), random(height), random(width), random(height)));
  }
}

void draw() {
  colorMode(HSB);
  background(255);

  drawPartition(partition);
}

void drawPartition(Partition p) {
  if (p.hasChildren()) {
    for (Partition childPartition : p.children()) {
      drawPartition(childPartition);
    }
  } else {
    noStroke();
    Line intersectingLine = getIntersectingLine(p, lines);
    if (intersectingLine != null) {
      float d = distanceBetweenLineAndPoint(intersectingLine.x0, intersectingLine.y0, intersectingLine.x1, intersectingLine.y1, p.midX(), p.midY());
      fill((mouseX - d * mouseY / 64) % 255, 128, 192);
    } else {
      fill(32 + 4 * p.depth());
    }
    rect(p.x(), p.y(), p.width(), p.height());
  }
}

Line getIntersectingLine(Partition p, ArrayList<Line> lines) {
  for (Line line : lines) {
    if (p.intersectsLine(line.x0, line.y0, line.x1, line.y1)) {
      return line;
    }
  }
  return null;
}

float distanceBetweenLineAndPoint(float x0, float y0, float x1, float y1, float x, float y) {
  float dx = x1 - x0;
  float dy = y1 - y0;
  return abs((y1 - y0) * x - (x1 - x0) * y + x1 * y0 - y1 * x0) / sqrt(dy * dy + dx * dx);
}

Partition getLeafPartitionAt(float x, float y, Partition p) {
  if (p.hasChildren()) {
    for (Partition childPartition : p.children()) {
      if (childPartition.contains(x, y)) {
        return getLeafPartitionAt(x, y, childPartition);
      }
    }
  }

  return p;
}

void keyReleased() {
  switch (key) {
    case 'e':
      reset();
      break;
    case 'r':
      save(savePath(fileNamer.next()));
      break;
  }
}

void mousePressed() {
  lineStart = new PVector(mouseX, mouseY);
}

void mouseReleased() {
  lines.add(new Line(lineStart.x, lineStart.y, mouseX, mouseY));
}
