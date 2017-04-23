
Partition partition;
ArrayList<Line> lines;
PImage sourceImage;


FileNamer fileNamer;

void setup() {
  size(800, 800, P3D);

  sourceImage = loadImage("barcode.png");
  fileNamer = new FileNamer("output/export", "png");

  reset();
}

void clear() {
  partition = new Partition(0, 0, width, height, 0);
}

void reset() {
  resetPartitions();
}

void resetPartitions() {
  partition = new Partition(0, 0, width, height, 0);

  float k = 0.2;
  float ik = 1 - k;

  int numPartitions = 4000;
  for (int i = 0; i < numPartitions; i++) {
    float x = random(width);
    float y = random(height);
    Partition p = partition.getLeafPartitionAt(x, y);
    color c = sourceImage.get(floor(p.midX()), floor(p.midX()));
    p.partition(
        p.x() + random(k * p.width(), ik * p.width()),
        p.y() + random(k * p.height(), ik * p.height()));
  }
}

void draw() {
  colorMode(HSB);
  background(0);

  drawPartition(partition);
}

void drawPartition(Partition p) {
  ArrayList<Partition> path = p.ancestors();
  path.add(0, p);

  color c = sourceImage.get(floor(p.midX()), floor(p.midY()));
  if (brightness(c) < 32) {
    stroke(0);
    fill(c);
  } else {
    stroke(232);
    fill(240);
  }
  rect(p.x(), p.y(), p.width(), p.height());

  if (p.hasChildren()) {
    for (Partition childPartition : p.children()) {
      drawPartition(childPartition);
    }
  }
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
  Partition p = partition.getLeafPartitionAt(mouseX, mouseY);
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
