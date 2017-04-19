
Partition partition;
ArrayList<Line> lines;
PImage sourceImage;


FileNamer fileNamer;

void setup() {
  size(800, 800, P3D);

  sourceImage = loadImage("muhammadali.png");
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

  int numLinearPartitions = 1000;
  int numAreaPartitions = 100;

  for (int i = 0; i < numLinearPartitions; i++) {
    Partition p = getRandomLeafPartition(partition);
    p.partition(p.x() + random(k * p.width(), ik * p.width()), p.y() + random(k * p.height(), ik * p.height()));
  }

  for (int i = 0; i < numAreaPartitions; i++) {
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
    color c = sourceImage.get(floor(p.midX()), floor(p.midY()));
    fill(hue(c), saturation(c), brightness(c) - 32 + 4 * p.depth());
    rect(p.x(), p.y(), p.width(), p.height());
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
