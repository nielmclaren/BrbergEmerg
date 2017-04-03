
int imageWidth;
int imageHeight;
int zoomScale;

PGraphics targetImage;
PGraphics zoomImage;

void setup() {
  size(800, 800, P3D);

  imageWidth = 64;
  imageHeight = 64;
  zoomScale = 8;

  targetImage = createGraphics(imageWidth, imageHeight, P3D);
  zoomImage = createGraphics(imageWidth * zoomScale, imageHeight * zoomScale, P3D);
}

void draw() {
  int radius = floor((float)mouseX / 5);

  background(128);

  targetImage.beginDraw();
  targetImage.background(0);
  targetImage.endDraw();

  targetImage.beginDraw();
  targetImage.ellipseMode(RADIUS);
  targetImage.ellipse(20, 32, radius, radius);
  targetImage.endDraw();

  targetImage.loadPixels();
  drawFilledCircle(targetImage, 44, 32, radius);
  targetImage.updatePixels();

  updateZoomImage();

  image(targetImage, 0, 0);
  image(zoomImage, imageWidth, 0);

  ellipseMode(RADIUS);
  noFill();
  stroke(255, 0, 0);
  ellipse(imageWidth + 20 * zoomScale, 32 * zoomScale, radius * zoomScale, radius * zoomScale);
  ellipse(imageWidth + 44 * zoomScale, 32 * zoomScale, radius * zoomScale, radius * zoomScale);
}

void drawCircle(PGraphics g, int targetX, int targetY, int radius) {
  if (targetX < 0 || targetX >= g.width || targetY < 0 || targetY >= g.height) {
    return;
  }

  float radiusSquared = radius * radius;
  for (int x = 0; x <= radius * 0.75; x++) {
    float yActual = sqrt(radiusSquared - x * x);
    int y = round(yActual);
    float error = yActual - y;
    float errorInverse = 1 - error;

    drawEightPixels(g, targetX, targetY, x, y, color(255 * errorInverse));
    drawEightPixels(g, targetX, targetY, x, y + 1, color(255 * error));
  }
}

void drawFilledCircle(PGraphics g, int targetX, int targetY, int radius) {
  if (targetX < 0 || targetX >= g.width || targetY < 0 || targetY >= g.height) {
    return;
  }

  float radiusSquared = radius * radius;
  for (int x = -radius; x <= radius; x++) {
    for (int y = -radius; y <= radius; y++) {
      if (targetX + x < 0 || targetX + x >= g.width || targetY + y < 0 || targetY + y >= g.height) {
        continue;
      }

      float rSquared = (x + 0.5) * (x + 0.5) + (y + 0.5) * (y + 0.5);
      if (rSquared < radiusSquared) {
        float error = radius - sqrt(rSquared);
        g.pixels[(targetY + y) * g.width + (targetX + x)] = color(255 * error);
      }
    }
  }
}

void drawEightPixels(PGraphics g, int targetX, int targetY, int deltaX, int deltaY, color c) {
  if (targetX + deltaX < g.width && targetY + deltaY < g.height) {
    g.pixels[(targetY + deltaY) * g.width + (targetX + deltaX)] = c;
  }
  if (targetX + deltaX < g.width && targetY - deltaY >= 0) {
    g.pixels[(targetY - deltaY) * g.width + (targetX + deltaX)] = c;
  }
  if (targetX - deltaX >= 0 && targetY + deltaY < g.height) {
    g.pixels[(targetY + deltaY) * g.width + (targetX - deltaX)] = c;
  }
  if (targetX - deltaX >= 0 && targetY - deltaY >= 0) {
    g.pixels[(targetY - deltaY) * g.width + (targetX - deltaX)] = c;
  }
  if (targetX + deltaY < g.width && targetY + deltaX < g.height) {
    g.pixels[(targetY + deltaX) * g.width + (targetX + deltaY)] = c;
  }
  if (targetX + deltaY < g.width && targetY - deltaX >= 0) {
    g.pixels[(targetY - deltaX) * g.width + (targetX + deltaY)] = c;
  }
  if (targetX - deltaY >= 0 && targetY + deltaX < g.height) {
    g.pixels[(targetY + deltaX) * g.width + (targetX - deltaY)] = c;
  }
  if (targetX - deltaY >= 0 && targetY - deltaX >= 0) {
    g.pixels[(targetY - deltaX) * g.width + (targetX - deltaY)] = c;
  }
}

void mouseReleased() {
  targetImage.beginDraw();
  targetImage.ellipse(mouseX % imageWidth, mouseY % imageHeight, 10, 10);
  targetImage.endDraw();
  updateZoomImage();
}

void updateZoomImage() {
  targetImage.loadPixels();
  zoomImage.loadPixels();
  for (int targetX = 0; targetX < imageWidth; targetX++) {
    for (int targetY = 0; targetY < imageHeight; targetY++) {
      color c = targetImage.pixels[targetY * targetImage.width + targetX];
      for (int x = 0; x < zoomScale; x++) {
        for (int y = 0; y < zoomScale; y++) {
          int zoomX = targetX * zoomScale + x;
          int zoomY = targetY * zoomScale + y;
          zoomImage.pixels[zoomY * zoomImage.width + zoomX] = c;
        }
      }
    }
  }
  targetImage.updatePixels();
  zoomImage.updatePixels();
}
