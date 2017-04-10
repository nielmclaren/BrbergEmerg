
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
  float dx = mouseX - width/2;
  float dy = mouseY - height/2;
  float radius = map(sqrt(dx * dx + dy * dy), 0, sqrt(width * width + height * height), 0, sqrt(32 * 32 + 32 * 32));
  float angle = atan2(dy, dx);
  println(radius, angle * 180/PI);

  background(128);

  targetImage.beginDraw();
  targetImage.background(0);
  targetImage.endDraw();

  targetImage.beginDraw();
  targetImage.stroke(255);
  targetImage.line(16, 32, floor(16 + radius * cos(angle)), floor(32 + radius * sin(angle)));
  targetImage.endDraw();

  targetImage.loadPixels();
  drawLine(targetImage, 48, 32, floor(48 + radius * cos(angle)), floor(32 + radius * sin(angle)));
  targetImage.updatePixels();

  updateZoomImage();

  image(targetImage, 0, 0);
  image(zoomImage, imageWidth, 0);
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
    assert(xpxl1 + 1 < xpxl2);
    for (float x = xpxl1 + 1; x < xpxl2; x++) {
      plot(g, floor(intery)  , x, rfpart(intery));
      plot(g, floor(intery)+1, x,  fpart(intery));
      intery = intery + gradient;
    }
  } else {
    assert(xpxl1 + 1 < xpxl2);
    for (float x = xpxl1 + 1; x < xpxl2; x++) {
      plot(g, x, floor(intery),  rfpart(intery));
      plot(g, x, floor(intery)+1, fpart(intery));
      intery = intery + gradient;
    }
  }
}

void plot(PGraphics g, float x, float y, float v) {
  g.pixels[floor(y) * g.width + floor(x)] = color(v * 255);
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
