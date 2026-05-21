public class Arrow {
  PImage arrowImg; // placeholder

  void display() {
    if (arrowImg != null) {
      image(arrowImg, pos.x, pos.y, 20, 6);
    }
  }
}
