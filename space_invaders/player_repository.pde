// class
class Player {
  int spriteId;
  //int[] initialPos = new int[2];
  int[] pos = new int[2];
  boolean[] keyheld  = {false,false,false};
  int damage;
  float health;
  float maxHealth;
  int shootingSpeed;
  int shootingCooldown = 0;
  int baseShootingCooldown;
  int speed;
  int bulletCount = 2;
  
}

// drawing
void drawPlayer() {
  image(playerSprite,player.pos[0],player.pos[1]);
  int horPadding = -10;
  int vertPadding = 4+playerSprite.height;
  int hBarHeight = 5;
  color healthColor = getHealthColor(player.health,player.maxHealth);

  fill(setOpacity(healthColor,70));
  rect(player.pos[0]+horPadding,player.pos[1] + vertPadding,playerSprite.width-horPadding*2,hBarHeight); // max health bar with reduced opacity 
  fill(healthColor);
  rect(player.pos[0]+horPadding,player.pos[1] + vertPadding,(playerSprite.width-horPadding*2)*(player.health/player.maxHealth),hBarHeight); // current health bar
}

// logic
void addPlayer(int type) {
  if (type == 0) {
    player.maxHealth = 200;
    player.health = player.maxHealth;
    player.damage = 10;
    player.shootingSpeed = 20;
    int[] pos = {width/2 - playerSprite.width/2,height-100};
    player.pos = pos;
    player.speed = 5;
    player.baseShootingCooldown = 10; // 40
  }
}

void updatePlayer() {
  if (player.keyheld[2] == true) {
    if (player.shootingCooldown == 0) {
      addPlayerBullets(player.bulletCount-1);
    }
  }
  
  if (player.keyheld[0] == true) {
    player.pos[0] -= player.speed;
    if (player.pos[0] < 10) {
      player.pos[0] = 10;
    }
    return;
  }
  
  if (player.keyheld[1] == true) {
    player.pos[0] += player.speed;
    if (player.pos[0] > (width - playerSprite.width - 10)) {
      player.pos[0] = width - playerSprite.width - 10;
    }
    return;
  }
  
}