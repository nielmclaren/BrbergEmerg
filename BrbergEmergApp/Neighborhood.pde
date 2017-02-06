
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

  float getAverageRotation() {
    if (_vehicles.size() <= 0) {
      return 0;
    }

    float sum = 0;
    for (Vehicle vehicle : _vehicles) {
      sum += vehicle.rotation();
    }

    return normalizeAngle(sum / _vehicles.size());
  }

  ArrayList<Vehicle> getTooCloseVehicles(Vehicle vehicle) {
    ArrayList<Vehicle> result = new ArrayList<Vehicle>();
    for (Vehicle v : _vehicles) {
      if (getDistanceBetween(vehicle, v) < World.MIN_DISTANCE) {
        result.add(v);
      }
    }
    return result;
  }
}
