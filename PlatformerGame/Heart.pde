class Heart {
  float x, y,r;
  boolean touched = false;

  Heart(float xPos, float yPos) {
    x=xPos;
    y=yPos;
    r=10;
  }
  
  void drawHeart() {
    stroke(0);
    fill(250,0,0);
    circle(x,y,r);
  }
}
