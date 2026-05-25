public class Physics {
  PVector pos;
  PVector vel;
  float w, h;
  boolean onGround;
  float gravity = 0.1;

  Physics(float x, float y, float w, float h) {
    pos = new PVector(x, y);
    vel = new PVector(0, 0);
    this.w = w;
    this.h = h;
    onGround = false;
  }

  void applyPhysics() {
    if (!onGround) {
      //vel.y += gravity;
    }
    pos.add(vel);
    if (onGround) {
      vel.x *= 0.8;
    }
  }

  float[] getHitBox() {
    return new float[]{ pos.x, pos.y, w, h };
  }
}
