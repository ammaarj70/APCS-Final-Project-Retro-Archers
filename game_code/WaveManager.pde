public class WaveManager {
  int currentWave;
  ArrayList<Enemy> enemies;
  ArrayList<Platform> enemyPlatforms;
  int betweenTimer;
  boolean waveActive;

  int[] enemiesPerWave = {1, 1, 2, 2, 3, 3};

  WaveManager(ArrayList<Enemy> enemies) {
    this.enemies = enemies;
    this.enemyPlatforms = new ArrayList<Platform>();
    currentWave = 0;
    betweenTimer = 0;
    waveActive = false;
  }

  void update() {
    if (!waveActive) {
      betweenTimer++;
      if (betweenTimer >= 120) {
        betweenTimer = 0;
        currentWave++;
        if (currentWave > enemiesPerWave.length) {
          gameState = WIN;
          return;
        }
        spawnWave(currentWave);
        waveActive = true;
      }
    } else {
      if (enemies.size() == 0) {
        waveActive = false;
      }
    }
  }

  void spawnWave(int wave) {
    // remove platforms from the previous wave
    for (Platform ep : enemyPlatforms) {
      platforms.remove(ep);
    }
    enemyPlatforms.clear();

    // remove arrows that were resting on those platforms
    for (int i = arrows.size()-1; i >= 0; i--) {
      if (arrows.get(i).onGround) arrows.remove(i);
    }

    int count = enemiesPerWave[wave - 1];
    float zoneW = 480.0 / count;

    for (int i = 0; i < count; i++) {
      float pw = 120;
      float ph = 20;
      float px = 280 + i * zoneW + random(0, max(0, zoneW - pw));
      px = constrain(px, 280, 800 - pw - 10);
      float py = random(180, 430);

      Platform p = new Platform(px, py, pw, ph);
      platforms.add(p);
      enemyPlatforms.add(p);

      float ex = px + pw / 2 - 16;
      float ey = py - 82;
      enemies.add(new Enemy(ex, ey, player));
    }
  }
}
