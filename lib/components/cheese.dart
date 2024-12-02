import 'dart:async';

import 'package:bob_the_rodent/bob_the_rodent.dart';
import 'package:bob_the_rodent/components/custom_hitbox.dart';
import 'package:flame/collisions.dart';
import 'package:flame/components.dart';

class Cheese extends SpriteAnimationComponent
    with HasGameRef<BobTheRodent>, CollisionCallbacks {
  final String cheese;
  Cheese({
    this.cheese = 'Cheese_Idle',
    position,
    size,
  }) : super(
          position: position,
          size: size,
        );

  bool _collected = false;
  final double stepTime = 0.2;
  final hitbox = CustomHitbox(
    offsetX: 19,
    offsetY: 24,
    width: 26,
    height: 22,
  );

  @override
  FutureOr<void> onLoad() async {
    // debugMode = true;

    add(
      RectangleHitbox(
        position: Vector2(hitbox.offsetX, hitbox.offsetY),
        size: Vector2(hitbox.width, hitbox.height),
        collisionType: CollisionType.passive,
      ),
    );
    animation = SpriteAnimation.fromFrameData(
        game.images.fromCache('Collectibles/Cheese_Idle.png'),
        SpriteAnimationData.sequenced(
          amount: 5,
          stepTime: stepTime,
          textureSize: Vector2.all(64),
        ));
    return super.onLoad();
  }

  void collidedWithPlayer() {
    if (!_collected) {
      _collected = true;

      // sfx for collecting cheese but bugged due to windows and flutter interaction
      // if (game.playSounds) SoundManager().playSound('cheese_pickup.wav');

      animation = SpriteAnimation.fromFrameData(
        game.images.fromCache('Collectibles/Cheese_Claim.png'),
        SpriteAnimationData.sequenced(
          amount: 2,
          stepTime: stepTime,
          textureSize: Vector2.all(64),
          loop: false,
        ),
      );
    }
    Future.delayed(
      const Duration(milliseconds: 280),
      () => removeFromParent(),
    );
  }
}
