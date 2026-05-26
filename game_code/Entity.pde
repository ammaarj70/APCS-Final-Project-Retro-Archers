public class Entity extends Physics {
  int health, maxHealth;
  PImage img;
  PImage bow;
  int aim;
  
  Entity(float x, float y, float w, float h) {
    super(x, y, w, h);
    health = 100;
    maxHealth = 100;
    img = loadImage("entity.png");
    bow = loadImage("bow.png");
  }

  void display() {
      image(img, pos.x, pos.y, w, h);
      image(bow, pos.x+w/1.3, pos.y+h/4, 13/1.3, 59/1.3);
      fill(150);
      noStroke();
      //rect(pos.x, pos.y, w, h);
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
