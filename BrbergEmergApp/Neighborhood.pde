
class Neighborhood {
  private ArrayList<Vehicle> _vehicles;

  Neighborhood() {
    _vehicles = new ArrayList<Vehicle>();
  }

  ArrayList<Vehicle> vehiclesRef() {
    return _vehicles;
  }

  Neighborhood vehiclesRef(ArrayList<Vehicle> v) {
    _vehicles = v;
    return this;
  }

  float getAveragePrevRotation() {
    if (_vehicles.size() <= 0) {
      return 0;
    }

    float result = 0;
    for (int i = 0; i < _vehicles.size(); i++) {
      result += _vehicles.get(i).prevRotation();
    }

    return (result / _vehicles.size()) % (2 * PI);
  }
}
