import 'dart:async';

import 'package:bob_the_rodent/bob_the_rodent.dart';
import 'package:bob_the_rodent/components/custom_hitbox.dart';
import 'package:bob_the_rodent/components/player.dart';
import 'package:flame/collisions.dart';
import 'package:flame/components.dart';

class Checkpoint extends SpriteAnimationComponent
    with HasGameRef<BobTheRodent>, CollisionCallbacks {
  Checkpoint({
    position,
    size,
  }) : super(
          position: position,
          size: size,
        );

  final hitbox = CustomHitbox(
    offsetX: 20,
    offsetY: 33,
    width: 5,
    height: 14,
  );

  @override
  FutureOr<void> onLoad() {
    // debugMode = true;
    add(
      RectangleHitbox(
          position: Vector2(hitbox.offsetX, hitbox.offsetY),
          size: Vector2(hitbox.width, hitbox.height),
          collisionType: CollisionType.passive),
    );

    animation = SpriteAnimation.fromFrameData(
      game.images.fromCache('Portal/Portal.png'),
      SpriteAnimationData.sequenced(
        amount: 5,
        stepTime: .05,
        textureSize: Vector2.all(32),
      ),
    );
    return super.onLoad();
  }

  @override
  void onCollisionStart(
      Set<Vector2> intersectionPoints, PositionComponent other) {
    if (other is Player) _reachedCheckpoint();
    super.onCollisionStart(intersectionPoints, other);
  }

  void _reachedCheckpoint() async {
    animation = SpriteAnimation.fromFrameData(
      game.images.fromCache('Portal/Portal.png'),
      SpriteAnimationData.sequenced(
        amount: 5,
        stepTime: .05,
        textureSize: Vector2.all(32),
        // loop: false,
      ),
    );

    await animationTicker?.completed;
  }
}
