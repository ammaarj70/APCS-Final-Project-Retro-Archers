public class Apple {
  PVector pos;
  float radius;
  int type;
  boolean active;
  PImage appleImg;

  Apple(float x, float y, int type) {
    pos = new PVector(x, y);
    this.type = type;
    this.active = true;
    radius = 14;
  }

  void update() {}

  void display() {
    if (!active) return;
    if (appleImg != null) {
      image(appleImg, pos.x - radius, pos.y - radius, radius * 2, radius * 2);
    } else {
      noStroke();
      if (type == 0) fill(220, 40, 40);
      else if (type == 1) fill(40, 100, 220);
      else fill(220, 200, 40);
      ellipse(pos.x, pos.y, radius * 2, radius * 2);
      stroke(80, 50, 10);
      strokeWeight(2);
      line(pos.x, pos.y - radius, pos.x + 3, pos.y - radius - 5);
      noStroke();
    }
  }
}
