public class Player extends Entity {
  float stamina;
  float maxStamina;
  int currentArrowType;
  boolean aiming;
  PVector aimStart;
  PVector aimCurrent;

  Player(float x, float y) {
    super(x, y, 32, 82);
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
    super.display();
    // health bar
    fill(0, 200, 0);
    rect(pos.x, pos.y - 12, w * ((float)health / maxHealth), 5);
    // stamina bar
    fill(0, 50, 150);
    rect(pos.x, pos.y - 20, w, 5);
    fill(0, 150, 255);
    rect(pos.x, pos.y - 20, w * (stamina / maxStamina), 5);
  }
  
  public float getX() {
    return this.x;
  }
  
  public float getY() {
    return this.y;
  }
}
