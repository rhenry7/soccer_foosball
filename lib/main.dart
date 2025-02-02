import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/game.dart';
import 'package:flame/input.dart';
import 'package:flutter/material.dart';
import 'dart:math';
import 'package:flame/components.dart';

void main() {
  runApp(GameWidget(game: PongGame()));
}

class PongGame extends FlameGame with HasCollisionDetection, DragCallbacks {
  late Ball ball;
  late Paddle topPaddle;
  late Paddle bottomPaddle;
  Color backgroundColor() =>
      const Color.fromARGB(255, 45, 209, 113); // Set background color to black

  @override
  Future<void> onLoad() async {
    final screenWidth = size.x;
    final screenHeight = size.y;

    // Create Ball
    ball = Ball()
      ..position = Vector2(screenWidth / 2, screenHeight / 2)
      ..size = Vector2(20, 20);

    add(ball);

    // Create Top Paddle
    topPaddle = Paddle()
      ..position = Vector2(screenWidth / 2 - 50, 20)
      ..size = Vector2(100, 20);
    add(topPaddle);

    // Create Bottom Paddle
    bottomPaddle = Paddle()
      ..position = Vector2(screenWidth / 2 - 50, screenHeight - 40)
      ..size = Vector2(100, 20);
    add(bottomPaddle);
  }
}

class Ball extends PositionComponent with HasGameRef<PongGame> {
  Vector2 velocity = Vector2(0, 200);

  late Paint paint;

  Ball() {
    paint = Paint()..color = Colors.white; // Set the ball color here
  }

  @override
  void render(Canvas canvas) {
    super.render(canvas);
    canvas.drawCircle(Offset(size.x / 2, size.y / 2), size.x / 2, paint);
  }

  @override
  void update(double dt) {
    position += velocity * dt;
    final screenSize = gameRef.size;

    // Bounce off walls
    if (position.x <= 0 || position.x + size.x >= screenSize.x) {
      velocity.x = -velocity.x;
      addRandomnessToVelocity();
    }

    // Bounce off paddles
    if (position.y <= gameRef.topPaddle.position.y + 20 && velocity.y < 0 ||
        position.y + size.y >= gameRef.bottomPaddle.position.y &&
            velocity.y > 0) {
      velocity.y = -velocity.y;
      addRandomnessToVelocity();
    }
  }

  void addRandomnessToVelocity() {
    // Add a small random angle to the velocity
    final random = Random();
    double angle = (random.nextDouble() - 0.5) *
        pi /
        6; // Random angle between -15 and 15 degrees
    velocity.rotate(angle);
  }
}

class Paddle extends PositionComponent with DragCallbacks {
  late Paint paint;

  Paddle() {
    paint = Paint()..color = Colors.white; // Set the ball color here
  }

  Rect myRect = const Offset(1.0, 2.0) & const Size(100.0, 10.0);

  /// We will store all current circles into this map, keyed by the `pointerId`
  /// of the event that created the circle.
  //final Map<int, Trail> _trails = {};

  @override
  void render(Canvas canvas) {
    super.render(canvas);
    canvas.drawRect(myRect, paint);
  }

  @override
  void update(double dt) {
    // Movement logic (can be updated with gestures later)
  }

  /// We will store all current circles into this map, keyed by the `pointerId`
  /// of the event that created the circle.

  @override
  void onGameResize(Vector2 size) {
    super.onGameResize(size);
    this.size = size - Vector2(100, 75);
    if (this.size.x < 100 || this.size.y < 100) {
      this.size = size * 0.9;
    }
  }

  @override
  void onDragStart(DragStartEvent event) {
    super.onDragStart(event);
    priority = 10;
  }

  @override
  void onDragUpdate(DragUpdateEvent event) {
    position += event.localDelta;
  }

  @override
  void onDragEnd(DragEndEvent event) {
    super.onDragEnd(event);
    priority = 0;
  }

  @override
  void onDragCancel(DragCancelEvent event) {
    super.onDragCancel(event);
  }
}
