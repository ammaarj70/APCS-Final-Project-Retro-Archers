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
  player.health = 50;
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
  for (Enemy e : enemies) {e.updateBot(); e.applyPhysics();}
  for (Arrow a : arrows) a.update();
  for (Apple ap : apples) ap.update();
  waveManager.update();
  checkCollisions();
}

void renderGame() {
  for (Platform p : platforms) p.display();
  for (Apple ap : apples) ap.display();
  for (Arrow a : arrows) a.display();
  for (Enemy e : enemies) e.display();
  player.display();
  drawOverlay();
  appleTimer++;
  if (appleTimer >= 300) {
    appleTimer = 0;
    apples.add(new Apple(random(player.pos.x + 20, 750), random(0, 200), (int)random(3)));
  }
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
  // enemies - platform
  for (Enemy e : enemies) {
    e.onGround = false;
    for (Platform pl : platforms) {
      if (e.vel.y >= 0 &&
          e.pos.x + e.w > pl.x &&
          e.pos.x < pl.x + pl.w &&
          e.pos.y + e.h >= pl.y &&
          e.pos.y + e.h <= pl.y + pl.h) {
        e.pos.y = pl.y - e.h;
        e.vel.y = 0;
        e.onGround = true;
      }
    }
  }
 
  // apples - platform (pos is center, w is radius)
  for (Apple ap : apples) {
    if (!ap.active) continue;
    ap.onGround = false;
    for (Platform pl : platforms) {
      if (ap.vel.y >= 0 &&
          ap.pos.x + ap.w > pl.x &&
          ap.pos.x - ap.w < pl.x + pl.w &&
          ap.pos.y + ap.w >= pl.y &&
          ap.pos.y + ap.w <= pl.y + pl.h) {
        ap.pos.y = pl.y - ap.w;
        ap.vel.y = 0;
        ap.onGround = true;
      }
    }
    if (ap.pos.y > height + 50) ap.active = false;
  }
 
  // arrows - platform (arrow hits platform and stops)
  for (Arrow a : arrows) {
    if (!a.active) continue;
    for (Platform pl : platforms) {
      if (a.pos.x > pl.x && a.pos.x < pl.x + pl.w &&
          a.pos.y > pl.y && a.pos.y < pl.y + pl.h) {
        a.vel.x = 0;
        a.vel.y=0;
        a.onGround = true;
      }
    }
  }
 
  // arrows - enemies (damage + knockback)
  for (Arrow a : arrows) {
    if (!a.active) continue;
    for (Enemy e : enemies) {
      if (a.pos.x + 21 > e.pos.x && a.pos.x - 21 < e.pos.x + e.w &&
          a.pos.y + 5  > e.pos.y && a.pos.y - 5  < e.pos.y + e.h) {
        int dmg = 20;
        if (a.type == 2) dmg = 25;
        else if (a.type == 3) dmg = 15;
        e.health -= dmg;
        e.vel.x += 1;
        e.vel.y = -2;
        e.onGround = false;
        a.active = false;
        break;
      }
    }
  }
  
  // player arrows - apple (health, stamina, both boosts)
  for (Apple e : apples) {
    if (!e.active) continue;
    e.onGround = false;
    for (Arrow a : arrows) {
      if (a.pos.x + 21 > e.pos.x && a.pos.x - 21 < e.pos.x + e.w &&
          a.pos.y + 5  > e.pos.y && a.pos.y - 5  < e.pos.y + e.h && a.onGround == false) {
        e.active = false;
        if (a.owner == "player") {
          if (e.type == 1)
            player.stamina += 30;
          if (e.type == 0)
            player.heal(30);
          if (e.type == 2) {
             player.stamina += 30;
             player.heal(30);
          }
        }
        
      }
    }
  }  
 
  // remove dead or fallen enemies
  for (int i = enemies.size()-1; i >= 0; i--) {
    Enemy e = enemies.get(i);
    if (e.health <= 0 || e.pos.y > height + 50) enemies.remove(i);
  }
 
  // player falls off screen
  if (player.pos.y > height + 50) gameState = GAME_OVER;
}
 
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
}

void keyPressed() {
  if (gameState == PLAYING) {
    if (key == ' ') player.jump();
    if (key == '1') player.switchArrow(1);
    if (key == '2') player.switchArrow(2);
    if (key == '3') player.switchArrow(3);
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
