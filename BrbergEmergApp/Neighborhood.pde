
class Neighborhood {
  private ArrayList<Vehicle> _vehicles;
  private HashMap<Integer, ArrayList<Vehicle>> _groupIdToVehicle;

  Neighborhood() {
    _vehicles = new ArrayList<Vehicle>();
    _groupIdToVehicle = new HashMap<Integer, ArrayList<Vehicle>>();
  }

  ArrayList<Vehicle> vehiclesRef() {
    return _vehicles;
  }

  Neighborhood vehiclesRef(ArrayList<Vehicle> v) {
    _vehicles = v;

    _groupIdToVehicle = new HashMap<Integer, ArrayList<Vehicle>>();
    for (Vehicle vehicle : _vehicles) {
      if (_groupIdToVehicle.containsKey(vehicle.groupId())) {
        _groupIdToVehicle.get(vehicle.groupId()).add(vehicle);
      } else {
        ArrayList<Vehicle> vehicles = new ArrayList<Vehicle>();
        vehicles.add(vehicle);
        _groupIdToVehicle.put(vehicle.groupId(), vehicles);
      }
    }

    return this;
  }

  ArrayList<Vehicle> vehiclesByGroupId(int groupId) {
    ArrayList<Vehicle> vehicles = _groupIdToVehicle.get(groupId);
    if (vehicles == null) {
      return new ArrayList<Vehicle>();
    }
    return vehicles;
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
