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
final int WIN = 3;
int appleTimer = 0;

void setup() {
  size(800, 600);
  frameRate(60);
  enemies = new ArrayList<Enemy>();
  arrows = new ArrayList<Arrow>();
  apples = new ArrayList<Apple>();
  platforms = new ArrayList<Platform>();
  //platforms.add(new Platform(0, 560, 800, 40));
  platforms.add(new Platform(50, 330, 144, 20));
  //platforms.add(new Platform(460, 400, 144, 20));
  //platforms.add(new Platform(300, 300, 160, 20));
  player = new Player(platforms.get(0).getX()+74, platforms.get(0).getY()-80);
  player.health = 100;
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
    fill(255);
    textSize(48);
    textAlign(CENTER, CENTER);
    text("GAME OVER", width/2, height/2 - 20);
    textSize(20);
    text("Press R to restart", width/2, height/2 + 40);
  } else if (gameState == WIN) {
    fill(255, 220, 50);
    textSize(48);
    textAlign(CENTER, CENTER);
    text("YOU WIN!", width/2, height/2 - 20);
    textSize(20);
    fill(255);
    text("Press R to restart", width/2, height/2 + 40);
  }
}

void updateGame() {
  player.applyPhysics();
  player.regenerateStamina();
  for (Enemy e : enemies) { e.updateBot(); e.applyPhysics(); }
  for (Arrow a : arrows) a.update();
  for (Apple ap : apples) ap.update();
  waveManager.update();
  checkCollisions();

  appleTimer++;
  if (appleTimer >= 300) {
    appleTimer = 0;
    apples.add(new Apple(random(50, 750), random(0, 200), (int)random(3)));
  }
}

void renderGame() {
  for (Platform p : platforms) p.display();
  for (Apple ap : apples) ap.display();
  for (Arrow a : arrows) a.display();
  for (Enemy e : enemies) e.display();
  player.display();
  drawOverlay();
}

void drawOverlay() {
  String[] names = {"", "Standard", "Stun", "Multi"};
  fill(255);
  textSize(16);
  textAlign(LEFT);
  text("Wave: " + max(1, waveManager.currentWave), 10, 25);
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

  // apples - platform
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

  // arrows - platform
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
    if (!a.active || a.onGround || !"player".equals(a.owner)) continue;
    for (Enemy e : enemies) {
      if (a.pos.x + 21 > e.pos.x && a.pos.x - 21 < e.pos.x + e.w &&
          a.pos.y + 5  > e.pos.y && a.pos.y - 5  < e.pos.y + e.h) {
        int dmg = 20;
        if (a.type == 2) { dmg = 15; e.stunTimer = 300; }
        else if (a.type == 3) dmg = 15;
        e.health -= dmg;
        e.vel.x += 2;
        e.vel.y = -1;
        e.onGround = false;
        e.justHit = true;
        a.active = false;
        break;
      }
    }
  }

  // enemy arrows - player
  for (Arrow a : arrows) {
    if (!a.active || a.onGround || !"enemy".equals(a.owner)) continue;
    if (a.pos.x + 21 > player.pos.x && a.pos.x - 21 < player.pos.x + player.w &&
        a.pos.y + 5  > player.pos.y && a.pos.y - 5  < player.pos.y + player.h) {
      player.health -= 15;
      float mag = a.vel.mag();
      if (mag > 0) player.vel.x += (a.vel.x / mag) * 2;
      player.vel.y = -2;
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
  if ((gameState == GAME_OVER || gameState == WIN) && (key == 'r' || key == 'R')) {
    setup();
  }
}

void mousePressed() {if (gameState == PLAYING) player.startAim();}

void mouseDragged() {
  if (gameState == PLAYING) player.updateAim();
}

void mouseReleased() {
  if (gameState == PLAYING) {
    Arrow a = player.releaseAim();
    if (a != null) arrows.add(a);
  }
}
