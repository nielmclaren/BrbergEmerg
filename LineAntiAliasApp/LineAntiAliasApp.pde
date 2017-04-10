
int imageWidth;
int imageHeight;
int zoomScale;

PGraphics targetImage;
PGraphics zoomImage;

FileNamer fileNamer;

void setup() {
  size(800, 800, P3D);

  imageWidth = 64;
  imageHeight = 64;
  zoomScale = 8;

  targetImage = createGraphics(imageWidth, imageHeight, P3D);
  zoomImage = createGraphics(imageWidth * zoomScale, imageHeight * zoomScale, P3D);

  fileNamer = new FileNamer("output/export", "png");
}

void draw() {

  background(128);

  targetImage.beginDraw();
  targetImage.background(0);
  targetImage.endDraw();

  int numStrokes = 16;
  for (int i = 0; i < numStrokes; i++) {
    float dx = mouseX - width/2;
    float dy = mouseY - height/2;
    float radius = 30;
    float angle = map(i, 0, numStrokes, 0, 2 * PI);
    drawLines(radius, angle);
  }

  updateZoomImage();

  image(zoomImage, 0, 0, width, height);
}

float fpart(float v) {
  if (v < 0) {
    return 1 - (v - floor(v));
  }
  return v - floor(v);
}

float rfpart(float v) {
  return 1 - fpart(v);
}

void drawLines(float radius, float angle) {
  colorMode(HSB);

  int centerX;
  int centerY;

  float r = radius * mouseX / width;
  float a = (angle + 2 * PI * mouseY / height) % (2 * PI);

  centerX = 32;
  centerY = 32;
  targetImage.loadPixels();
  drawLine(targetImage,
      floor(centerX + r * cos(a)), floor(centerY + r * sin(a)),
      floor(centerX + radius * cos(angle)), floor(centerY + radius * sin(angle)));
  targetImage.updatePixels();
}

void drawLine(PGraphics g, int x0, int y0, int x1, int y1) {
  boolean isSteep = abs(y1 - y0) > abs(x1 - x0);
  int temp;

  if (isSteep) {
    temp = x0;
    x0 = y0;
    y0 = temp;

    temp = x1;
    x1 = y1;
    y1 = temp;
  }

  if (x0 > x1) {
    temp = x0;
    x0 = x1;
    x1 = temp;

    temp = y0;
    y0 = y1;
    y1 = temp;
  }

  int dx = x1 - x0;
  int dy = y1 - y0;
  float gradient;
  if (dx == 0.0) {
    gradient = 1.0;
  } else {
    gradient = (float)dy / dx;
  }

  // handle first endpoint
  float xend = round(x0);
  float yend = y0 + gradient * (xend - x0);
  float xgap = rfpart(x0 + 0.5);
  float xpxl1 = xend; // this will be used in the main loop
  float ypxl1 = floor(yend);
  if (isSteep) {
    plot(g, ypxl1,   xpxl1, rfpart(yend) * xgap);
    plot(g, ypxl1+1, xpxl1,  fpart(yend) * xgap);
  } else {
    plot(g, xpxl1, ypxl1  , rfpart(yend) * xgap);
    plot(g, xpxl1, ypxl1+1,  fpart(yend) * xgap);
  }
  float intery = yend + gradient; // first y-intersection for the main loop

  // handle second endpoint
  xend = round(x1);
  yend = y1 + gradient * (xend - x1);
  xgap = fpart(x1 + 0.5);
  float xpxl2 = xend; //this will be used in the main loop
  float ypxl2 = floor(yend);
  if (isSteep) {
    plot(g, ypxl2  , xpxl2, rfpart(yend) * xgap);
    plot(g, ypxl2+1, xpxl2,  fpart(yend) * xgap);
  } else {
    plot(g, xpxl2, ypxl2,  rfpart(yend) * xgap);
    plot(g, xpxl2, ypxl2+1, fpart(yend) * xgap);
  }

  // main loop
  if (isSteep) {
    for (float x = xpxl1 + 1; x < xpxl2; x++) {
      plot(g, floor(intery)  , x, rfpart(intery));
      plot(g, floor(intery)+1, x,  fpart(intery));
      intery = intery + gradient;
    }
  } else {
    for (float x = xpxl1 + 1; x < xpxl2; x++) {
      plot(g, x, floor(intery),  rfpart(intery));
      plot(g, x, floor(intery)+1, fpart(intery));
      intery = intery + gradient;
    }
  }
}

void plot(PGraphics g, float x, float y, float v) {
  g.pixels[floor(y) * g.width + floor(x)] = color(map(v, 0, 1, 255 - 64, 255 + 64) % 255, 128, 255);
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

void keyReleased() {
  switch (key) {
    case 'r':
      save(savePath(fileNamer.next()));
      break;
  }
}
