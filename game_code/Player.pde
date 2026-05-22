public class Player extends Entity {
  float stamina;
  float maxStamina;
  int currentArrowType;
  boolean aiming;
  PVector aimStart;
  PVector aimCurrent;

  Player(float x, float y) {
    super(x, y, 40, 60);
    stamina = 100;
    maxStamina = 100;
    currentArrowType = 1;
    aiming = false;
    aimStart = new PVector(0, 0);
    aimCurrent = new PVector(0, 0);
  }

  void regenerateStamina() {}
  void jump() {}
  void startAim() {}
  void updateAim() {}
  Arrow releaseAim() { return null; }
  void switchArrow(int type) {
    currentArrowType = type;
  }

  void display() {
    fill(60, 130, 220);
    noStroke();
    rect(pos.x, pos.y, w, h);
  }
}
