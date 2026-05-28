public class Apple extends Physics {
  int type;
  boolean active;
  PImage appleImg;
  float gravity = 0.1;

  Apple(float x, float y, int type) {
    super(x, y, 12, 12);
    this.type = type;
    this.active = true;
  }

  void update() {
    if (active) {
      vel.add(0, gravity);
      pos.add(vel);
    }
    
  }

  void display() {
    if (!active) return;
    if (appleImg != null) {
      image(appleImg, pos.x - w, pos.y - w, w * 2, w * 2);
    } else {
      noStroke();
      if (type == 0) fill(220, 40, 40);
      else if (type == 1) fill(40, 100, 220);
      else fill(220, 200, 40);
      ellipse(pos.x, pos.y, w * 2, w * 2);
      stroke(80, 50, 10);
      strokeWeight(2);
      line(pos.x, pos.y - w, pos.x + 3, pos.y - w - 5);
      noStroke();
    }
  }
}
