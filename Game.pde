class Game {
  int timer = 0;
  String gameState = "STANDBY";
  int maxLives = MAX_LIVES; 
  color scoreColor = color(0,0,0);
  Game() {
  }
  
  void init() {
    if (gameState == "STANDBY") {
      gameState = "PLAY";
    }
  }
   
  void restart() {
   if (gameState == "WIN") {
       gameState = "PLAY";
       playerOne.reset();
       playerTwo.reset();
     }
  }
  
  void checkCollisions() {
    // check if player has caught target
    if (game.gameState == "PLAY") {
      if (playerOne.intersect(playerTwo))  {
        if (bomb.attachedTo(playerTwo) && !playerTwo.isFrozen()) {
          bomb.attach(playerOne, false);
        } else if (bomb.attachedTo(playerOne) && !playerOne.isFrozen()) {
          bomb.attach(playerTwo, false);
        }
      }
    }
  }

  void update() {  
    if (bomb.boom) {
       gameState = "BOOM";
       this.scoreColor = bomb.player.playerColor;
    }
    switch (gameState) {
      case "PLAY":
        bomb.tick(); // bomb should only tick when game is playing
        playerOne.update();
        playerTwo.update();
      case "STANDBY":
        drawPlayers();
        break;
      case "BOOM":
        // play explosion animation one frame at a time
        int frameShown = animateExplosion(bomb.getPos());
        //  if animation is done playing, it's time to move on to another state
         if (frameShown == animation.size()-1) {          
            bomb.player.lives--;  
            bomb.reset();
            if (playerOne.lives ==  0)  {
              scoreColor = playerTwo.playerColor;
              gameState = "WIN";
            } else if (playerTwo.lives == 0)  {
              scoreColor = playerOne.playerColor;
              gameState = "WIN";
            }  else {
              playerOne.setPos(int(random(1,displaySize/2)));
              playerTwo.setPos(int(random(displaySize/2,displaySize)));
              gameState = "PLAY";
            }
         }
        break;
      // Game is over. Show winner and clean everything up so we can start a new game
      case "WIN":  
        playerOne.lives = maxLives;
        playerTwo.lives = maxLives;
        display.setAllPixels(this.scoreColor);  //winner color shown        
        break;
      default:
        break;
    }    
  }
}
