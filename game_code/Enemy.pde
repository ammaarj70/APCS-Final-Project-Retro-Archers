public class Enemy extends Entity {
  int shotTimer;
  Player target;
  float inaccuracy;
  float numShots;
  boolean justHit;
  int crawlTimer;

  Enemy(float x, float y, Player target) {
    super(x, y, 32, 82);
    this.target = target;
    shotTimer = 0;
    inaccuracy = 100;
  }

  void updateBot() {
    shotTimer++;
    if (justHit) crawlTimer++;
     if (crawlTimer >= 100) {
       this.vel.x -= 1.2;
       this.vel.y -= 0.3;
       justHit = false;
       crawlTimer = 0;
     }
    if (shotTimer >= 150) {
      fireAtPlayer();
      inaccuracy = max(5, inaccuracy - 3*numShots);
      shotTimer = 0;
    }
  }

  void fireAtPlayer() {
    numShots++;
    float startX = pos.x-25;
    float startY = pos.y + h * 0.35;

    float targetX = target.pos.x+target.w/2 + random(-inaccuracy, inaccuracy);
    float targetY = target.pos.y+target.h/2 + random(-inaccuracy*0.3, inaccuracy*0.3);

    PVector dir = new PVector(targetX-startX, targetY-startY);
    dir.normalize();
    float STRENGTH = 3+(numShots*1.1);
    if (STRENGTH > 10) STRENGTH = 14;
    dir.mult(STRENGTH);

    Arrow a = new Arrow(new PVector(startX, startY), dir, 1);
    a.setOwner("enemy");
    arrows.add(a);
  }
  
  void crawlForward() {
    
  }

  void display() {
    boolean faceLeft = (target.pos.x < pos.x);
    
     // sprite flips to face the player
    pushMatrix();
    translate(pos.x + w / 2, pos.y + h / 2);
    if (faceLeft) scale(-1, 1);
    if (img != null) {
      image(img, -w / 2, -h / 2, w, h);
    } else {
      noStroke();
      fill(220, 80, 60);
      rect(-w / 2, -h / 2, w, h);
    }
    popMatrix();

    // bow points toward the player
    PImage bowImg = this.getBow();
    float tx = target.pos.x + target.w / 2;
    float ty = target.pos.y + target.h * 0.35;
    float bowX = pos.x - w / 2.6;
    float bowY = pos.y + h / 4;
    float bowW  = 13.0 / 1.3;
    float bowH  = 59.0 / 1.3;
    float bowCX = bowX + bowW / 2;
    float bowCY = bowY + bowH / 2;
    float bowAngle = atan2(ty - bowCY, tx - bowCX);
    drawRotated(bowImg, bowX, bowY, bowW, bowH, bowAngle);

    // health bar
    noStroke();
    fill(100, 0, 0);
    rect(pos.x, pos.y - 12, w, 5);
    fill(0, 200, 0);
    rect(pos.x, pos.y - 12, w * ((float) health / maxHealth), 5);
  }
}
