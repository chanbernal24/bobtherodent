import 'package:bob_the_rodent/bob_the_rodent.dart';
import 'package:flame/components.dart';

class Hole extends SpriteAnimationComponent with HasGameRef<BobTheRodent> {
  Hole({
    position,
    size,
  }) : super(
          position: position,
          size: size,
        );
}
