public class WaveManager {
  int currentWave;
  ArrayList<Enemy> enemies;
  int betweenTimer;
  boolean waveActive;

  int[] enemiesPerWave = {1, 1, 2, 2, 3, 3};

  WaveManager(ArrayList<Enemy> enemies) {
    this.enemies = enemies;
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
    }
  }
}
