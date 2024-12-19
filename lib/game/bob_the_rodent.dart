import 'dart:async';
import 'package:bob_the_rodent/levels/level.dart';
import 'package:bob_the_rodent/components/player.dart';
import 'package:bob_the_rodent/widgets/game_over.dart';
import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/game.dart';

class BobTheRodent extends FlameGame
    with HasKeyboardHandlerComponents, DragCallbacks, HasCollisionDetection {
  late CameraComponent cam;
  Player player = Player(character: 'Capybara');
  bool playSounds = false;
  List<String> levelNames = [
    'Forest-level-01 pp',
    'Forest-level-02 pp',
    'Forest-level-03 pp',
    'River-level-01 pp',
    'River-level-02 pp',
    'River-level-03 pp',
    'Swamp-level-01 pp',
    'Swamp-level-02 pp',
    'Swamp-level-03 pp',
  ];
  int currentLevelIndex = 0;

  @override
  FutureOr<void> onLoad() async {
    await images.loadAllImages();

    // await SoundManager()
    //     .preloadSounds(['jump.wav', 'cheese_pickup.wav', 'teleporting.wav']);

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
      pauseEngine();
      overlays.add(GameOver.ID);
    }
  }

  void _loadlevel() {
    Future.delayed(const Duration(milliseconds: 800), () {
      removeWhere((component) => component is Level);
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
