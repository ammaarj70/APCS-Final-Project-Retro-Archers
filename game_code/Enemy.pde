public class Enemy extends Entity {
  int state;
  float stateTimer;
  Player target;

  Enemy(float x, float y, Player target) {
    super(x, y, 38, 58);
    this.target = target;
    state = 0;
    stateTimer = 0;
  }

  void updateBot() {}

  void display() {
    fill(220, 80, 60);
    noStroke();
    rect(pos.x, pos.y, w, h);
  }
}
