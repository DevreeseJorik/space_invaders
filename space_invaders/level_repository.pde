// classes
class Difficulty {
  int durationMultiplier;
  int damageMultiplier;
  int shootingSpeedMultiplier;
  int shootingChance;
  int dropChance;
}

class Level {
  int baseDuration;
  SpaceInvader[][] enemyMatrix; //derive rows and cols from this
}

// logic
void createLevels() {
  createDifficulties();
  
  int rowCount = 23;
  int colCount = 3;
  createLevel(rowCount,colCount,0);
  
}

void createLevel(int rows, int cols,int type) {
  if (type == 0) {
      invaders  = new SpaceInvader[cols][rows];
      for (int y = 0; y < cols; y++) {
        for (int x = 0; x < rows; x++) {
           int horPadding = (width - (invSpriteWidth*invaders[y].length))/2;
          SpaceInvader invader = new SpaceInvader();
          invader.damage = 10;
          invader.spriteId = 0;//int(random(0,11)) ; //x%invaderIds;
          invader.clr = #d0ff3d;
          invader.shootingSpeed = 5;
          invader.maxHealth = 50;
          invader.health = invader.maxHealth;
          int[] pos = {horPadding + invSpriteWidth*x,60+invSpriteHeight*y};
          invader.initialPos = pos;
          arrayCopy(invader.initialPos,invader.pos);
          invaders[y][x] = invader;
        }
      }
  addPlayer(0);
  }  
}

void createDifficulties() {
  Difficulty easy = new Difficulty();
  easy.durationMultiplier = 5;
  difficulties = (Difficulty[]) append(difficulties,easy);
  
}
