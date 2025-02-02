import 'dart:math';

import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:soccer_brick_breaker/ball_component.dart';
import 'package:soccer_brick_breaker/player_component.dart';
import 'package:flame/components.dart';
import 'package:flame/collisions.dart';
import 'soccer_game.dart';

class SoccerGame extends FlameGame with HasCollisionDetection {
  // Define score variables
  int redScore = 0;
  int blueScore = 0;

  // Random number generator
  final Random random = Random();

  @override
  Color backgroundColor() => const Color.fromARGB(255, 53, 231, 53);

  @override
  Future<void> onLoad() async {
    await super.onLoad();

    // Add the ball
    add(BallComponent());

    // Add players for each side
    // For simplicity, let’s assume players are arranged vertically along the left and right edges.
    // Adjust positions as needed.
    const int playerCount = 1;
    final double spacing = size.y / (playerCount + 1);

    // Left side (Red players)
    for (int i = 0; i < playerCount; i++) {
      final position =
          Vector2(spacing * (i + 1), PlayerComponent.playerHeight / 2);
      add(PlayerComponent(
        position: position,
        color: Colors.blue,
        isGoalie: i == playerCount - 1, // last one is goalie
        isLeftSide: false,
      ));
    }

    // Bottom side (Red players)
    for (int i = 0; i < playerCount; i++) {
      final position =
          Vector2(spacing * (i + 1), size.y - PlayerComponent.playerHeight / 2);
      add(PlayerComponent(
        position: position,
        color: Colors.red,
        isGoalie: i == playerCount - 1, // last one is goalie
        isLeftSide: true,
      ));
    }
  }

  /// Call this method when a goal is scored.
  void scoreGoal({required bool leftGoal}) {
    if (leftGoal) {
      blueScore++;
      // Optionally, reset ball position, play sound, etc.
    } else {
      redScore++;
    }
    print('Red: $redScore, Blue: $blueScore');
  }
}

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
    await super.onLoad();
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

    // Left side: check if ball passes left goalie region (scoring for blue)
    if (position.x - radius <= 0) {
      // You can refine the condition to check if it passed the goalie
      velocity.x = -velocity.x;
    }
    // Right side: check if ball passes right goalie region (scoring for red)
    if (position.x + radius >= gameSize.x) {
      velocity.x = -velocity.x;
    }
  }

  void resetPosition() {
    position = gameRef.size / 2;
    // Optionally randomize initial direction:
    velocity = Vector2(
      150 * (gameRef.random.nextBool() ? 1 : -1),
      150 * (gameRef.random.nextBool() ? 1 : -1),
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
