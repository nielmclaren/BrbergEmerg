
Partition partition;
FileNamer fileNamer;

void setup() {
  size(800, 800, P3D);

  partition = new Partition(0, 0, width, height, 0);
  fileNamer = new FileNamer("output/export", "png");
}

void reset() {
  partition = new Partition(0, 0, width, height, 0);

  int numPartitions = 10000;
  for (int i = 0; i < numPartitions; i++) {
    float x = random(width);
    float y = random(height);
    Partition p = getLeafPartitionAt(x, y, partition);
    p.partition(x, y);
  }
}

void draw() {
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
    fill(16 + p.depth() * 8);
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

