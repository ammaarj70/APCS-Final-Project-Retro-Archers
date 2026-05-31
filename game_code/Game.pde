Player player;
WaveManager waveManager;
ArrayList<Enemy> enemies;
ArrayList<Arrow> arrows;
ArrayList<Apple> apples;
ArrayList<Platform> platforms;
int gameState;

final int START = 0;
final int PLAYING = 1;
final int GAME_OVER = 2;
int appleTimer = 0;

void setup() {
  size(800, 600);
  frameRate(60);
  enemies = new ArrayList<Enemy>();
  arrows = new ArrayList<Arrow>();
  apples = new ArrayList<Apple>();
  platforms = new ArrayList<Platform>();
  //platforms.add(new Platform(0, 560, 800, 40));
  platforms.add(new Platform(50, 330, 180, 20));
  platforms.add(new Platform(460, 400, 180, 20));
  //platforms.add(new Platform(300, 300, 160, 20));
  player = new Player(platforms.get(0).getX()+74+50, platforms.get(0).getY()-80);
  player.health = 90;
  waveManager = new WaveManager(enemies);
  //arrows.add(new Arrow(new PVector(140, 330), new PVector(1, 2), player.currentArrowType));
  gameState = PLAYING;
}

void draw() {
  background(136, 8, 8);
  if (gameState == START) {
  } else if (gameState == PLAYING) {
    updateGame();
    renderGame();
  } else if (gameState == GAME_OVER) {
  }
}

void updateGame() {
  player.applyPhysics();
  player.regenerateStamina();

  for (Enemy e : enemies) { e.applyPhysics(); e.updateBot(); }
  for (Arrow a : arrows)  a.update();
  for (Apple ap : apples) ap.update();

  waveManager.update();
  checkCollisions();

  appleTimer++;
  if (appleTimer >= 300) {
    appleTimer = 0;
    apples.add(new Apple(random(player.pos.x + 20, 750), random(0, 200), (int)random(3)));
  }

  for (int i = arrows.size()-1; i >= 0; i--) {
    if (!arrows.get(i).active) arrows.remove(i);
  }
  for (int i = apples.size()-1; i >= 0; i--) {
    if (!apples.get(i).active) apples.remove(i);
  }
}

void renderGame() {
  for (Platform p  : platforms) p.display();
  for (Apple ap    : apples)    ap.display();
  for (Arrow a     : arrows)    a.display();
  for (Enemy e     : enemies)   e.display();
  player.display();
  drawOverlay();
}

void drawOverlay() {
  String[] names = {"", "Standard", "Stun", "Multi"};
  fill(255);
  textSize(16);
  textAlign(LEFT);
  text("Wave: " + waveManager.currentWave, 10, 25);
  text("Arrow: " + names[player.currentArrowType], 10, 45);
}

void checkCollisions() {
  // player - platform
  player.onGround = false;
  for (Platform p : platforms) {
    if (player.vel.y >= 0 &&
        player.pos.x + player.w > p.x &&
        player.pos.x < p.x + p.w &&
        player.pos.y + player.h >= p.y &&
        player.pos.y + player.h <= p.y + p.h) {
      player.pos.y = p.y - player.h;
      player.vel.y = 0;
      player.onGround = true;
    }
  }

  // enemies - platform
  for (Enemy e : enemies) {
    e.onGround = false;
    for (Platform p : platforms) {
      if (e.vel.y >= 0 &&
          e.pos.x + e.w > p.x &&
          e.pos.x < p.x + p.w &&
          e.pos.y + e.h >= p.y &&
          e.pos.y + e.h <= p.y + p.h) {
        e.pos.y = p.y - e.h;
        e.vel.y = 0;
        e.onGround = true;
      }
    }
  }

  // apples - platform (pos is center, w is radius)
  for (Apple ap : apples) {
    if (!ap.active) continue;
    ap.onGround = false;
    for (Platform p : platforms) {
      if (ap.vel.y >= 0 &&
          ap.pos.x + ap.w > p.x &&
          ap.pos.x - ap.w < p.x + p.w &&
          ap.pos.y + ap.w >= p.y &&
          ap.pos.y + ap.w <= p.y + p.h) {
        ap.pos.y = p.y - ap.w;
        ap.vel.y = 0;
        ap.onGround = true;
      }
    }
    if (ap.pos.y > height + 50) ap.active = false;
  }

  // arrows - platform (arrow sticks to it)
  for (Arrow a : arrows) {
    if (!a.active || a.onGround) continue;
    for (Platform p : platforms) {
      if (a.pos.x > p.x && a.pos.x < p.x + p.w &&
          a.pos.y > p.y && a.pos.y < p.y + p.h) {
        a.vel.x = 0;
        a.vel.y = 0;
        a.onGround = true;
      }
    }
  }

  // player arrows - enemies
  for (Arrow a : arrows) {
    if (!a.active || a.onGround || a.owner.equals("enemy")) continue;
    for (Enemy e : enemies) {
      if (a.pos.x + 21 > e.pos.x && a.pos.x - 21 < e.pos.x + e.w &&
          a.pos.y + 5  > e.pos.y && a.pos.y - 5  < e.pos.y + e.h) {
        int dmg = 20;
        e.health -= dmg;
        e.vel.x += 3;
        e.vel.y = -2;
        e.onGround = false;
        a.active = false;
        break;
      }
    }
  }

  // enemy arrows - player
  for (Arrow a : arrows) {
    if (!a.active || a.onGround || a.owner.equals("player")) continue;
    if (a.pos.x + 21 > player.pos.x && a.pos.x - 21 < player.pos.x + player.w &&
        a.pos.y + 5  > player.pos.y && a.pos.y - 5  < player.pos.y + player.h) {
      int dmg = 20;
      player.health -= dmg;
      player.vel.x -= 3;
      player.vel.y = 2;
      player.onGround = false;
      a.active = false;
    }
  }

  // player arrows - apples
  for (Apple ap : apples) {
    if (!ap.active) continue;
    for (Arrow a : arrows) {
      if (!a.active || a.onGround || !"player".equals(a.owner)) continue;
      if (a.pos.x + 21 > ap.pos.x - ap.w && a.pos.x - 21 < ap.pos.x + ap.w &&
          a.pos.y + 5  > ap.pos.y - ap.w && a.pos.y - 5  < ap.pos.y + ap.w) {
        ap.active = false;
        if (ap.type == 0) player.heal(30);
        if (ap.type == 1) player.stamina = min(player.stamina + 30, player.maxStamina);
        if (ap.type == 2) { player.heal(30); player.stamina = min(player.stamina + 30, player.maxStamina); }
        a.active = false;
      }
    }
  }

  // remove dead or fallen enemies
  for (int i = enemies.size()-1; i >= 0; i--) {
    Enemy e = enemies.get(i);
    if (e.health <= 0 || e.pos.y > height + 50) enemies.remove(i);
  }

  // player falls or dies
  if (player.pos.y > height + 50 || player.health <= 0) gameState = GAME_OVER;
}

void keyPressed() {
  if (gameState == PLAYING) {
    if (key == ' ') player.jump();
    if (key == '1') player.switchArrow(1);
    if (key == '2') player.switchArrow(2);
    if (key == '3') player.switchArrow(3);
  }
}

void mousePressed() { if (gameState == PLAYING) player.startAim(); }

void mouseDragged() {
  if (gameState == PLAYING) player.updateAim();
}

void mouseReleased() {
  if (gameState == PLAYING) {
    Arrow a = player.releaseAim();
    if (a != null) arrows.add(a);
  }
}
