import 'package:flame/components.dart';
import 'package:flame/collisions.dart';
import 'package:flutter/material.dart';
import 'soccer_game.dart';
import 'player_component.dart';

class BallComponent extends CircleComponent
    with CollisionCallbacks, HasGameRef<SoccerGame> {
  Vector2 velocity = Vector2(150, 150); // pixels per second

  BallComponent()
      : super(
          radius: 10,
          paint: Paint()..color = Colors.white,
          anchor: Anchor.center,
        );

  @override
  Future<void> onLoad() async {
    // Add a hitbox for collision detection
    add(CircleHitbox());
  }

  @override
  void update(double dt) {
    super.update(dt);
    position += velocity * dt;

    // Check boundaries and bounce:
    final gameSize = gameRef.size;

    // Top & bottom collision
    if (position.y - radius <= 0 || position.y + radius >= gameSize.y) {
      velocity.y = -velocity.y;
    }

    // Left side collision
    if (position.x - radius <= 0) {
      velocity.x = -velocity.x;
    }
    // Right side collision
    if (position.x + radius >= gameSize.x) {
      velocity.y = -velocity.y;
    }
  }

  void resetPosition() {
    position = gameRef.size / 2;
    // Optionally randomize initial direction:
    velocity = Vector2(
      (150 * ([-1, 1]..shuffle()).first).toDouble(),
      (150 * ([-1, 1]..shuffle()).first).toDouble(),
    );
  }

  @override
  void onCollision(Set<Vector2> intersectionPoints, PositionComponent other) {
    // Bounce off players (bricks)
    if (other is PlayerComponent) {
      // Basic reflection logic: simply reverse horizontal velocity.
      // You can enhance this based on the impact angle.
      velocity.x = -velocity.x;
    }
    super.onCollision(intersectionPoints, other);
  }
}
