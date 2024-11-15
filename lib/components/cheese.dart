import 'dart:async';

import 'package:bob_the_rodent/bob_the_rodent.dart';
import 'package:bob_the_rodent/player/custom_hitbox.dart';
import 'package:flame/collisions.dart';
import 'package:flame/components.dart';

class Cheese extends SpriteAnimationComponent
    with HasGameRef<BobTheRodent>, CollisionCallbacks {
  final String cheese;
  Cheese({
    this.cheese = 'Cheese',
    position,
    size,
  }) : super(
          position: position,
          size: size,
        );
  final double stepTime = 0.05;
  final hitbox = CustomHitbox(
    offsetX: 14,
    offsetY: 36,
    width: 20,
    height: 13,
  );

  @override
  FutureOr<void> onLoad() {
    // debugMode = true;

    add(
      RectangleHitbox(
        position: Vector2(hitbox.offsetX, hitbox.offsetY),
        size: Vector2(hitbox.width, hitbox.height),
        collisionType: CollisionType.passive,
      ),
    );
    animation = SpriteAnimation.fromFrameData(
        game.images.fromCache('Collectibles/$cheese.png'),
        SpriteAnimationData.sequenced(
          amount: 1,
          stepTime: stepTime,
          textureSize: Vector2.all(64),
        ));
    return super.onLoad();
  }

  void collidedWithPlayer() {
    removeFromParent();
  }
}
