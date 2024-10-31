import 'dart:async';

import 'package:bob_the_rodent/levels/level.dart';
import 'package:bob_the_rodent/player/player.dart';
import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/game.dart';

class BobTheRodent extends FlameGame with HasKeyboardHandlerComponents {
  late final CameraComponent cam;
  Player player = Player(character: 'Capybara');

  @override
  FutureOr<void> onLoad() async {
    await images.loadAllImages();

    final world = Level(
      player: player,
      levelName: 'forest-level-01',
    );

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
