
class Partition {
  private HashMap<Integer, ArrayList<Vehicle>> _vehiclesMap;
  private int _width;
  private int _height;
  private int _size;
  private int _numCols;
  private int _numRows;

  Partition(int width, int height, int partitionSize) {
    _vehiclesMap = new HashMap<Integer, ArrayList<Vehicle>>();
    _width = width;
    _height = height;
    _size = partitionSize;
    _numCols = ceil((float)_width / _size);
    _numRows = ceil((float)_height / _size);
  }

  public Partition update(ArrayList<Vehicle> vehicles) {
    clear();

    for (Vehicle vehicle : vehicles) {
      int col = floor(vehicle.x() / _size);
      int row = floor(vehicle.y() / _size);
      int index = row * _numCols + col;

      ArrayList<Vehicle> vehiclesAtIndex = _vehiclesMap.get(index);
      if (vehiclesAtIndex == null) {
        println(vehicle.x(), vehicle.y(), col, row, _numCols, _numRows);
      }
      vehiclesAtIndex.add(vehicle);
    }

    return this;
  }

  private void clear() {
    _vehiclesMap = new HashMap<Integer, ArrayList<Vehicle>>();
    for (int i = 0; i < _numCols * _numRows; i++) {
      _vehiclesMap.put(i, new ArrayList<Vehicle>());
    }
  }

  public ArrayList<Vehicle> getVehiclesWithin(float x, float y, float radius) {
    return getVehiclesWithin(x, y, radius, null);
  }

  public ArrayList<Vehicle> getVehiclesWithin(float x, float y, float radius, Vehicle except) {
    ArrayList<Vehicle> result = new ArrayList<Vehicle>();

    int exceptId = except == null ? -1 : except.id();
    int col = floor(x / _size);
    int row = floor(y / _size);
    int partitionRadius = ceil(radius / _size);

    for (int c = col - partitionRadius; c <= col + partitionRadius; c++) {
      if (c >= 0 && c < _numCols) {
        for (int r = row - partitionRadius; r <= row + partitionRadius; r++) {
          if (r >= 0 && r < _numRows) {
            int index = r * _numCols + c;
            result.addAll(getVehiclesWithin(_vehiclesMap.get(index), x, y, radius, exceptId));
          }
        }
      }
    }

    return result;
  }

  private ArrayList<Vehicle> getVehiclesWithin(ArrayList<Vehicle> vehicles, float x, float y, float radius, int exceptId) {
    ArrayList<Vehicle> result = new ArrayList<Vehicle>();
    float radiusSq = radius * radius;

    for (Vehicle v : vehicles) {
      if (v.id() != exceptId) {
        float dx = v.x() - x;
        float dy = v.y() - y;
        if (dx * dx + dy * dy < radiusSq) {
          result.add(v);
        }
      }
    }

    return result;
  }

  public ArrayList<Vehicle> getInGroupVehiclesWithin(float x, float y, float radius, int groupId) {
    return getInGroupVehiclesWithin(x, y, radius, groupId, null);
  }

  public ArrayList<Vehicle> getInGroupVehiclesWithin(float x, float y, float radius, int groupId, Vehicle except) {
    ArrayList<Vehicle> result = new ArrayList<Vehicle>();

    int exceptId = except == null ? -1 : except.id();
    int col = floor(x / _size);
    int row = floor(y / _size);
    int partitionRadius = ceil(radius / _size);

    for (int c = col - partitionRadius; c <= col + partitionRadius; c++) {
      if (c >= 0 && c < _numCols) {
        for (int r = row - partitionRadius; r <= row + partitionRadius; r++) {
          if (r >= 0 && r < _numRows) {
            int index = r * _numCols + c;
            // TODO: Could optimize by combining getVehiclesWithin and getInGroupVehicles.
            result.addAll(getVehiclesWithin(
                  getInGroupVehicles(_vehiclesMap.get(index), groupId), x, y, radius, exceptId));
          }
        }
      }
    }

    return result;
  }

  private ArrayList<Vehicle> getInGroupVehicles(ArrayList<Vehicle> vehicles, int groupId) {
    ArrayList<Vehicle> result = new ArrayList<Vehicle>();
    for (Vehicle vehicle : vehicles) {
      if (vehicle.groupId() == groupId) {
        result.add(vehicle);
      }
    }
    return result;
  }

  public ArrayList<Vehicle> getOutGroupVehiclesWithin(float x, float y, float radius, int groupId) {
    return getOutGroupVehiclesWithin(x, y, radius, groupId, null);
  }

  public ArrayList<Vehicle> getOutGroupVehiclesWithin(float x, float y, float radius, int groupId, Vehicle except) {
    ArrayList<Vehicle> result = new ArrayList<Vehicle>();

    int exceptId = except == null ? -1 : except.id();
    int col = floor(x / _size);
    int row = floor(y / _size);
    int partitionRadius = ceil(radius / _size);

    for (int c = col - partitionRadius; c <= col + partitionRadius; c++) {
      if (c >= 0 && c < _numCols) {
        for (int r = row - partitionRadius; r <= row + partitionRadius; r++) {
          if (r >= 0 && r < _numRows) {
            int index = r * _numCols + c;
            // TODO: Could optimize by combining getVehiclesWithin and getInGroupVehicles.
            result.addAll(getVehiclesWithin(
                  getOutGroupVehicles(_vehiclesMap.get(index), groupId), x, y, radius, exceptId));
          }
        }
      }
    }

    return result;
  }

  private ArrayList<Vehicle> getOutGroupVehicles(ArrayList<Vehicle> vehicles, int groupId) {
    ArrayList<Vehicle> result = new ArrayList<Vehicle>();
    for (Vehicle vehicle : vehicles) {
      if (vehicle.groupId() != groupId) {
        result.add(vehicle);
      }
    }
    return result;
  }

  private void dump() {
    for (int c = 0; c < _numCols; c++) {
      for (int r = 0; r < _numRows; r++) {
        int index = r * _numCols + c;
        ArrayList<Vehicle> partitionVehicles = _vehiclesMap.get(index);
        if (partitionVehicles.size() > 0) {
          println(c, r, partitionVehicles.size());
        }
      }
    }
  }
}
