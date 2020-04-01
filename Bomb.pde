class Bomb {
  int redCount = 0;
  int framesToExplode;
  int greenCount;
  int halfMark;
  boolean boom = false;
  Player player;
  
  Bomb(int time) {
    //10 frames of offset since framereate is never truly the right speed
    framesToExplode = time - 10;
    halfMark = int(framesToExplode/2);
    greenCount = halfMark;
  }
  
  void reset() {  
    boom = false;
    redCount = 0;
    greenCount = halfMark;
    bomb.attach(getRandomPlayer(), true);
  }
  
  void attach(Player _player, boolean resetting) {
    if (player == null || !player.isFrozen()) {    
      player = _player;
      if (!resetting) {
        player.tagged();
      }
    }
  }
  
  void tick() {
    if (redCount < halfMark) {
      redCount += 1;
    } else if (greenCount > 0) {
      greenCount -= 1;
    } else {
      boom = true;
    }
  }
  
  boolean attachedTo(Player _player) {
    return player == _player;
  }
  
  int getPos() {
    return player.pixelPos() - player.direction;
  }
  
  color getColor() {
    return color(int(255*redCount/halfMark), int(255*greenCount/halfMark), 0);
  }
}
