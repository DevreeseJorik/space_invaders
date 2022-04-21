// class
int discocounter = 0;

class SpaceInvader{
  int spriteId;
  int[] initialPos = new int[2];
  int[] pos = new int[2];
  int scoreWorth = 100;
  color clr;
  float health;
  float maxHealth;
  int damage;
  int shootingSpeed;
  int shootingCooldown = 0;
  int baseShootingCooldown = 100;
  int framesUntilRemoval = 20; // remove sprite after several frames of death animation
  int dropChance = 10;
  boolean isDead = false;  
}

// drawing
void drawHealthBar(SpaceInvader obj, float percentageHealth) {
  int horPadding = 20;
  int vertPadding = 8;
  int hBarHeight = 4;
  fill(setOpacity(obj.clr,70));
  rect(obj.pos[0]+horPadding,obj.pos[1] + vertPadding,invSpriteWidth-horPadding*2,hBarHeight); // max health bar with reduced opacity 
  fill(obj.clr);
  rect(obj.pos[0]+horPadding,obj.pos[1] + vertPadding,(invSpriteWidth-horPadding*2)*percentageHealth,hBarHeight); // current health bar
}

// logic
void addXOffsetInvaders () {
  moveFrame = cFrame%(moveFrameCount+1)/moveFrameCount; //becomes 1 once every moveFrameCount's, otherwise 0
  
  invaderXOffs = invaderXOffs + horInterval*moveFrame;

  if (invaderXOffs == horInterval*spriteMoveCount) {
    horInterval = -horInterval;
  }
  
  for (int y = 0; y < invaders.length; y++) {
    for (int x = 0; x < invaders[y].length; x++) {
      int[] pos = new int[2];
      arrayCopy(invaders[y][x].initialPos,pos); // otherwise you'll get both arrays using the same array
      pos[0] += invaderXOffs;
      
      invaders[y][x].pos = pos;
    }
  } 
}

void updateInvaders() {
  for (int y = 0; y < invaders.length; y++) {
    for (int x = 0; x < invaders[y].length; x++) {
      updateInvader(invaders[y][x]);
      if (invaders[y][x].shootingCooldown != 0) {
         invaders[y][x].shootingCooldown--;
      }
    }
  }
  drawInvaderBullets();
  updateInvaderBullets();
}

void updateInvader(SpaceInvader obj) {
  float percentageHealth = (obj.health/obj.maxHealth);
  PImage sprite = getSpriteInvader(obj,percentageHealth);
  if (sprite != null) {
    image(sprite,obj.pos[0],obj.pos[1]); 
    if (obj.health > 0) {
    drawHealthBar(obj,percentageHealth);
    }
  }
  addBulletInvader(obj);
}

PImage getSpriteInvader(SpaceInvader obj,float percentageHealth)
{
  if (discocounter == 10) {
    obj.spriteId = int(random(11)); // disco mode
  }
  discocounter = (discocounter + 1)%11;

  int xOffset = int((damageTypes)-(percentageHealth*damageTypes));
  int yOffset = obj.spriteId;
  //println(xOffset);
  
  if (percentageHealth == 0) {
    if (!obj.isDead) {
      if (obj.framesUntilRemoval != 0) {
        PImage sprite = invaderSpriteSheet.get(xOffset*2* invSpriteWidth,yOffset * invSpriteHeight,invSpriteWidth,invSpriteHeight);
        obj.framesUntilRemoval --;
        return sprite;
      }
      dropItem(obj);
      score += obj.scoreWorth;
      obj.isDead = true;
    }
    return null;
  }
  
  PImage sprite = invaderSpriteSheet.get((xOffset*2+animFrame)* invSpriteWidth,yOffset * invSpriteHeight,invSpriteWidth,invSpriteHeight);
  return sprite;
}

void dropItem(SpaceInvader obj) {
  int randomValue = int(random(1,101));
  if (randomValue <= obj.dropChance) {
    Upgrade upgrade = new Upgrade();
    upgrade.upgradeId = int(random(0,5));
    
  }
}
