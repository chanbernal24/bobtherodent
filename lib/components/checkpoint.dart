import 'dart:async';

import 'package:bob_the_rodent/bob_the_rodent.dart';
import 'package:bob_the_rodent/components/custom_hitbox.dart';
import 'package:bob_the_rodent/player/player.dart';
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

  bool isCheckpointReached = false;

  final hitbox = CustomHitbox(
    offsetX: 5,
    offsetY: 26,
    width: 22,
    height: 5,
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
  void onCollision(Set<Vector2> intersectionPoints, PositionComponent other) {
    if (other is Player && !isCheckpointReached) _reachedCheckpoint();
    super.onCollision(intersectionPoints, other);
  }

  void _reachedCheckpoint() {
    isCheckpointReached = true;
    animation = SpriteAnimation.fromFrameData(
      game.images.fromCache('Portal/Portal.png'),
      SpriteAnimationData.sequenced(
        amount: 5,
        stepTime: .05,
        textureSize: Vector2.all(32),
        // loop: false,
      ),
    );
  }
}
