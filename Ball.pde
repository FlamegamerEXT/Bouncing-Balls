float MIN_VALUE = 0.0000001;

public class Ball {
  PVector pos, vel;
  float vMax, aMax, radius, density;
  
  public Ball(PVector p, float vm, float am, float r){
    pos = p;
    float angle = random(TWO_PI);
    vel = new PVector(cos(angle), sin(angle));
    vMax = max(abs(vm), MIN_VALUE);  // Must be a positive value
    radius = abs(r);
    aMax = abs(am);
    density = 1;
    
    vel.normalize();
    vel.mult(vMax);
  }
  
  /** Returns this ball's density value */
  public float getDensity(){
    return density;
  }
  
  /** Changes this ball's density value */
  public void setDensity(float d){
    density = max(abs(d), MIN_VALUE);
  }
  
  /** Returns the ball's radius */
  public float getRadius(){
    return radius;
  }
  
  /** Gives the ball a new radius */
  public void setRadius(float r){
    radius = max(abs(r), MIN_VALUE);
  }
  
  /** Returns the ball's position */
  public PVector getPos(){
    return pos.copy();
  }
  
  /** Gives the ball a new position */
  public void setPos(PVector p){
    pos = p;
    normalizePos();  // Change velocity to be towards the displayed area if moved outside it
  }
  
  /** Returns the ball's velocity */
  public PVector getVel(){
    return vel.copy();
  }
  
  /** Gives the ball a new velocity */
  public void setVel(PVector v){
    vel = v;
  }
  
  /** Changes the ball's position and velocity to simulate an elastic collision */
  public void collide(Ball other){
    // Gather variables
    float thisMass = pow(radius, 2)*density;
    float otherMass = pow(other.getRadius(), 2)*density;
    PVector otherPos = other.getPos();
    PVector otherVel = other.getVel();
    PVector thisVel = vel;
    
    // Move back to before collision
    float velSum = vel.mag() + otherVel.mag();
    float overlapAmount = radius + other.getRadius() - getDistance(other);
    if (overlapAmount < 0) { return; }
    float undoProportion = max(overlapAmount/velSum, 1);
    otherVel.mult(undoProportion);
    thisVel.mult(undoProportion);
    pos.sub(thisVel);
    otherPos.sub(otherVel);
    other.setPos(otherPos);
    
    // Calculate new variables
    float thisVx = newVel(thisMass, vel.x, otherMass, otherVel.x);
    float thisVy = newVel(thisMass, vel.y, otherMass, otherVel.y);
    float otherVx = newVel(otherMass, otherVel.x, thisMass, vel.x);
    float otherVy = newVel(otherMass, otherVel.y, thisMass, vel.y);
    
    // Set new velocities
    thisVel = new PVector(thisVx, thisVy);
    vel = thisVel;
    otherVel = new PVector(otherVx, otherVy);
    other.setVel(otherVel);
    
    // Move forward one step
    otherVel.mult(undoProportion);
    thisVel.mult(undoProportion);
    pos.add(thisVel);
    otherPos.add(otherVel);
    other.setPos(otherPos);
  }
  
  /** Calculates the new velocity for ball 1 after colliding with ball 2 */
  public float newVel(float m1, float v1, float m2, float v2){
    return (m1-m2)/(m1+m2)*v1 + 2*m2/(m1+m2)*v2;
  }
  
  /** Updates the ball's velocity and position after one step */
  public void step(){
    // Update velocity, move value towards having vel.mag() == vMax
    vel.div(vMax);
    vel.mult(pow(vel.mag(), -0.1));  // So we don't get a large amount of acceleration
    float mag = vel.mag();
    vel.normalize();
    vel.mult(vMax*mag);
    
    // Update position
    pos.add(vel);
    normalizePos();
  }
  
  /** Returns the distance between this ball and the given position */
  public float getDistance(PVector otherPos){
    return pow(pow(pos.x - otherPos.x, 2) + pow(pos.y - otherPos.y, 2), 0.5);
  }
  
  /** Returns the distance between this ball and the other ball */
  public float getDistance(Ball other){
    return getDistance(other.getPos());
  }
  
  /** Returns whether this ball and the given position and radius overlap */
  public boolean overlaps(PVector otherPos, float r){
    if (pos == otherPos){ return false; }
    float distance = pow(pow(pos.x - otherPos.x, 2) + pow(pos.y - otherPos.y, 2), 0.5);
    float radii = radius + r;
    return (distance < radii);
  }
  
  /** Returns whether this ball and the other ball overlap */
  public boolean overlaps(Ball other){
    return overlaps(other.getPos(), other.getRadius());
  }
  
  /** Change velocity to be towards the displayed area if moved outside it */
  private void normalizePos(){
    if (pos.x < radius) { vel = new PVector(abs(vel.x), vel.y); }
    else if (pos.x > width-radius) { vel = new PVector(-abs(vel.x), vel.y); }
    if (pos.y < radius) { vel = new PVector(vel.x, abs(vel.y)); }
    else if (pos.y > height-radius) { vel = new PVector(vel.x, -abs(vel.y)); }
  }
  
  /** Draws a circle to represent the ball */
  public void draw(){
    ellipse(pos.x, pos.y, radius*2, radius*2);
  }
}
