import 'dart:async';

import 'package:bob_the_rodent/bob_the_rodent.dart';
import 'package:flame/components.dart';

enum PlayerStates {
  idle,
  running,
}

class Player extends SpriteAnimationGroupComponent
    with HasGameRef<BobTheRodent> {
  Player({
    required this.character,
    position,
  }) : super(position: position);
  String character;
  late final SpriteAnimation idleAnimation;
  late final SpriteAnimation runningAnimation;
  final double stepTime = 0.02;

  @override
  FutureOr<void> onLoad() {
    _loadAllAnimation();

    return super.onLoad();
  }

  void _loadAllAnimation() {
    runningAnimation = _spriteAnimation('Walk', 5);
    idleAnimation = _spriteAnimation('Idle', 5);

    animations = {
      PlayerStates.idle: idleAnimation,
      PlayerStates.running: runningAnimation,
    };

    current = PlayerStates.idle;
  }

  SpriteAnimation _spriteAnimation(String state, int amount) {
    return SpriteAnimation.fromFrameData(
      game.images.fromCache('$character/${character}_$state.png'),
      SpriteAnimationData.sequenced(
        amount: amount,
        stepTime: 0.1,
        textureSize: Vector2.all(32),
      ),
    );
  }
}
