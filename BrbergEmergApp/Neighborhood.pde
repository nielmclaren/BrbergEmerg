
class Neighborhood {
  private ArrayList<Vehicle> _inGroupNeighbors;
  private ArrayList<Vehicle> _inGroupTooClose;
  private ArrayList<Vehicle> _outGroupTooClose;

  Neighborhood() {
    _inGroupNeighbors = new ArrayList<Vehicle>();
    _inGroupTooClose = new ArrayList<Vehicle>();
    _outGroupTooClose = new ArrayList<Vehicle>();
  }

  ArrayList<Vehicle> inGroupNeighborsRef() {
    return _inGroupNeighbors;
  }

  Neighborhood inGroupNeighborsRef(ArrayList<Vehicle> v) {
    _inGroupNeighbors = v;
    return this;
  }

  ArrayList<Vehicle> inGroupTooCloseRef() {
    return _inGroupTooClose;
  }

  Neighborhood inGroupTooCloseRef(ArrayList<Vehicle> v) {
    _inGroupTooClose = v;
    return this;
  }

  ArrayList<Vehicle> outGroupTooCloseRef() {
    return _outGroupTooClose;
  }

  Neighborhood outGroupTooCloseRef(ArrayList<Vehicle> v) {
    _outGroupTooClose = v;
    return this;
  }
}
