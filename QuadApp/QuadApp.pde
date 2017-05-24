
QuadPartition partition;
PVector point;

FileNamer fileNamer;

void setup() {
  size(800, 800, P3D);

  point = new PVector();
  fileNamer = new FileNamer("output/export", "png");

  reset();
  redraw();
}

void reset() {
  partition = new QuadPartition(
      new PVector(100, 200),
      new PVector(500, 100),
      new PVector(700, 600),
      new PVector(200, 700),
      0);
  point = new PVector(random(width), random(height));
}

void redraw() {
  background(0);
  stroke(255, 0, 0);
  noFill();

  strokeWeight(4);
  quad(
      partition.topLeftRef().x, partition.topLeftRef().y,
      partition.topRightRef().x, partition.topRightRef().y,
      partition.bottomRightRef().x, partition.bottomRightRef().y,
      partition.bottomLeftRef().x, partition.bottomLeftRef().y);

  fill(255, 255, 0);
  noStroke();
  ellipse(point.x, point.y, 20, 20);
  
  fill(255);
  noStroke();
  textSize(64);
  if (partition.contains(point.x, point.y)) {
    text("It has a point.", 10, 100);
  } else {
    text("This is pointless.", 10, 100);
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

void mouseReleased() {
  point = new PVector(mouseX, mouseY);
  redraw();
}
