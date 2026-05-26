public class Arrow {
  PVector pos;
  PVector vel;
  int type;
  boolean active;
  

  Arrow(PVector pos, PVector vel, int type) {
    this.pos = pos.copy();
    this.vel = vel.copy();
    this.type = type;
    this.active = true;
    PImage arrowImg = loadImage("arrow.png");
  }

  void update() {}

  void display() {
    if (arrowImg != null) {
      image(arrowImg, pos.x, pos.y, 200, 60);
    } else {
      translate(pos.x, pos.y);
      stroke(150, 100, 30);
      strokeWeight(2);
      line(-12, 0, 4, 0);
      fill(180, 90, 20);
      noStroke();
      triangle(4, 0, -2, -3, -2, 3);
    }
  }
}
