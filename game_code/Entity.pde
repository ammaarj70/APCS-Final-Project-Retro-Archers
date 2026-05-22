public class Entity extends Physics {
  PImage img;

  Entity(float x, float y, float w, float h) {
    super(x, y, w, h);
  }

  void display() {
    if (img != null) {
      image(img, pos.x, pos.y, w, h);
    } else {
      fill(150);
      noStroke();
      rect(pos.x, pos.y, w, h);
    }
  }
}
