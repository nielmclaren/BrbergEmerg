
class GroupStats {
  ArrayList<Integer> _groupIds;
  private int _biggestGroupId;

  GroupStats() {
    _groupIds = new ArrayList<Integer>();
    _biggestGroupId = -1;
  }

  ArrayList<Integer> groupIds() {
    return _groupIds;
  }

  GroupStats groupIds(ArrayList<Integer> v) {
    _groupIds = v;
    return this;
  }

  int biggestGroupId() {
    return _biggestGroupId;
  }

  GroupStats biggestGroupId(int v) {
    _biggestGroupId = v;
    return this;
  }
}
