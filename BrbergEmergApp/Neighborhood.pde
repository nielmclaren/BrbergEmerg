
class Neighborhood {
  private ArrayList<Vehicle> _vehicles;
  private Vehicle _nearestVehicle;

  Neighborhood() {
    _vehicles = new ArrayList<Vehicle>();
    _nearestVehicle = null;
  }

  ArrayList<Vehicle> vehiclesRef() {
    return _vehicles;
  }

  Neighborhood vehiclesRef(ArrayList<Vehicle> v) {
    _vehicles = v;
    return this;
  }

  Vehicle nearestVehicle() {
    return _nearestVehicle;
  }

  Neighborhood nearestVehicle(Vehicle v) {
    _nearestVehicle = v;
    return this;
  }

  float getAveragePrevRotation() {
    if (_vehicles.size() <= 0) {
      return 0;
    }

    float sum = 0;
    for (int i = 0; i < _vehicles.size(); i++) {
      sum += _vehicles.get(i).prevRotation();
    }

    float result = sum / _vehicles.size();
    while (result < 0) {
      result += 2 * PI;
    }
    return result % (2 * PI);
  }
}
