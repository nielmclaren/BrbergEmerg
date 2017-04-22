
Partition partition;
ArrayList<Line> lines;
PImage sourceImage;


FileNamer fileNamer;

void setup() {
  size(800, 800, P3D);

  sourceImage = loadImage("painterly.png");
  fileNamer = new FileNamer("output/export", "png");

  reset();
}

void reset() {
  resetPartitions();
}

void resetPartitions() {
  partition = new Partition(0, 0, width, height, 0);

  float k = 0.2;
  float ik = 1 - k;

  int maxPartitions = 1000;
  int numPartitions = 0;
  while (numPartitions < maxPartitions) {
    float x = random(width);
    float y = random(height);
    Partition p = getLeafPartitionAt(x, y, partition);
    color c = sourceImage.get(floor(p.midX()), floor(p.midX()));
    float score = getDissimilarityScore(sourceImage, floor(p.midX()), floor(p.midY()));
    if (random(255) < score) {
      p.partition(
          p.x() + random(k * p.width(), ik * p.width()),
          p.y() + random(k * p.height(), ik * p.height()));
      numPartitions++;
    }
  }
}

void draw() {
  colorMode(HSB);
  background(0);

  drawPartition(partition);
}

void drawPartition(Partition p) {
  int offset = p.depth();
  int topOffset = p.isTop() ? offset : 1;
  int bottomOffset = p.isBottom() ? offset : 1;
  int leftOffset = p.isLeft() ? offset : 1;
  int rightOffset = p.isRight() ? offset : 1;

  noStroke();
  fill(sourceImage.get(floor(p.midX()), floor(p.midY())));
  rect(p.x() + leftOffset, p.y() + topOffset, p.width() - leftOffset - rightOffset, p.height() - topOffset - bottomOffset);

  if (p.hasChildren()) {
    for (Partition childPartition : p.children()) {
      drawPartition(childPartition);
    }
  }
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
    case 'e':
      reset();
      break;
    case 'r':
      save(savePath(fileNamer.next()));
      break;
  }
}

void mouseReleased() {
  Partition p = getLeafPartitionAt(mouseX, mouseY, partition);
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
