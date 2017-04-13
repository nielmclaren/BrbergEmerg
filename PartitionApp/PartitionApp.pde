
Partition partition;
Line targetLine;

FileNamer fileNamer;

void setup() {
  size(800, 800, P3D);

  fileNamer = new FileNamer("output/export", "png");

  reset();
}

void reset() {
  partition = new Partition(0, 0, width, height, 0);

  float k = 0.2;
  float ik = 1 - k;
  int numPartitions = 10000;
  for (int i = 0; i < numPartitions; i++) {
    float x = random(width);
    float y = random(height);
    Partition p = getLeafPartitionAt(x, y, partition);
    p.partition(p.x() + random(k * p.width(), ik * p.width()), p.y() + random(k * p.height(), ik * p.height()));
  }

  targetLine = new Line(random(width), random(height), random(width), random(height));
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
    if (p.intersectsLine(targetLine.x0, targetLine.y0, targetLine.x1, targetLine.y1)) {
      float d = distanceBetweenLineAndPoint(targetLine.x0, targetLine.y0, targetLine.x1, targetLine.y1, p.midX(), p.midY());
      fill((255 - 64 + d * 8) % 255, 128, 255);
    } else {
      fill(32 + 2 * p.depth());
    }
    rect(p.x(), p.y(), p.width(), p.height());
  }

  //strokeWeight(2);
  //stroke(32, 128, 255);
  //line(targetLine.x0, targetLine.y0, targetLine.x1, targetLine.y1);
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

