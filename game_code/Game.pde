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
  enemies = new ArrayList<Enemy>();
  arrows = new ArrayList<Arrow>();
  apples = new ArrayList<Apple>();
  platforms = new ArrayList<Platform>();
  player = new Player(width / 2, height / 2);
  waveManager = new WaveManager(enemies);
  gameState = START;
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
