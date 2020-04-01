class DisplayBuffer {
  int radius;
  int displaySize;
  color[] displayBuffer;
  color initColor = color(0, 0, 0);

  // Constructor sets initial size and frame for buffer
  DisplayBuffer (int _size, int _radius) { 
    radius = _radius;
    displaySize = _size;
    displayBuffer = new color[displaySize];
    for(int i = 0; i < displaySize; i++) {
      displayBuffer[i] = initColor; 
    }
  }

  // Color a specific pixel in the buffer MODULO
  void setPixel(int  _index, color _c) {
    if (_index < 0) {
      _index += displaySize;
    }
    displayBuffer[_index%displaySize]  = _c;
  }

  // Color all pixels in the buffer
  void setAllPixels(color _c) {
    for(int i = 0; i < displaySize; i++) {
      display.setPixel(i, _c); 
    }
  }

  // Now write it to screen
  void show() {
    translate(width/2,height/2);
    noStroke();
    float offAngle = map(1,0,displaySize,0,TAU);
    for(int i = 0; i < displaySize; i++) {
      push();
      float angle = map(i,0,displaySize,0,TAU);
      float minRadius = radius - displayPixelSize;
      rotate(angle);
      fill(displayBuffer[i]);
      
      //draw special pixel shape
      beginShape();
      vertex(radius, 0);
      vertex(minRadius, 0);
      vertex(minRadius*cos(offAngle), minRadius*sin(offAngle));
      vertex(radius*cos(offAngle), radius*sin(offAngle));
      endShape(CLOSE);
      pop();
    }
  }

  // Let's empty everything before we start adding things to it again
  void clear() {
    for(int i = 0; i < displaySize; i++) {    
      displayBuffer[i] = initColor;
    }
  }
}

void drawPlayer(Player player) {
  if (player.zHeight > BASE_ZHEIGHT) {
    display.setPixel(player.pixelPos()-1, player.getColor());
  }
  if (player.zHeight > 180) {
    display.setPixel(player.pixelPos()+1, player.getColor());
  }
  if (bomb.attachedTo(player)) {
    display.setPixel(bomb.getPos(), bomb.getColor());
  }
  display.setPixel(player.pixelPos(), player.getColor());
}

/**
  draw players
*/
void drawPlayers() { // draw things from lower zHeight first
    display.clear();
    if (playerOne.zHeight < playerTwo.zHeight) {
      drawPlayer(playerOne);
      drawPlayer(playerTwo);
    } else {
      drawPlayer(playerTwo);
      drawPlayer(playerOne);
    }
}

/** 
  Helper function to advance animation frames  
*/
int animateExplosion(int pos) {
   currentFrame = (currentFrame < animation.size()-1) ? currentFrame+1 : 0;
   //too lazy  to animate my own explosion for magenta and cyan so
   //i'm taking the old yellow one and recoloring the frames to match player color. 
   for (int i = 0; i < animation.get(0).width; i++) {    
     color col = animation.get(currentFrame).pixels[i];
     color newCol;
     if (red(col) > 0 && green(col) > 0) { //yellow explosion pixels
       float ratio = red(col)/255;
       newCol = color(int(ratio*red(bomb.player.playerColor)), 
               int(ratio*green(bomb.player.playerColor)),
               int(ratio*blue(bomb.player.playerColor )));
       // offset number to place explosion animation on top of collision spot. 
       // pixel 14 is the middle of 30 pixel animation
       int offset = pos - 14; 
       display.setPixel(offset + i, newCol);
     } 
   }
   return currentFrame;
}
