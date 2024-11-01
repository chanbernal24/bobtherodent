import 'dart:async';

import 'package:bob_the_rodent/player/player.dart';
import 'package:flame/components.dart';
import 'package:flame_tiled/flame_tiled.dart';

class Level extends World {
  late TiledComponent level;
  String? levelName;
  Level({
    required this.levelName,
  });

  @override
  FutureOr<void> onLoad() async {
    level = await TiledComponent.load('$levelName.tmx', Vector2.all(16));
    add(level);
    final spawnPointsLayer = level.tileMap.getLayer<ObjectGroup>('Spawnpoints');

    for (final spawnPoint in spawnPointsLayer!.objects) {
      switch (spawnPoint.class_) {
        case 'Player':
          final player = Player(
              character: 'Capybara',
              position: Vector2(spawnPoint.x, spawnPoint.y));
          add(player);
          break;
        default:
      }
    }

    return super.onLoad();
  }
}
