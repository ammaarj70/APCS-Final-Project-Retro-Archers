public class Platform {
  PImage platformImg; // placeholder

  void display() {
    if (platformImg != null) {
      image(platformImg, x, y, w, h);
    } else {
      fill(100, 70, 40);
      stroke(70, 50, 25);
      strokeWeight(1);
      rect(x, y, w, h);
    }
  }
}
