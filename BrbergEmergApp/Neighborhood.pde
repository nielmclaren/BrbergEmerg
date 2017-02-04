
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

  float getAverageRotation() {
    if (_vehicles.size() <= 0) {
      return 0;
    }

    float sum = 0;
    for (int i = 0; i < _vehicles.size(); i++) {
      sum += _vehicles.get(i).rotation();
    }

    return normalizeAngle(sum / _vehicles.size());
  }

  ArrayList<Vehicle> getTooCloseVehicles(Vehicle vehicle) {
    ArrayList<Vehicle> result = new ArrayList<Vehicle>();
    for (int i = 0; i < _vehicles.size(); i++) {
      Vehicle v = _vehicles.get(i);
      if (getDistanceBetween(vehicle, v) < Vehicle.MIN_DISTANCE) {
        result.add(v);
      }
    }
    return result;
  }
}
