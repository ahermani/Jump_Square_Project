import processing.sound.*;

Player p;
ArrayList platforms;
ArrayList hearts;
boolean aPressed, dPressed;
int score, lives, highScore, fallCount;
boolean gameOver;
boolean gameStart = false; 
int menu = 1;
int level = 0;
int win;
int time;
PImage img;
PImage backFree;
PFont font;
SoundFile back;
SoundFile jump;
SoundFile fall;
boolean displayMessage;
boolean levelUp=false;
int changeSettings = 0;

void setup()
{
  win = 0;
  size(320, 480);
  frameRate(60);
  time = millis();
  lives=3;
  score = 0;
  highScore = 0;
  level=0;
  backFree = loadImage("backgroundFree.jpg");
  img = loadImage("background.jpg"); 
  font = loadFont("SegoeScript-Bold-48.vlw");
  textFont(font);
  back = new SoundFile(this, "graveyard.mp3");
  back.play();
  jump = new SoundFile(this, "Boing-sound.mp3");
  fall = new SoundFile(this, "fall.mp3");
  initialize();

}
 
void initialize()
{
  if(score > highScore) { 
   highScore = score; 
  }
  score = 0;
  fallCount = 0;
  gameOver = false;
  gameStart = false;
  level=0;
  p = new Player(width/2, height/2);
  platforms = new ArrayList();
  hearts = new ArrayList();
  platforms.add(new HorizontalMovingPlatform(20,80,70,8));
  platforms.add(new Platform(100,420,100,8));
  platforms.add(new Platform((int)random(40,180),320,100,8));
  //platforms.add(new Platform((int)random(40,180),220,100,8));
  platforms.add(new Platform((int)random(40,180),120,100,8));
  platforms.add(new MegaJumpPlatform((int)random(40,180),220,100,8));
  platforms.add(new Platform((int)random(40,180),20,100,8));
}
 
void draw()
{
  background(img);
  textSize(13);
  fill(255);
  if(menu == 1) {
    background(img);
    fill(170,0,0);
    textSize(22);
    textAlign(CENTER);
    text("Hello Newcomer!\n\nA long way awaits You.\nCan you reach the top\nbefore your certain end?\n\nPress Enter\nand start your journey",160,60);
  }
  else if(win == 1) {
   fill(170,0,0);
    textSize(22);
    text("Impossible...", 160, 40);
    text("You escaped the dungeon.", 160, 70);
    text("But do you really think\nthe outside world\nwill bring you safety?",160,130);
    text("Press ENTER\nto play again",160,300); 
    if(key == ENTER) {
    back.stop();
    setup();
    gameStart = true;
    draw();
    }
  }
  else {
  if(lives == 0) {
    gameOver();
  }
  if(gameStart) {
  
  checkLevel();
  
  if(levelUp) {
   printLevel(); 
  // levelUp=false;

  }
  if(score>=2900)    { background(backFree);
  changeSettings ++;
  }
  if(changeSettings==1) {
   makeWin(); 
  }

  textSize(13);
  fill(255);
  text("Score: " + score,50,25);
  text("Lives: " + lives,50,40);
  text("Level: " + level,50,55);
  
  for(int i=0; i<platforms.size(); i++)
  {
    p.collide((Platform)platforms.get(i));
    ((Platform)platforms.get(i)).display();
    ((Platform)platforms.get(i)).move();
  }
  if(hearts.size()!=0) {
  for(int i=0; i<hearts.size(); i++)
  {
    ((Heart)hearts.get(i)).drawHeart();
    p.collide((Heart)hearts.get(i));

  }
  }
  p.display();
  p.move();
  adjustViewport();
  cleanUp();
  seedNewPlatforms();
  
  if (platformsBelow() == 0) gameOver = true;
  if (gameOver) {
    fallCount++;
    fall.play();
  }
  if (fallCount > 90 ) {
    lives--;
    initialize();
  }
  }
}
}




//przegrana
 void gameOver () {
   background(img);
   back.stop();
   textSize(22);
   fill(170,0,0);
   textAlign(CENTER);
   text("It's over...\nYour highscore: " + highScore, 150, 100);
   text("Press ENTER\nto try again",150,230);
   if(key == ENTER) {
    back.stop();
    setup();
    gameStart = true;
    draw();
   }
 }
 //zliczanie platform pod squarem
int platformsBelow()
{
  int count = 0;
  for(int i=0; i<platforms.size(); i++)
  {
    if (((Platform)platforms.get(i)).y >= p.y) count++;
  }
  return count;
}
 // dodstosowanie widoku do skakania
void adjustViewport()
{
  // górna część
  float overHeight = height * 0.5 - p.y;
  if(overHeight > 0)
  {
    p.y += overHeight;
    for(int i=0; i<platforms.size(); i++)
    {
      ((Platform)platforms.get(i)).y += overHeight;
    }
    for(int i=0; i<hearts.size(); i++)
    {
      ((Heart)hearts.get(i)).y += overHeight;
    }
    score += overHeight;
  }
  // spadanie
  float underHeight = p.y - (height-p.h-4);
  if(underHeight > 0)
  {
    p.y -= underHeight;
    for(int i=0; i<platforms.size(); i++)
    {
      ((Platform)platforms.get(i)).y -= underHeight;
    }
    for(int i=0; i<hearts.size(); i++)
    {
      ((Heart)hearts.get(i)).y -= underHeight;
    }
  }
}
//usuwanie niepotrzebnych platform i serc
void cleanUp()
{
  for(int i=platforms.size()-1; i>=0; i--)
  {
    // scrolled off the bottom
    if(((Platform)platforms.get(i)).y > height)
    {
      platforms.remove(i);
    }
  }
  for(int i = hearts.size()-1; i>=0; i--) {
  if( ((Heart)hearts.get(i)).y > height ) {
   hearts.remove(i); 
  }
  }
  }

//dodawanie niwych platrofm i serc
void seedNewPlatforms()
{
  if(score<=2895) {
  if(platforms.size() < 7)
  {  
    if(random(0,30)<2) hearts.add(new Heart((int)random(20,200),-5));
    if(random(0,10) < 2) platforms.add(new HorizontalMovingPlatform((int)random(10,width-80),-10,70,8)); 
    else if(random(0,15) < 3) platforms.add(new MegaJumpPlatform((int)random(10,width-80),-10,70,8));
    else {
      platforms.add(new Platform((int)random(20,200),-10,70,8));
    }
  }
  }
}
//sprawdzanie punktacji
void checkLevel() {
 if(score >= 800 && score <=1000) {
   level = 1;
   levelUp=true;
 }
 else if(score >= 1600 && score <=1800) {
  level = 2; 
  levelUp=true;
 }
 else if(score >= 2400 && score <=2600) {
  level = 3; 
  levelUp=true;
 }
 else if(score >= 3145) {
   win = 1;   
 }
}
// komentarze po drodze
void printLevel() {
  displayMessage = true;
   if(displayMessage) {
     fill(170,0,0);
    textSize(22);
    textAlign(CENTER);
    switch(level) {
      case 1:
      text("Keep going",150,200);
      break;
      case 2:
      text("The end is near",150,200);
      break;
      case 3:
      text("You can't break free",150,200);
      break;
    }
     if(millis() - time >4000) {
       levelUp=false;
      displayMessage = false; 
     }
   }
  
}
// duża platfroma na koniec
void makeWin() {
  platforms.add(new Platform(0,10,320,8));
}
void keyPressed()
{
  if (key == 'a' || keyCode == LEFT) aPressed = true;
  if (key == 'd' || keyCode == RIGHT) dPressed = true;
  if(key == ENTER) {
    gameStart = true;
    menu = 0; 
  }
  if(key == ' ') {
  if (looping) {
    noLoop();
    background(img);
    textSize(22);
    fill(170,0,0);
    textAlign(CENTER);
    text("Tired yet?\n\nPress space to continue\nYour current score: " + score, 150, 100);
  }
  else            loop();
  }
}
 
void keyReleased()
{
  if (key == 'a'|| keyCode == LEFT) aPressed = false;
  if (key == 'd'|| keyCode == RIGHT) dPressed = false;
}
