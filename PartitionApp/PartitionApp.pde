
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

  int numPartitions = 1000;
  for (int i = 0; i < numPartitions; i++) {
    float x = random(width);
    float y = random(height);
    QuadPartition p = partition.getLeafPartitionAt(x, y);
    p.partition(p.midX(), p.midY());
  }
}

void draw() {
  colorMode(HSB);
  blendMode(ADD);
  background(0);

  drawPartition(partition);
}

void drawPartition(QuadPartition p) {
  if (p.hasChildren()) {
    for (QuadPartition childPartition : p.children()) {
      drawPartition(childPartition);
    }
  } else {
    color c = sourceImage.get(floor(p.midX()), floor(p.midY()));
    fill(hue(c), saturation(c), brightness(c), 128);
    noStroke();

    quad(
        p.topLeftRef().x, p.topLeftRef().y,
        p.topRightRef().x, p.topRightRef().y,
        p.bottomRightRef().x, p.bottomRightRef().y,
        p.bottomLeftRef().x, p.bottomLeftRef().y);
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
