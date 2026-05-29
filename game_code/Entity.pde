public class Entity extends Physics {
  int health, maxHealth;
  PImage img;
  PImage bow;
  int aim;
  float bowx = pos.x + w / 1.3;
  float bowy = pos.y+h/4;
  float boww = 13/1.3;
  float bowh = 59/1.3;
  
  Entity(float x, float y, float w, float h) {
    super(x, y, w, h);
    health = 100;
    maxHealth = 100;
    img = loadImage("entity.png");
    bow = loadImage("bow.png");
  }

  void display() {
      image(img, pos.x, pos.y, w, h);
      image(bow, bowx, bowy, boww, bowh);
      fill(150);
      noStroke();
      //rect(pos.x, pos.y, w, h);
  }
  
  void drawRotated(PImage img, float x, float y, float w, float h, float angle) {
    pushMatrix();
    translate(x + w / 2, y + h / 2);
    rotate(angle);
    image(img, -w / 2, -h / 2, w, h);
    popMatrix();
  }
  
  void heal(int healing) {
    this.health += healing;
    if (this.health > maxHealth)
      this.health = maxHealth;
  }
  
  public void setAim(int aim) {
    this.aim = aim;
  }
  
  public int getAim() {
    return this.aim;
  }
  
  public PImage getBow() {
    return this.bow;
  }
  
  public PImage getImage() {
    return this.img;
  }
  
  public float getX() {
    return pos.x;
  }
  
  public float getY() {
    return pos.y;
  }
  
  
}
