
Partition partition;
ArrayList<Line> lines;
PImage sourceImage;


FileNamer fileNamer;

void setup() {
  size(800, 800, P3D);

  sourceImage = loadImage("gradient.png");
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

  int maxPartitions = 2000;
  int numPartitions = 0;
  while (numPartitions < maxPartitions) {
    float x = random(width);
    float y = random(height);
    Partition p = getLeafPartitionAt(x, y, partition);
    color c = sourceImage.get(floor(p.midX()), floor(p.midX()));
    if (random(1) < (cos((brightness(c) - 127) * 2 * PI / 255) + 1) / 2) {
      p.partition(
          p.x() + random(k * p.width(), ik * p.width()),
          p.y() + random(k * p.height(), ik * p.height()));
      numPartitions++;
    }
  }
}

void draw() {
  colorMode(HSB);
  background(0, 255, 255);

  drawPartition(partition);
}

void drawPartition(Partition p) {
  if (p.hasChildren()) {
    for (Partition childPartition : p.children()) {
      drawPartition(childPartition);
    }
  } else {
    int offset = 2;
    color c = color(map(p.area(), 0, 1000, 255, 0));
    color b = color(hue(c), saturation(c), brightness(c) + 16);
    color d = color(hue(c), saturation(c), brightness(c) - 64);

    fill(c);
    noStroke();
    rect(p.x(), p.y(), p.width(), p.height());

    fill(b);
    stroke(d);
    rect(p.x() + offset, p.y() + offset, p.width() - 2 * offset, p.height() - 2 * offset);
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
