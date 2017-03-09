
class ShortImage {
  private short[] _values;
  private PImage _image;
  private boolean _isImageDirty;
  private int _width;
  private int _height;

  ShortImage(int w, int h) {
    _values = new short[w * h * 3];
    _image = new PImage(w, h, RGB);
    _isImageDirty = true;
    _width = w;
    _height = h;
  }

  color getPixel(int x, int y) {
    pushStyle();
    colorMode(RGB, 1);
    color c = color(
        deepToFloat(_values[(y * _width + x) * 3 + 0]),
        deepToFloat(_values[(y * _width + x) * 3 + 1]),
        deepToFloat(_values[(y * _width + x) * 3 + 2]));
    popStyle();
    return c;
  }

  void setPixel(int x, int y, color v) {
    pushStyle();
    colorMode(RGB, 1);

    _values[(y * _width + x) * 3 + 0] = floatToDeep(red(v));
    _values[(y * _width + x) * 3 + 1] = floatToDeep(green(v));
    _values[(y * _width + x) * 3 + 2] = floatToDeep(blue(v));

    _isImageDirty = true;
    popStyle();
  }

  short getRedValue(int x, int y) {
    return _values[(y * _width + x) * 3 + 0];
  }

  short getGreenValue(int x, int y) {
    return _values[(y * _width + x) * 3 + 1];
  }

  short getBlueValue(int x, int y) {
    return _values[(y * _width + x) * 3 + 2];
  }

  void setRedValue(int x, int y, short v) {
    _values[(y * _width + x) * 3 + 0] = v;
    _isImageDirty = true;
  }

  void setGreenValue(int x, int y, short v) {
    _values[(y * _width + x) * 3 + 1] = v;
    _isImageDirty = true;
  }

  void setBlueValue(int x, int y, short v) {
    _values[(y * _width + x) * 3 + 2] = v;
    _isImageDirty = true;
  }

  void setValue(int x, int y, short r, short g, short b) {
    _values[(y * _width + x) * 3 + 0] = r;
    _values[(y * _width + x) * 3 + 1] = g;
    _values[(y * _width + x) * 3 + 2] = b;
    _isImageDirty = true;
  }

  float getFloatRedValue(int x, int y) {
    return deepToFloat(_values[(y * _width + x) * 3 + 0]);
  }

  float getFloatGreenValue(int x, int y) {
    return deepToFloat(_values[(y * _width + x) * 3 + 1]);
  }

  float getFloatBlueValue(int x, int y) {
    return deepToFloat(_values[(y * _width + x) * 3 + 2]);
  }

  void setFloatRedValue(int x, int y, float v) {
    _values[(y * _width + x) * 3 + 0] = floatToDeep(v);
    _isImageDirty = true;
  }

  void setFloatGreenValue(int x, int y, float v) {
    _values[(y * _width + x) * 3 + 1] = floatToDeep(v);
    _isImageDirty = true;
  }

  void setFloatBlueValue(int x, int y, float v) {
    _values[(y * _width + x) * 3 + 2] = floatToDeep(v);
    _isImageDirty = true;
  }

  void setFloatValue(int x, int y, float r, float g, float b) {
    _values[(y * _width + x) * 3 + 0] = floatToDeep(r);
    _values[(y * _width + x) * 3 + 1] = floatToDeep(g);
    _values[(y * _width + x) * 3 + 2] = floatToDeep(b);
    _isImageDirty = true;
  }

  PImage getImageRef() {
    if (_isImageDirty) {
      updateImage();
    }
    return _image;
  }

  void fade(float v) {
    v = constrain(v, 0, 1) * (Short.MAX_VALUE - Short.MIN_VALUE);
    for (int i = 0; i < _values.length; i++) {
      _values[i] = (short)max(_values[i] - v, Short.MIN_VALUE);
    }
    _isImageDirty = true;
  }

  void updateImage() {
    pushStyle();
    colorMode(RGB, 1);
    _image.loadPixels();

    int pixelCount = _width * _height;
    for (int i = 0; i < pixelCount; i++) {
      _image.pixels[i] = color(
          deepToFloat(_values[i * 3 + 0]),
          deepToFloat(_values[i * 3 + 1]),
          deepToFloat(_values[i * 3 + 2]));
    }

    _image.updatePixels();

    _isImageDirty = false;
    popStyle();
  }

  void setImage(PImage inputImg) {
    pushStyle();
    colorMode(RGB, 1);

    inputImg.loadPixels();

    int pixelCount = inputImg.width * inputImg.height;
    for (int i = 0; i < pixelCount; i++) {
      _values[i * 3 + 0] = floatToDeep(red(inputImg.pixels[i]));
      _values[i * 3 + 1] = floatToDeep(green(inputImg.pixels[i]));
      _values[i * 3 + 2] = floatToDeep(blue(inputImg.pixels[i]));
    }

    _isImageDirty = true;
    popStyle();
  }

  void addImage(PImage inputImg) {
    pushStyle();
    colorMode(RGB, 1);

    inputImg.loadPixels();

    int shortRange = Short.MAX_VALUE - Short.MIN_VALUE;
    int pixelCount = inputImg.width * inputImg.height;
    for (int i = 0; i < pixelCount; i++) {
      _values[i * 3 + 0] = (short)min(_values[i * 3 + 0]
          + red(inputImg.pixels[i]) * shortRange, Short.MAX_VALUE);
      _values[i * 3 + 1] = (short)min(_values[i * 3 + 1]
          + green(inputImg.pixels[i]) * shortRange, Short.MAX_VALUE);
      _values[i * 3 + 2] = (short)min(_values[i * 3 + 2]
          + blue(inputImg.pixels[i]) * shortRange, Short.MAX_VALUE);
    }

    _isImageDirty = true;
    popStyle();
  }

  private float deepToFloat(int v) {
    return ((float)v - Short.MIN_VALUE) / (Short.MAX_VALUE - Short.MIN_VALUE);
  }

  private short floatToDeep(float v) {
    return (short)(v * (Short.MAX_VALUE - Short.MIN_VALUE - 1) + Short.MIN_VALUE);
  }
}
