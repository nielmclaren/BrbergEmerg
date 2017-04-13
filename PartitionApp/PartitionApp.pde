
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

  int numPartitions = 1000;
  for (int i = 0; i < numPartitions; i++) {
    float x = random(width);
    float y = random(height);
    Partition p = getLeafPartitionAt(x, y, partition);
    p.partition(x, y);
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
      fill(0);
    } else {
      fill((255 - 64 + p.depth() * 8) % 255, 128, 255);
    }
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

