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

  void regenerateStamina() {
    if (aiming) {
      stamina -=0.3;
      if (stamina <= 0) {
        stamina = 0;
        aiming = false;
      }
    } 
    else {
      stamina += 0.2;
      if (stamina > maxStamina) 
        stamina = maxStamina;
    }
  }
  void jump() {
    if (stamina >= 15) {
      vel.y = -9;
      onGround = false;
      stamina -= 33;
    }
  }
  void startAim() {
    if (stamina > 0) {
      stamina -= 10;
      aiming = true;
      aimStart = new PVector(mouseX, mouseY);
      aimCurrent = aimStart.copy();
    }
  }
  
  void updateAim() {
    if (aiming) {
      aimCurrent = new PVector(mouseX, mouseY);
    }
  }
  
  Arrow releaseAim() { 
  if (!aiming) 
    return null;
    aiming = false;
 
    float bowCX = pos.x + w/1.3 + (13.0/1.3)/2;
    float bowCY = pos.y + h/4   + (59.0/1.3)/2;
    PVector bowPos = new PVector(bowCX, bowCY);
    PVector dir = PVector.sub(new PVector(mouseX, mouseY), bowPos);//took a while to fix this: arrow once fired needs to be independent of the bow
    if (dir.mag() < 5) return null;
 
    //THIS WAS A MISTAKE: REPLACE THIS WITH TIME SPENT CLICKING INSTEAD OF BASING SPEED OFF OF WHERE THE MOUSE IS
    float speed = 8;
    dir.normalize(); //necessary for speed to be accurate
    dir.mult(speed);
 
    if (currentArrowType == 3) { //STILL TESTING
      if (stamina < 15) return null;
      stamina -= 15;
      PVector left = dir.copy();
      left.rotate(0.3);
      PVector right = dir.copy();
      right.rotate(-0.3);
      arrows.add(new Arrow(bowPos.copy(), left, 3));
      arrows.add(new Arrow(bowPos.copy(), right, 3));
    } else if (currentArrowType == 2) {
      if (stamina < 10) return null;
      stamina -= 10;
    }
 
    Arrow newArrow = new Arrow(bowPos, dir, currentArrowType);
    newArrow.setOwner("player");
    return newArrow;
  
  }
  
  
  void switchArrow(int type) {
    currentArrowType = type;
  }

  //i had to do a bunch of research on these methods to figure out how to do this: pushMatrix, popMatrix, translate, scale, atan2, normalize, and strokeweight
  void display() {
    // sprite flips to face the mouse
    pushMatrix();
    translate(pos.x + w / 2, pos.y + h / 2);
    if (mouseX < pos.x + w/2) 
      scale(-1, 1); // this will flip the sprite
    if (img != null) {
      image(img, -w /2, -h/2, w, h);
    } 
    else {
      noStroke();
      fill(60, 130, 220);
      rect(-w/2, -h /2, w, h);
    }
    popMatrix();
    
    float bowBX = pos.x + w/1.3;
    float bowBY = pos.y + h/4;
    float bowW  = (float)(13.0/1.3);
    float bowH  = (float)(59.0/1.3);
    float bowCX = bowBX + bowW/2;
    float bowCY = bowBY + bowH/2;
 
    // bow always rotates toward mouse
    float bowAngle = atan2(mouseY - bowCY, mouseX - bowCX);
    drawRotated(bow, bowBX, bowBY, bowW, bowH, bowAngle);
 
    // aim line shows fire direction (also for debugging)
    if (aiming) {
      PVector dir = PVector.sub(new PVector(mouseX, mouseY), new PVector(bowCX, bowCY));
      dir.normalize();   
      stroke(255, 255, 0, 180); 
      strokeWeight(1); 
      line(bowCX, bowCY, bowCX + dir.x * 60, bowCY + dir.y * 60);
      noStroke();   
    }
 
    // health bar
    noStroke();
    fill(180, 0, 0);
    rect(pos.x, pos.y - 12, w, 5);
    fill(0, 200, 0);
    rect(pos.x, pos.y - 12, w * ((float)health / maxHealth), 5);
 
    // stamina bar
    fill(0, 50, 150);
    rect(pos.x, pos.y - 20, w, 5);
    fill(0, 150, 255);
    rect(pos.x, pos.y - 20, w * (stamina / maxStamina), 5);
  }
  
  public float getX() {
    return pos.x;
  }
  
  public float getY() {
    return pos.y;
  }
}
