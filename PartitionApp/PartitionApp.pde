
Partition partition;
ArrayList<Line> lines;
PImage sourceImage;


FileNamer fileNamer;

void setup() {
  size(800, 800, P3D);

  sourceImage = loadImage("noise.png");
  fileNamer = new FileNamer("output/export", "png");

  reset();
}

void reset() {
  resetPartitions();
}

void resetPartitions() {
  partition = new Partition(0, 0, width, height, 0);

  float k = 0.05;
  float ik = 1 - k;
  int numPartitions = 10000;
  for (int i = 0; i < numPartitions; i++) {
    float x = random(width);
    float y = random(height);
    Partition p = getLeafPartitionAt(x, y, partition);
    p.partition(p.x() + random(k * p.width(), ik * p.width()), p.y() + random(k * p.height(), ik * p.height()));
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
    float b = brightness(sourceImage.get(floor(p.x()), floor(p.y())));
    if (b > 196) {
      fill(8 + 2 * p.depth());
    } else {
      fill((mouseX + b * mouseY / 64) % 255, 128, 255);
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
    case 'a':
      saveAnimation();
      break;
    case 'e':
      reset();
      break;
    case 'r':
      save(savePath(fileNamer.next()));
      break;
  }
}

void saveAnimation() {
  FileNamer animationFolderNamer = new FileNamer("output/anim", "/");
  FileNamer frameNamer = new FileNamer(animationFolderNamer.next() + "/frame", "png");
  for (int i = 0; i < 30; i++) {
    resetPartitions();
    drawPartition(partition);
    save(frameNamer.next());
  }
}
