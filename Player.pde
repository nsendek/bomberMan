class Player {  
  //init variable
  color playerColor;
  float origin;
  float position;
  int lives = MAX_LIVES;
  //joystick/movement variables  
  int direction = 1;
  float speed = 0;
  float acc = 0;
  //bomb passing variables
  int frozenDelay = 0; 
  String currentKey = "";
  //jumping variables
  boolean jumping = false;
  int zHeight = BASE_ZHEIGHT;
  int zVel;

  Player( int pos, color _c) {
    playerColor = _c;
    origin = pos;
    position = origin;
    
  }
  void reset() {
    position = origin;
    speed = 0;
  }
  
  void log() {
    println("color: " + hex(playerColor));
    println("frozenDelay: " + frozenDelay);
    println("position: " + position);
    println("zHeight: " + zHeight);
    println("hasBomb: " + bomb.attachedTo(this));
    println();
  }
  
  void setPos(int pos) {
    position = pos; 
    speed = 0;
  }
  
  int pixelPos() {
    return round(position);
  }
  
  void tagged() {
      frozenDelay = int(playerFreezeDurationSeconds*appFramerate);
  }

  boolean isFrozen() {
    return frozenDelay > 0;
  }
  
  boolean intersect(Player _other) {
    return abs(position - _other.position) < max(PLAYER_MAX_VEL,BOMB_MAX_VEL)  &&
    abs(zHeight - _other.zHeight) < displayPixelSize;
  }
  
  void update() { 
    if (frozenDelay > 0) {
      frozenDelay--; 
    }
          
    move();
    
    if (jumping) {
      zHeight += zVel; 
      if (zHeight >= 255) {
        zHeight = 255;
      }
      zVel -= GRAVITY; 
    }
    
    if (zHeight < BASE_ZHEIGHT) {
      zVel = 0;
      zHeight = BASE_ZHEIGHT;
      jumping = false;
    }
  }
  
  color getColor() {
   return color(int(unhex(hex(playerColor))), zHeight);
  }
  
  void move() {
    acc = (currentKey == "RIGHT") 
          ? ACCELERATION 
          : (currentKey == "LEFT") ? -ACCELERATION : 0;
          
    float maxVel = (bomb.attachedTo(this)) ? BOMB_MAX_VEL : PLAYER_MAX_VEL;
    speed += acc;
    speed = (abs(speed) > maxVel) ? sign(speed)*maxVel : speed;
    speed -= speed*DRAG_CONSTANT;
    
    if (game.gameState == "PLAY" && frozenDelay == 0) {
      direction = sign(speed);
      position = (position + speed)%displaySize;
      if (position < 0) {
        position += displaySize;
      }
    }
    game.checkCollisions(); // check collisions after any movements
  }
  
  void jump() {
    if (jumping == false) {
      zVel = JUMP_VEL;
      jumping = true;
    }
  }
  
  void applyKeys(String _key) {
    currentKey =  _key;
}
}

int sign(float _dir) {
  return _dir >= 0 ? 1 : -1;
}
