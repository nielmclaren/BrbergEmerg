
PImage chargeImage;
ArrayList<Vehicle> vehicles;

void setup() {
  size(800, 800);
  
  chargeImage = loadImage("charge.png");
  vehicles = new ArrayList<Vehicle>();
  
  int numVehicles = 100;
  for (int i = 0; i < numVehicles; i++) {
    Vehicle vehicle = new Vehicle(random(width), random(height), random(2 * PI));
    vehicles.add(vehicle);
  }
}

void draw() {
  background(0);
  
  for (int i = 0; i < vehicles.size(); i++) {
    Vehicle vehicle = vehicles.get(i);
    
    pushMatrix();
    translate(vehicle.x, vehicle.y);
    rotate(vehicle.rotation);
    image(chargeImage, 0, 0);
    popMatrix();
  }
}