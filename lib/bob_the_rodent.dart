import 'dart:async';

import 'package:bob_the_rodent/levels/level.dart';
import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/game.dart';

class BobTheRodent extends FlameGame with HasKeyboardHandlerComponents {
  late final CameraComponent cam;
  final world = Level(levelName: 'forest-level-01');

  @override
  FutureOr<void> onLoad() async {
    await images.loadAllImages();

    cam = CameraComponent.withFixedResolution(
      world: world,
      width: 640,
      height: 360,
    );
    cam.viewfinder.anchor = Anchor.topLeft;

    addAll([cam, world]);

    return super.onLoad();
  }
}
