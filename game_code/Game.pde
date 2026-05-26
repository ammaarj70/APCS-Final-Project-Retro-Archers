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
  waveManager = new WaveManager(enemies);
  //arrows.add(new Arrow(new PVector(140, 330), new PVector(1, 2), player.currentArrowType));
  gameState = PLAYING;
}

void draw() {
  background(60, 70, 110);
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
  for (Enemy e : enemies) e.updateBot();
  for (Arrow a : arrows) a.update();
  for (Apple ap : apples) ap.update();
  waveManager.update();
  checkCollisions();
}

void renderGame() {
  player.applyPhysics();
  for (Platform p : platforms) p.display();
  for (Apple ap : apples) ap.display();
  for (Arrow a : arrows) a.display(); System.out.print("HI");
  for (Enemy e : enemies) e.display();
  player.display();
  drawOverlay();
  appleTimer++;
  if (appleTimer >= 300 && apples.size() < 3) {
    appleTimer = 0;
    apples.add(new Apple(random(100, 700), random(80, 200), (int)random(3)));
  }
  waveManager.update();
  checkCollisions();
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
}

void keyPressed() {
  if (gameState == PLAYING) {
    if (key == ' ') player.jump();
    if (key == '1') player.switchArrow(1);
    if (key == '2') player.switchArrow(2);
    if (key == '3') player.switchArrow(3);
  }
}

void mousePressed() {
  if (gameState == PLAYING) player.startAim();
}

void mouseDragged() {
  if (gameState == PLAYING) player.updateAim();
}

void mouseReleased() {
  if (gameState == PLAYING) {
    Arrow a = player.releaseAim();
    if (a != null) arrows.add(a);
  }
}
