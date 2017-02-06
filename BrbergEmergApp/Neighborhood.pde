
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

  GroupStats getGroupStats() {
    HashMap<Integer, Integer> groupCounts = getGroupCounts();

    GroupStats stats = new GroupStats()
      .groupIds(new ArrayList(groupCounts.keySet()))
      .biggestGroupId(getBiggestGroupId(groupCounts));
    return stats;
  }

  private HashMap<Integer, Integer> getGroupCounts() {
    HashMap<Integer, Integer> result = new HashMap<Integer, Integer>();
    for (Vehicle vehicle : _vehicles) {
      int groupId = vehicle.groupId();
      Integer count = result.get(groupId);
      if (count == null) {
        result.put(groupId, 1);
      } else {
        result.put(groupId, count + 1);
      }
    }
    return result;
  }

  private int getBiggestGroupId(HashMap<Integer, Integer> groupCounts) {
    int biggestGroupId = -1;
    int biggestGroupCount = 0;
    for (HashMap.Entry<Integer, Integer> entry : groupCounts.entrySet()) {
      int groupId = entry.getKey();
      int count = entry.getValue();
      if (count > biggestGroupCount) {
        biggestGroupCount = count;
        biggestGroupId = groupId;
      }
    }
    return biggestGroupId;
  }
}
