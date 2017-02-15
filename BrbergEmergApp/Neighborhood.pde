
class Neighborhood {
  private World _world;
  private ArrayList<Vehicle> _vehicles;
  private HashMap<Integer, ArrayList<Vehicle>> _inGroupVehicles;
  private HashMap<Integer, ArrayList<Vehicle>> _outGroupVehicles;

  Neighborhood(World world) {
    _world = world;
    _vehicles = new ArrayList<Vehicle>();
    _inGroupVehicles = new HashMap<Integer, ArrayList<Vehicle>>();
    _outGroupVehicles = new HashMap<Integer, ArrayList<Vehicle>>();
  }

  ArrayList<Vehicle> vehiclesRef() {
    return _vehicles;
  }

  Neighborhood vehiclesRef(ArrayList<Vehicle> v) {
    _vehicles = v;

    _inGroupVehicles = new HashMap<Integer, ArrayList<Vehicle>>();
    for (Vehicle vehicle : _vehicles) {
      if (_inGroupVehicles.containsKey(vehicle.groupId())) {
        _inGroupVehicles.get(vehicle.groupId()).add(vehicle);
      } else {
        ArrayList<Vehicle> vehicles = new ArrayList<Vehicle>();
        vehicles.add(vehicle);
        _inGroupVehicles.put(vehicle.groupId(), vehicles);
      }
    }

    _outGroupVehicles = new HashMap<Integer, ArrayList<Vehicle>>();
    for (int i = 0; i < _world.numGroups(); i++) {
      _outGroupVehicles.put(i, new ArrayList<Vehicle>());
    }
    for (Vehicle vehicle : _vehicles) {
      for (int i = 0; i < _world.numGroups(); i++) {
        if (i != vehicle.groupId()) {
          _outGroupVehicles.get(i).add(vehicle);
        }
      }
    }

    return this;
  }

  ArrayList<Vehicle> inGroupVehicles(int groupId) {
    ArrayList<Vehicle> vehicles = _inGroupVehicles.get(groupId);
    if (vehicles == null) {
      return new ArrayList<Vehicle>();
    }
    return vehicles;
  }

  ArrayList<Vehicle> outGroupVehicles(int groupId) {
    ArrayList<Vehicle> vehicles = _outGroupVehicles.get(groupId);
    if (vehicles == null) {
      return new ArrayList<Vehicle>();
    }
    return vehicles;
  }

  ArrayList<Vehicle> getVehiclesWithin(Vehicle vehicle, float distance) {
    return (ArrayList<Vehicle>)getItemsWithin(_vehicles, vehicle, distance);
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
