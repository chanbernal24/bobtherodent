import 'dart:async';

import 'package:bob_the_rodent/levels/level.dart';
import 'package:bob_the_rodent/player/player.dart';
import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/game.dart';

class BobTheRodent extends FlameGame
    with HasKeyboardHandlerComponents, DragCallbacks, HasCollisionDetection {
  late CameraComponent cam;
  Player player = Player(character: 'Capybara');
  List<String> levelNames = [
    'Forest-level-01 pp',
    'Forest-level-02 pp',
    'Forest-level-03 pp',
  ];
  int currentLevelIndex = 0;

  @override
  FutureOr<void> onLoad() async {
    await images.loadAllImages();

    _loadlevel();

    return super.onLoad();
  }

  // checks and load the level when the current one finishes
  void loadNextLevel() {
    if (currentLevelIndex < levelNames.length - 1) {
      currentLevelIndex++;
      _loadlevel();
    } else {
      // this runs when there is no more levels
    }
  }

  void _loadlevel() {
    Future.delayed(const Duration(milliseconds: 700), () {
      Level world = Level(
        player: player,
        levelName: levelNames[currentLevelIndex],
      );

      cam = CameraComponent.withFixedResolution(
        world: world,
        width: 640,
        height: 360,
      );
      cam.viewfinder.anchor = Anchor.topLeft;

      addAll([cam, world]);
    });
  }
}
