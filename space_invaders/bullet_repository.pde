
// class
class Bullet {
  boolean isInvader; // player or invader?
  int effectID;
  int damage;
  int speed;
  int[] pos = new int[2];
  int width = 10;
  int height = 10;
  int angle;
  color clr;
}

// PLAYER BULLETS
// drawing
void drawPlayerBullets() {
  for (int i = 0; i < playerBullets.length;i++) {
    rect(playerBullets[i].pos[0],playerBullets[i].pos[1],playerBullets[i].width,playerBullets[i].height);
  }
}

// logic
void addPlayerBullets(int count) {
  for (int i = 0; i < count; i++ ) {
    player.shootingCooldown = player.baseShootingCooldown;
    Bullet bullet = new Bullet();
    bullet.isInvader = false;
    arrayCopy(player.pos,bullet.pos);
    bullet.pos[0] += playerSprite.width/2 - bullet.width/2;
    bullet.damage = player.damage;
    bullet.angle = angles[count-1][i];
    
    playerBullets = (Bullet[]) append(playerBullets,bullet);
    if (laserShot.isPlaying()) {laserShot.stop();}
    laserShot.play();
  }
  
}

void updatePlayerBullets() {

  Bullet[] tempBullets = new Bullet[0];
  for (int i = 0; i < playerBullets.length;i++) {
    
    playerBullets[i].pos[0] += playerBullets[i].angle;
    playerBullets[i].pos[1] -= player.shootingSpeed;

    if (playerBullets[i].pos[1] > 0) {
      if (!detectInvaderHit(playerBullets[i])) {
        tempBullets = (Bullet[]) append(tempBullets,playerBullets[i]);
      }
    }
  }
  playerBullets = tempBullets;
  
  player.shootingCooldown --;
  if (player.shootingCooldown < 0) {
    player.shootingCooldown = 0;
  }
}

boolean detectInvaderHit(Bullet bullet) {
  for (int y = 0; y < invaders.length; y++) {
    for (int x = 0; x < invaders[y].length; x++) {
      int[] pos = invaders[y][x].pos;
      if ((bullet.pos[0]+bullet.width/2 >= pos[0]+10) & (bullet.pos[0]+bullet.width/2  <= pos[0]+invSpriteWidth-10)){
        if ((bullet.pos[1]+bullet.height/2 >= pos[1]+10) & (bullet.pos[1]+bullet.height/2  <= pos[1]+invSpriteHeight-10)){
          if (invaders[y][x].health != 0) {
            invaders[y][x].health -= bullet.damage;
            if (invaders[y][x].health < 0) {
              invaders[y][x].health = 0;
            }
            if (laserHit.isPlaying()) {laserHit.stop();}
            laserHit.play();
            return true;
          }
        }
      }      
    }
  }
  
  return false;
}

// INVADER BULLETS
// drawing
void drawInvaderBullets() {
  for (int i = 0; i < invaderBullets.length;i++) {
    fill(invaderBullets[i].clr);
    rect(invaderBullets[i].pos[0],invaderBullets[i].pos[1],invaderBullets[i].width,invaderBullets[i].height);

  }
  
}

//logic
void addBulletInvader(SpaceInvader obj) {
  int randomValue = int(random(1,2000));
  if (randomValue <= 1 & obj.shootingCooldown == 0 & obj.health !=0) {
    obj.shootingCooldown = obj.baseShootingCooldown;

    Bullet bullet = new Bullet();
    bullet.isInvader = true ;
    arrayCopy(obj.pos,bullet.pos);
    bullet.pos[0] += invSpriteWidth/2- bullet.width/2;
    bullet.clr = obj.clr;
    bullet.damage = obj.damage;
    bullet.angle = 0;
    bullet.speed = obj.shootingSpeed;
    
    invaderBullets = (Bullet[]) append(invaderBullets,bullet);
  }
}

void updateInvaderBullets() {
  Bullet[] tempBullets = new Bullet[0];
  
  for (int i = 0; i < invaderBullets.length;i++) {
    
    //invaderBullets[i].pos[0] += invaderBullets[i].angle;
    invaderBullets[i].pos[1] += 3;//invaderBullets[i].speed;

    if (invaderBullets[i].pos[1] < height) {
       if (!detectPlayerHit(invaderBullets[i])) {
        tempBullets = (Bullet[]) append(tempBullets,invaderBullets[i]);
       }
    }
  }
  
  invaderBullets = tempBullets;
}

boolean detectPlayerHit(Bullet bullet) {
  int[] pos = player.pos;
  
  if ((bullet.pos[0] >= pos[0]-bullet.width) & (bullet.pos[0]+bullet.width  <= pos[0]+playerSprite.width)){
    if ((bullet.pos[1]+bullet.height/2 >= pos[1]+20) & (bullet.pos[1]+bullet.height/2  <= pos[1]+playerSprite.height)){
      if (player.health != 0) {
        player.health -= bullet.damage;
        if (player.health < 0) {
          player.health = 0;
        }
        if (laserHit.isPlaying()) {laserHit.stop();}
        laserHit.play();
        return true;
      }
    }
  }
  
  return false;
}