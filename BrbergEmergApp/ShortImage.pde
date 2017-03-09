
class ShortImage {
  private int _width;
  private int _height;
  private int _format;
  private int _numChannels;
  private short[] _values;

  private PImage _image;
  private boolean _isImageDirty;

  ShortImage(int w, int h, int format) {
    _width = w;
    _height = h;
    _format = format;
    _numChannels = getNumChannels(format);
    _values = new short[w * h * _numChannels];

    _image = new PImage(w, h, format);
    _isImageDirty = true;
  }

  color getPixel(int x, int y) {
    int pixelIndex = y * _width + x;

    pushStyle();
    colorMode(RGB, 1);
    color c = getColor(pixelIndex);
    popStyle();

    return c;
  }

  void setPixel(int x, int y, color v) {
    pushStyle();
    colorMode(RGB, 1);

    int pixelIndex = y * _width + x;
    setColor(pixelIndex, v);

    _isImageDirty = true;
    popStyle();
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
      _image.pixels[i] = getColor(i);
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
      setColor(i, inputImg.pixels[i]);
    }

    _isImageDirty = true;
    popStyle();
  }

  void addImage(PImage inputImg) {
    pushStyle();
    colorMode(RGB, 1);

    inputImg.loadPixels();

    int pixelCount = inputImg.width * inputImg.height;
    for (int i = 0; i < pixelCount; i++) {
      addColor(i, inputImg.pixels[i]);
    }

    _isImageDirty = true;
    popStyle();
  }

  private int getNumChannels(int format) {
    switch (format) {
      case ALPHA: return 1;
      case RGB: return 3;
      case ARGB: return 4;
      default:
        throw new Error("Bad format. format=" + format);
    }
  }

  // NOTE: colorMode must be set to RGB before calling getColor.
  private color getColor(int pixelIndex) {
    switch (_format) {
      case ALPHA:
        return color(deepToFloat(_values[pixelIndex]));
      case RGB:
        return color(
            deepToFloat(_values[pixelIndex * 3 + 0]),
            deepToFloat(_values[pixelIndex * 3 + 1]),
            deepToFloat(_values[pixelIndex * 3 + 2]));
      case ARGB:
        return color(
            deepToFloat(_values[pixelIndex * 4 + 0]),
            deepToFloat(_values[pixelIndex * 4 + 1]),
            deepToFloat(_values[pixelIndex * 4 + 2]),
            deepToFloat(_values[pixelIndex * 4 + 3]));
      default:
        throw new Error("Bad format. format=" + _format);
    }
  }

  // NOTE: colorMode must be set to RGB before calling setColor.
  private void setColor(int pixelIndex, color v) {
    _values[pixelIndex * _numChannels + 0] = floatToDeep(red(v));
    if (_format == RGB || _format == ARGB) {
      _values[pixelIndex * _numChannels + 1] = floatToDeep(green(v));
      _values[pixelIndex * _numChannels + 2] = floatToDeep(blue(v));
    }
    if (_format == ARGB) {
      _values[pixelIndex * _numChannels + 3] = floatToDeep(alpha(v));
    }
  }

  private void addColor(int pixelIndex, color v) {
    int shortRange = Short.MAX_VALUE - Short.MIN_VALUE;
    float a = alpha(v);

    int i = pixelIndex * _numChannels;

    _values[i + 0] = (short)min(_values[i + 0] + a * red(v) * shortRange, Short.MAX_VALUE);
    if (_format == RGB || _format == ARGB) {
      _values[i + 1] = (short)min(_values[i + 1] + a * green(v) * shortRange, Short.MAX_VALUE);
      _values[i + 2] = (short)min(_values[i + 2] + a * blue(v) * shortRange, Short.MAX_VALUE);
    }
    if (_format == ARGB) {
      _values[i + 3] = (short)min(_values[i + 3] + alpha(v) * shortRange, Short.MAX_VALUE);
    }
  }

  private float deepToFloat(int v) {
    return ((float)v - Short.MIN_VALUE) / (Short.MAX_VALUE - Short.MIN_VALUE);
  }

  private short floatToDeep(float v) {
    return (short)(v * (Short.MAX_VALUE - Short.MIN_VALUE - 1) + Short.MIN_VALUE);
  }
}
