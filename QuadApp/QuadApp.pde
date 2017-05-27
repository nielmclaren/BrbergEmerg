
ArrayList<QuadPartition> partitions;

FileNamer fileNamer;

void setup() {
  size(800, 800, P3D);

  fileNamer = new FileNamer("output/export", "png");

  reset();
  redraw();
}

void reset() {
  partitions = new ArrayList<QuadPartition>();
  
  // Bow-tie in the top left.
  partitions.add(new QuadPartition(
    new PVector(216, 158),
    new PVector(302, 387),
    new PVector(37, 169),
    new PVector(314, 228), 0));

  // Convex in top right. 
  partitions.add(new QuadPartition(
    new PVector(652, 64),
    new PVector(712, 128),
    new PVector(575, 318),
    new PVector(453, 325), 0));
    
  // Concave in bottom right. 
  partitions.add(new QuadPartition(
    new PVector(460, 773),
    new PVector(732, 528),
    new PVector(556, 491),
    new PVector(614, 590), 0));
  
  // Random in the bottom left.
  partitions.add(new QuadPartition(
      new PVector(random(width/2), random(height/2, height)),
      new PVector(random(width/2), random(height/2, height)),
      new PVector(random(width/2), random(height/2, height)),
      new PVector(random(width/2), random(height/2, height)),
      0));
}

void redraw() {
  background(0);

  stroke(128);
  strokeWeight(1);
  for (int x = 0; x < width; x += 100) {
    line(x, 0, x, height);
  }
  for (int y = 0; y < height; y += 100) {
    line(0, y, width, y);
  }
  
  strokeWeight(4);
  noFill();

  for (QuadPartition partition : partitions) {
    if (partition.isConvex()) {
      stroke(255);
    } else {
      stroke(255, 0, 0);
    }
    
    quad(
        partition.topLeftRef().x, partition.topLeftRef().y,
        partition.topRightRef().x, partition.topRightRef().y,
        partition.bottomRightRef().x, partition.bottomRightRef().y,
        partition.bottomLeftRef().x, partition.bottomLeftRef().y);
  }
}

void draw() {}

void keyReleased() {
  switch (key) {
    case 'e':
      reset();
      redraw();
      break;
    case 'r':
      save(savePath(fileNamer.next()));
      break;
  }
}
