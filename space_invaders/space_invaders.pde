import processing.sound.*;

SoundFile bgMusic;
SoundFile laserShot;
SoundFile laserHit;

JSONObject gamedata;

int score = 0;

int invaderIds = 11;
int invaderRows = 7;

int damageTypes = 3;
int damageSprites = 2;
int cFrame = 0;
int animFrame = 0;
int animFrameCount = 60;

int horInterval = 10;
int spriteMoveCount = 1;
int invaderXOffs = -(horInterval*spriteMoveCount);
int moveFrame = 0;
int moveFrameCount = 60;

Difficulty[] difficulties = new Difficulty[0];

SpaceInvader[][] invaders;
PImage invaderSpriteSheet;
int invSpriteWidth;
int invSpriteHeight;
Bullet[] invaderBullets = new Bullet[0];

Player player = new Player();
PImage playerSprite;
int playerSpriteWidth;
int playerSpriteHeight;

Bullet[] playerBullets = new Bullet[0];
int[][] angles = {{0},{-10,10},{-10,0,10},{-20,-10,0,10,20},{-30,-20,10,30}};

//--------------------------------------------------------------------------//

void setup() {
  size(1200,1000);
  frameRate(60);
  background(#100020);
  
  invaderSpriteSheet = loadImage("sprites_invaders.png");
  invSpriteWidth = invaderSpriteSheet.width/invaderRows;
  invSpriteHeight = invaderSpriteSheet.height/invaderIds;
  
  //bgMusic = new SoundFile(this,"bgMusic_1.mp3");
  //bgMusic.loop();
  
  laserShot = new SoundFile(this,"laserShot.mp3");
  laserHit = new SoundFile(this,"laserHit.mp3");

  gamedata = loadJSONObject("gamedata.json");
  
  playerSprite = loadImage("spaceship.png");
  playerSprite.resize(0,60);
 
  createLevels();
  //createLevel(0);
  
  textSize(24);
  textAlign(LEFT);
}

void draw() {
  cFrame ++;
  animFrame = (cFrame%(animFrameCount*damageSprites))/animFrameCount;
  addXOffsetInvaders();

  background(#100020);
  updatePlayer();
  drawPlayer();

  updateInvaders();
  
  updatePlayerBullets();
  drawPlayerBullets();
  
  showGui(); 

}

void showGui() {
  fill(#d0ff3d);
  text("Score " + score,50,50);
}

color getHealthColor(float health, float maxhealth ){
  float percentageHealth = health/maxhealth;
  color baseColor = #d0ff3d;
  int[] hue =  {int((1-percentageHealth+0.1)*255),-int(pow((1-percentageHealth)*5,2)*10),-int((1-percentageHealth)*100)};
  return addHue(baseColor, hue);
}

color setOpacity(color  clr,int opacity) {
  int r = (clr >> 16) & 0xFF;
  int g = (clr >> 8) & 0xFF;
  int b = clr & 0xFF;
  return color(r,g,b,opacity);
}

color addHue(color  clr,int[] hue){
  int r = (clr >> 16) & 0xFF;
  int g = (clr >> 8) & 0xFF;
  int b = clr & 0xFF;
  return color(r+hue[0],g+hue[1],b+hue[2]);
}

void keyPressed(){
  if (keyCode == LEFT) {
    player.keyheld[0] = true;
  }
  if (keyCode == RIGHT) {
    player.keyheld[1] = true;
  }
  if (key == ' ') {
    player.keyheld[2] = true;
  }
}

void keyReleased() {
  if (keyCode == LEFT) {
    player.keyheld[0] = false;
  }
  if (keyCode == RIGHT) {
     player.keyheld[1] = false;
  }
  if (key == ' ') {
    player.keyheld[2] = false;
  } 
}
