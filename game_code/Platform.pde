public class Platform {
  float x, y, w, h;
  PImage platformImg;

  Platform(float x, float y, float w, float h) {
    this.x = x;
    this.y = y;
    this.w = w;
    this.h = h;
  }

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
