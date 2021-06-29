class Platform
{
  float x,y,w,h;
  float xvel, yvel;
 
  Platform(int x, int y, int w, int h)
  {
    this.x = x;
    this.y = y;
    this.w = w;
    this.h = h;
  }
 
  void display()
  {
    fill(0);
    rect(x,y,w,h);
  }
 
  void move()
  {
    x += xvel;
    y += yvel;
  }
 
}
 //ruchoma platforma
class HorizontalMovingPlatform extends Platform
{
  static final float speed = 0.9;
   
  HorizontalMovingPlatform(int x, int y, int w, int h)
  {
    super(x, y, w, h);
    this.xvel = speed;
  }
   
  void move()
  {
    super.move();
    if( (x+w > width - 10) || (x < 10) )
    {
      xvel *= -1;
    }
  }
}
//platforma-trampolina
class MegaJumpPlatform extends Platform
{   
  MegaJumpPlatform(int x, int y, int w, int h)
  {
    super(x, y, w, h);
  }
   
  void display()
  {
    fill(255);
    rect(x,y,w,h);
  }
}
