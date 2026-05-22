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

void setup() {
  size(800, 600);
  frameRate(60);
  enemies = new ArrayList<Enemy>();
  arrows = new ArrayList<Arrow>();
  apples = new ArrayList<Apple>();
  platforms = new ArrayList<Platform>();
  platforms.add(new Platform(0, 560, 800, 40));
  platforms.add(new Platform(150, 430, 180, 20));
  platforms.add(new Platform(460, 400, 180, 20));
  platforms.add(new Platform(300, 300, 160, 20));
  player = new Player(340, 500);
  waveManager = new WaveManager(enemies);
  gameState = PLAYING;
}

void draw() {
  background(0);
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
  for (Platform p : platforms) p.display();
  for (Apple ap : apples) ap.display();
  for (Arrow a : arrows) a.display();
  for (Enemy e : enemies) e.display();
  player.display();
  drawOverlay();
}

void drawOverlay() {
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
