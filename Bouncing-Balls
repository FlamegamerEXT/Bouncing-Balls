int RAD = 4;
ArrayList<Ball> balls = new ArrayList<Ball>();

void setup(){
  size(960, 600);
  noFill();
  for (int i = 0; i < 500; i++){
    PVector pos = new PVector(0, 0);
    float random = 0.7+random(0.6);
    float radius = 2*RAD/random;
    boolean collision = true;
    while (collision){
      pos = new PVector(random(width), random(height));
      collision = false;
      for (Ball b : balls){
        collision = collision||(b.overlaps(pos, radius));
      }
    }
    balls.add(new Ball(pos, 1*random, 0.02*random*random, radius));
  }
}

void draw(){
  clear();
  
  // Checks for collision between balls
  for (int i = 0; i < balls.size(); i++){
    Ball b = balls.get(i);
    for (int j = i+1; j < balls.size(); j++){
      Ball other = balls.get(j);
      if (b.overlaps(other)){
        b.collide(other);
      }
    }
  }
  
  // Draw balls
  stroke(182, 193, 255);
  strokeWeight(RAD*0.3);
  for (Ball b : balls){
    b.step();
    b.draw();
  }
}
