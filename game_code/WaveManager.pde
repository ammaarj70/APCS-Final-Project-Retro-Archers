public class WaveManager {
  int currentWave;
  ArrayList<Enemy> enemies;
  int spawnTimer;
  boolean firstSpawned;

  WaveManager(ArrayList<Enemy> enemies) {
    this.enemies = enemies;
    currentWave = 1;
    spawnTimer = 0;
    firstSpawned = false;
  }

  void update() {
    if (!firstSpawned) {
      spawnTimer++;
      if (spawnTimer >= 120) {
        enemies.add(new Enemy(520, 472, player));
        firstSpawned = true;
      }
    }
  }
}
