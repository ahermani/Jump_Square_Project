class Player
{
  static final float gravity = 0.14;
  static final float bounceVel = 6.1;
  static final float maxYVel = 12;
  static final float maxXVel = 2;
 
  float x, y, xVel, yVel;
  int w, h;
  Player(int x, int y)
  {
    this.x = x;
    this.y = y;
    w = h = 20;
  }
 
  void display()
  {
    
    fill(130, 8, 141);
    rect(x,y,w,h);
  }
 
  void move()
  {
    x += xVel;
    y += yVel;
 
    // wrap around
    if (x > width-w) x = 0;
    if (x < 0) x = width-w;
 
    // horizontal
    if (!gameOver)
    {
      if (aPressed) xVel -= 0.05;
      else if (dPressed) xVel += 0.05;
      else
      {
        if (xVel > 0) xVel -= 0.03;
        else  xVel += 0.03;
      }
    }
    if (abs(xVel) < 0.01) xVel = 0;
    xVel = min(maxXVel, xVel);
    xVel = max(-maxXVel, xVel);
 
    // vertical
    yVel += gravity;
    yVel = min(maxYVel, yVel);
    yVel = max(-maxYVel, yVel);
  }
 //odbicie od platformy
  void collide(Platform p)
  {
    // standard rectangle intersections, but only for our lowest quarter
    if(x         < p.x + p.w &&
      x + w      > p.x       &&
      y+h/2+h/4  < p.y + p.h &&
      y + h      > p.y)
    {
      // but we only care about platforms when falling
      if (yVel > 0) {
        // for bouncing
        if(p instanceof MegaJumpPlatform) {
          yVel = -2*bounceVel;
        }
        else {
        yVel = -bounceVel;
        }
        jump.play();
      }
    }
  }
  //zbieranie serc
  void collide(Heart heart) {
    if(x         < heart.x + heart.r &&
      x + w      > heart.x       &&
      (y)  < heart.y + heart.r &&
      (y + h)     > heart.y) {
         hearts.remove(hearts.indexOf(heart));
      if(lives<10) {
       lives++; 
      }
      }
     
  }
 
}
