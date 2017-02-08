
class Vehicle implements IPositioned {
  // nextX, nextY, nextRotation are not exposed externally.
  private World _world;
  private float _x;
  private float _y;
  private float _nextX;
  private float _nextY;
  private float _velocity;
  private float _rotation;
  private float _nextRotation;

  private ArrayList<Impulse> _impulses;

  private int _groupId;

  private Neighborhood _neighborhood;
  private Attractor _attractor;

  private float _vehicleSizeSq;

  Vehicle(World world, float x, float y, float rotation) {
    _world = world;
    _x = x;
    _y = y;
    _nextX = x;
    _nextY = y;
    _velocity = 3;
    _rotation = rotation;
    _nextRotation = rotation;

    _impulses = new ArrayList<Impulse>();
    _impulses.add(new AttractorImpulse(_world, this));
    _impulses.add(new SeparationImpulse(_world, this));
    _impulses.add(new AlignmentImpulse(_world, this));
    _impulses.add(new CohesionImpulse(_world, this));

    _groupId = -1;

    _neighborhood = new Neighborhood();
    _attractor = null;

    _vehicleSizeSq = 20 * 20;
  }

  World world() {
    return _world;
  }

  Vehicle world(World v) {
    _world = v;
    return this;
  }

  float x() {
    return _x;
  }

  Vehicle x(float v) {
    _x = v;
    _nextX = v;
    return this;
  }

  float y() {
    return _y;
  }

  Vehicle y(float v) {
    _y = v;
    _nextY = v;
    return this;
  }

  float rotation() {
    return _rotation;
  }

  Vehicle rotation(float v) {
    _rotation = v;
    _nextRotation = v;
    return this;
  }

  float velocity() {
    return _velocity;
  }

  Vehicle velocity(float v) {
    _velocity = v;
    return this;
  }

  int groupId() {
    return _groupId;
  }

  Vehicle groupId(int v) {
    _groupId = v;
    return this;
  }

  Neighborhood neighborhoodRef() {
    return _neighborhood;
  }

  Vehicle neighborhoodRef(Neighborhood v) {
    _neighborhood = v;
    return this;
  }

  Attractor attractor() {
    return _attractor.clone();
  }

  Vehicle attractor(Attractor v) {
    _attractor = v;
    return this;
  }

  Vehicle prep() {
    float rotationDelta = 0;
    for (Impulse impulse : _impulses) {
      rotationDelta += impulse.steer(_rotation, 1);
    }

    _nextRotation = normalizeAngle(_rotation + rotationDelta);

    _nextX += _velocity * cos(_nextRotation);
    _nextY += _velocity * sin(_nextRotation);

    updateGroup();

    return this;
  }

  private void updateGroup() {
    if (random(1) < 0.01) {
      int groupId = getRandomGroup(_neighborhood.getGroupStats());
      if (groupId >= 0) {
        _groupId = groupId;
      } else {
        _groupId = _attractor.id();
      }
    }
  }

  private int getRandomGroup(GroupStats groupStats) {
    ArrayList<Integer> groupIds = groupStats.groupIds();
    if (groupIds.size() <= 0) {
      return -1;
    }

    return groupIds.get(floor(random(groupIds.size())));
  }

  Vehicle step() {
    _x = _nextX;
    _y = _nextY;
    _rotation = _nextRotation;
    return this;
  }

  boolean isColliding(Vehicle v) {
    float dx = _x - v.x();
    float dy = _y - v.y();
    return dx * dx + dy * dy < _vehicleSizeSq;
  }

  boolean isColliding(int x, int y) {
    float dx = _x - x;
    float dy = _y - y;
    return dx * dx + dy * dy < _vehicleSizeSq / 4;
  }
}
