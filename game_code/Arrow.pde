public class Arrow {
  PVector pos;
  PVector vel;
  int type;
  boolean active;
  PImage arrowImg;
  PVector gravity = new PVector(0, 0.06);
  float angle;
  String owner;
  boolean onGround = false;
  
  

  Arrow(PVector pos, PVector vel, int type) {
    this.pos = pos.copy();
    this.vel = vel.copy();
    this.type = type;
    this.active = true;
    arrowImg = loadImage("arrow.png");
  }
  
  void update() {
    if (!active || onGround) 
      return;
    pos.add(vel);
    vel.add(gravity);
    if (pos.x < 0 || pos.x > width || pos.y < 0 || pos.y > height) {
      active = false;
    }
  }

  void display() {
    if (!active) return;
    angle = atan2(vel.y, vel.x);
    if (arrowImg != null) {
      // pos is the arrow center. offset by half-dims to get top-left for drawRotated
      drawRotated(arrowImg, pos.x - 21, pos.y - 5, 43, 10, angle);
    }
  }
  
  void setOwner(String who) {
    this.owner = who;
  }
  
  void drawRotated(PImage img, float x, float y, float w, float h, float angle) {
    pushMatrix();
    translate(x + w / 2, y + h / 2);
    rotate(angle);
    image(img, -w / 2, -h / 2, w, h);
    popMatrix();
  }
  
  
}
