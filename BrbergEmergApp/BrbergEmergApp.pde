
PImage chargeImage;
ArrayList<Vehicle> vehicles;

void setup() {
  size(800, 800);

  chargeImage = loadImage("charge-t.png");
  vehicles = new ArrayList<Vehicle>();

  reset();
}

void reset() {
  clearVehicles();
  setupVehicles();
}

void clearVehicles() {
  vehicles = new ArrayList<Vehicle>();
}

void setupVehicles() {
  int maxVehicles = 100000;
  int numAttempts = 0;
  int maxAttempts = 100000;

  while (vehicles.size() < maxVehicles && numAttempts < maxAttempts) {
    Vehicle vehicle = new Vehicle(random(width), random(height), random(2 * PI));

    if (hasVehicleCollision(vehicle)) {
      numAttempts++;
      continue;
    }

    vehicles.add(vehicle);
    numAttempts = 0;
  }

  println("Resulting number of vehicles: " + vehicles.size());
}

boolean hasVehicleCollision(Vehicle vehicle) {
  for (int i = 0; i < vehicles.size(); i++) {
    Vehicle v = vehicles.get(i);
    if (vehicle.isColliding(v)) {
      return true;
    }
  }
  return false;
}

void draw() {
  background(0);

  for (int i = 0; i < vehicles.size(); i++) {
    Vehicle vehicle = vehicles.get(i);

    pushMatrix();
    translate(vehicle.x(), vehicle.y());
    rotate(vehicle.rotation());
    imageMode(CENTER);
    image(chargeImage, 0, 0);
    popMatrix();
  }
}

void keyReleased() {
  switch (key) {
    case 'e':
      reset();
      break;
    case 'r':
      save("render.png");
      break;
  }
}
