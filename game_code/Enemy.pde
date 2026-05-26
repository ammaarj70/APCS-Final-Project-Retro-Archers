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
    boolean faceLeft = (target.pos.x < pos.x);
 
    // sprite flips to face the player
    pushMatrix();
    translate(pos.x + w / 2, pos.y + h / 2);
    if (faceLeft) scale(-1, 1);
    if (img != null) {
      image(img, -w / 2, -h / 2, w, h);
    }
    popMatrix();
 
    // bow points toward the player
    PImage bowImg = this.getBow();
    if (bowImg != null) {
      float tx = target.pos.x + target.w / 2;
      float ty = target.pos.y + target.h * 0.35;
      float bowAngle = atan2(ty - (pos.y + h * 0.35), tx - (pos.x + w / 2));
      drawRotated(bowImg, pos.x + w / 2 - 10, pos.y + h * 0.35 - 45, 20, 90, bowAngle);
    }
  }
}
