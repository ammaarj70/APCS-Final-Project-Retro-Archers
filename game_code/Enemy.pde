public class Enemy extends Entity {
  int state;
  float stateTimer;
  Player target;
  

  Enemy(float x, float y, Player target) {
    super(x, y, 32, 82);
    this.target = target;
    state = 0;
    stateTimer = 0;
  }

  void updateBot() {}

  void display() {
    if (img != null) {
      image(img, pos.x, pos.y, w, h);
    }
    noStroke();
    fill(180, 0, 0);
    rect(pos.x, pos.y - 12, w, 5);
    fill(0, 200, 0);
    rect(pos.x, pos.y - 12, w * ((float)health / maxHealth), 5);
  }
}
