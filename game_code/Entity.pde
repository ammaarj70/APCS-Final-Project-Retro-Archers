public class Entity {
  PImage img;

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
