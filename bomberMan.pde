import gifAnimation.*;
//ALL CONSTANTS here for easy tweaking
//player
final static int MAX_LIVES = 3;
final static int GRAVITY = 1;
final static int BASE_ZHEIGHT = 150;
final static int JUMP_VEL = 30;
final static float DRAG_CONSTANT = 0.05;
final static float PLAYER_MAX_VEL = 0.9;
final static float BOMB_MAX_VEL = 1.25;
final static float ACCELERATION = 0.2;
//bomb
final static float bombTimerSeconds =  4;//16;
final static float explosionDurationSeconds = 0.5;
final static float playerFreezeDurationSeconds = 1;
//display
final static int displaySize = 75;
final static int displayRadius = 220;
final static int displayPixelSize = 25;
final static int screenDim = 480;
final static int appFramerate = 45;


//game ControllerMode
final static boolean USE_JOYSTICK = false;

final DisplayBuffer display = new DisplayBuffer(displaySize,displayRadius);

final Game game = new Game();
final Player playerOne = new Player(0, color(0,255,255));
final Player playerTwo = new Player(int(displaySize/2), color(255,0,255));  
final Bomb bomb = new Bomb(int(bombTimerSeconds*appFramerate));

ArrayList<PImage> animation = new ArrayList<PImage>();
int currentFrame = 0;

void settings() {
  size(screenDim,screenDim);
}

void setup() {
  frameRate(appFramerate);
  animation = ArrayListFrom(Gif.getPImages(this, "Animation.gif"));
  animation = adjustAnimationToFrameRate(animation);
  bomb.attach(getRandomPlayer(), true);
  startSerial();
  game.init();
}

void draw() {
  background(155);
  println(playerOne.currentKey);
  game.update();
  display.show();
}

Player getRandomPlayer() {
  return random(0,1) > 0.5 ? playerOne : playerTwo;
}

ArrayList<PImage> ArrayListFrom(PImage[] b) {
  ArrayList<PImage> a = new ArrayList<PImage>();
  for (int i = 0; i < b.length; i ++){
    a.add(b[i]);
  }
  return a;
}

ArrayList<PImage> adjustAnimationToFrameRate(ArrayList<PImage> animation) {
  int ratio = round((explosionDurationSeconds*appFramerate)/animation.size()); 
  ArrayList<PImage> adjustedAnimation = new ArrayList<PImage>();
  
  for (int i = 0; i < animation.size(); i ++){
    for (int j = 0; j < ratio; j++) {
      adjustedAnimation.add(animation.get(i));
    }
  }
  return adjustedAnimation;
}

void keyPressed() {  
  if (!USE_JOYSTICK) {
    switch(key) {  
      case ' ':
        playerOne.log();
        playerTwo.log();
        break;
      case 'A': case 'a':
        playerOne.applyKeys("LEFT");
        break;
      case 'D': case 'd':
        playerOne.applyKeys("RIGHT");
        break;
      case 'W': case 'w':
        playerOne.jump();
        break;
      case 'J': case 'j':
        playerTwo.applyKeys("LEFT");
        break;
      case 'L': case 'l':
        playerTwo.applyKeys("RIGHT");
        break;
      case 'I': case 'i':
        playerTwo.jump();
        break;
      default: break;
    }
  }
}

void keyReleased() {
  if (!USE_JOYSTICK) {
    switch(key) {  
      case 'J': case 'j':
        if (playerTwo.currentKey == "LEFT") {
          playerTwo.applyKeys("");
        } break; 
        
       case 'L': case 'l':
        if (playerTwo.currentKey == "RIGHT") {
          playerTwo.applyKeys("");
        }
        break;
      case 'A': case 'a': 
        if (playerOne.currentKey == "LEFT") {
          playerOne.applyKeys("");
        }
        break; 
      case 'D': case 'd':
        if (playerOne.currentKey == "RIGHT") {
          playerOne.applyKeys("");
        }
        break;
      default: break;
    }
  }
}
