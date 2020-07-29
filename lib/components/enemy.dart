import 'dart:ui';

import 'package:simple_swarm_game/game_controller.dart';

class Enemy {
  final GameController gameController;
  int health;
  int damage;
  double speed;
  Rect enemyRect;
  bool isDead = false;
  Offset position;

  Enemy(this.gameController, double x, double y) {
    health = 2;
    damage = 1;
    speed = gameController.tileSize * 2;
    position = Offset(x, y);
    enemyRect = Rect.fromLTWH(
      x,
      y,
      gameController.tileSize * 1.2,
      gameController.tileSize * 1.2,
    );
  }

  void render(Canvas c) {
    Color color;
    switch (health) {
      case 1:
        color = Color(0xFFFF7F7F);
        break;
      case 2:
        color = Color(0xFFFF4C4C);
        break;
      default:
        color = Color(0xFFFF0000);
        break;
    }
    Paint enemyColor = Paint()..color = color;
    // c.drawImage(image, position, enemyColor);
    c.drawRect(enemyRect, enemyColor);
  }

  void update(double t) {
    if (!isDead) {
      double stepDistance = speed * t;
      Offset toPlayer =
          gameController.player.playerRect.center - enemyRect.center;
      if (stepDistance <= toPlayer.distance - gameController.tileSize * 1.3) {
        Offset stepToPlayer = Offset.fromDirection(
          toPlayer.direction,
          stepDistance,
        );
        enemyRect = enemyRect.shift(stepToPlayer);
      } else {
        attack();
      }
    }
  }

  void attack() {
    if (!gameController.player.isDead) {
      gameController.player.currentHealth -= damage;
    }
  }

  void onTapDown() {
    if (!isDead) {
      health--;
      if (health <= 0) {
        isDead = true;
        gameController.score++;
        if (gameController.score >
            (gameController.storage.getInt('highScore') ?? 0)) {
          gameController.storage.setInt('highscore', gameController.score);
        }
      }
    }
  }
}
