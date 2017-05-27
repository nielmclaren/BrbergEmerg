
QuadPartition partition;
ArrayList<Line> lines;
PImage sourceImage;


FileNamer fileNamer;

void setup() {
  size(800, 800, P3D);

  sourceImage = loadImage("thormanby.jpg");
  fileNamer = new FileNamer("output/export", "png");

  reset();
}

void clear() {
  partition = new QuadPartition(
      new PVector(0, 0),
      new PVector(width, 0),
      new PVector(width, height),
      new PVector(0, height),
      0);
}

void reset() {
  resetPartitions();
}

void resetPartitions() {
  println("Working...");
  partition = new QuadPartition(
      new PVector(0, 0),
      new PVector(width, 0),
      new PVector(width, height),
      new PVector(0, height),
      0);

  float j = 0.4;
  float ij = 1 - j;
  float k = 0.4;
  float ik = 1 - k;

  int numPartitions = 0;
  int maxPartitions = 1000;
  while (numPartitions < maxPartitions) {
    float x = random(width);
    float y = random(height);
    QuadPartition p = partition.getLeafPartitionAt(x, y);
    float score = getDissimilarityScore(sourceImage, floor(p.midX()), floor(p.midY()));
    if (random(255) < score && p.partition(p.midX(), p.midY())) {
      numPartitions++;
    }
  }
  println("Done.");
}

void draw() {
  colorMode(HSB);
  background(0);

  drawPartition(partition);
}

void drawPartition(QuadPartition p) {
  color c = sourceImage.get(floor(p.midX()), floor(p.midY()));
  fill(hue(c), saturation(c), brightness(c) + 64, 64);
  noStroke();

  PVector topLeft = p.topLeftRef().copy();
  PVector topRight = p.topRightRef().copy();
  PVector bottomLeft = p.bottomLeftRef().copy();
  PVector bottomRight = p.bottomRightRef().copy();

  PVector center = new PVector();
  center.add(topLeft);
  center.add(topRight);
  center.add(bottomLeft);
  center.add(bottomRight);
  center.mult(0.25);

  float k = map(p.depth(), 0, 6, 0.1, 0);
  float ik = 1 - k;
  topLeft = PVector.add(PVector.mult(topLeft, ik), PVector.mult(center, k));
  topRight = PVector.add(PVector.mult(topRight, ik), PVector.mult(center, k));
  bottomLeft = PVector.add(PVector.mult(bottomLeft, ik), PVector.mult(center, k));
  bottomRight = PVector.add(PVector.mult(bottomRight, ik), PVector.mult(center, k));

  quad(
      topLeft.x, topLeft.y,
      topRight.x, topRight.y,
      bottomRight.x, bottomRight.y,
      bottomLeft.x, bottomLeft.y);

  if (p.hasChildren()) {
    for (QuadPartition childPartition : p.children()) {
      drawPartition(childPartition);
    }
  }
}

float getDissimilarityScore(PImage image, int targetX, int targetY) {
  int radius = 50;
  int radiusSq = radius * radius;
  float sum = 0;
  int numEntries = 0;

  for (int rx = -radius; rx < radius; rx++) {
    for (int ry = -radius; ry < radius; ry++) {
      int x = targetX + rx;
      int y = targetY + ry;
      if (x >= 0 && x < image.width && y >= 0 && y < image.height && sqrt(rx * rx + ry * ry) < radiusSq) {
        sum += brightness(image.pixels[y * image.width + x]);
        numEntries++;
      }
    }
  }

  return abs(brightness(image.get(targetX, targetY)) - sum/numEntries);
}

void keyReleased() {
  switch (key) {
    case 'a':
      saveAnimation();
      break;
    case 'c':
      clear();
      break;
    case 'e':
      reset();
      break;
    case 'r':
      save(savePath(fileNamer.next()));
      break;
  }
}

void mouseReleased() {
  QuadPartition p = partition.getLeafPartitionAt(mouseX, mouseY);
  p.partition(mouseX, mouseY);
}

void saveAnimation() {
  FileNamer animationFolderNamer = new FileNamer("output/anim", "/");
  FileNamer frameNamer = new FileNamer(animationFolderNamer.next() + "/frame", "png");
  for (int i = 0; i < 30; i++) {
    background(0);
    resetPartitions();
    drawPartition(partition);
    save(frameNamer.next());
  }
}
