
PImage inputImg;
ShortImage img;

int imageWidth = 800;
int imageHeight = 800;

void setup() {
  size(1600, 800, P3D);

  inputImg = loadImage("input.png");
  img = new ShortImage(imageWidth, imageHeight);

  img.setImage(inputImg);
}

void draw() {
  img.fade(0.001);
  PImage outputImg = img.getImageRef();

  image(inputImg, 0, 0);
  image(outputImg, imageWidth, 0);
}

void mouseReleased() {
  int x = mouseX > imageWidth ? mouseX - imageWidth : mouseX;
  int y = mouseY;

  PImage outputImage = img.getImageRef();
  outputImage.loadPixels();
  color c = outputImage.pixels[y * outputImage.width + x];
  println(x, "\t", y, "\t", red(c), green(c), blue(c), alpha(c));

  outputImage.save("render.png");
}

