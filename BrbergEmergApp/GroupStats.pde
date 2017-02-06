
class GroupStats {
  private int _biggestGroupId;

  GroupStats() {
    _biggestGroupId = -1;
  }

  int biggestGroupId() {
    return _biggestGroupId;
  }

  GroupStats biggestGroupId(int v) {
    _biggestGroupId = v;
    return this;
  }
}
