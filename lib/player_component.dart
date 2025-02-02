import 'package:flame/components.dart';
import 'package:flame/collisions.dart';
import 'package:flutter/material.dart';

class PlayerComponent extends RectangleComponent with CollisionCallbacks {
  // Static width for placement reference
  static const double playerWidth = 200;
  static const double playerHeight = 10;

  final bool isGoalie;
  final bool isLeftSide; // to know orientation if needed

  PlayerComponent({
    required Vector2 position,
    required Color color,
    this.isGoalie = false,
    required this.isLeftSide,
  }) : super(
          position: position,
          size: Vector2(playerWidth, playerHeight),
          paint: Paint()..color = color,
          anchor: Anchor.center,
        );

  @override
  Future<void> onLoad() async {
    add(RectangleHitbox());
  }
}
