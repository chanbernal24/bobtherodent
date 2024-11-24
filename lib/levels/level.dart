import 'dart:async';
import 'package:bob_the_rodent/components/checkpoint.dart';
import 'package:bob_the_rodent/components/collision_block.dart';
import 'package:bob_the_rodent/components/cheese.dart';
import 'package:bob_the_rodent/components/hole.dart';
import 'package:bob_the_rodent/player/player.dart';
import 'package:flame/components.dart';
import 'package:flame_tiled/flame_tiled.dart';
// import 'package:flutter/foundation.dart';

class Level extends World {
  late TiledComponent level;
  final Player player;
  String? levelName;
  Level({required this.levelName, required this.player});
  List<CollisionBlock> collisionBlocks = [];

  @override
  FutureOr<void> onLoad() async {
    level = await TiledComponent.load('$levelName.tmx', Vector2.all(16));

    add(level);

    _addCollisions();
    _spawningObjects();

    return super.onLoad();
  }

  void _spawningObjects() {
    final spawnPointsLayer = level.tileMap.getLayer<ObjectGroup>('Spawnpoints');

// added a null check to avoid game crash if we dont have spawnPointsLayer
    if (spawnPointsLayer != null) {
      for (final spawnPoint in spawnPointsLayer.objects) {
        switch (spawnPoint.class_) {
          case 'Player':
            // Update player's position and startingPosition
            player.position = Vector2(spawnPoint.x, spawnPoint.y);
            player.startingPosition = player.position.clone();
            add(player);
            break;
          case 'Cheese':
            final cheese = Cheese(
              cheese: spawnPoint.name,
              position: Vector2(spawnPoint.x, spawnPoint.y),
              size: Vector2(spawnPoint.width, spawnPoint.height),
            );
            add(cheese);
            break;
          case 'Checkpoint':
            final checkpoint = Checkpoint(
              position: Vector2(spawnPoint.x, spawnPoint.y),
              size: Vector2(spawnPoint.width, spawnPoint.height),
            );
            add(checkpoint);
            break;
          // case 'Hole':
          //   final hole = Hole(
          //     position: Vector2(spawnPoint.x, spawnPoint.y),
          //     size: Vector2(spawnPoint.width, spawnPoint.height),
          //   );
          //   add(hole);
          // break;
          default:
        }
      }
    }
  }

  void _addCollisions() {
    final collisionsLayer = level.tileMap.getLayer<ObjectGroup>('Collisions');

    if (collisionsLayer != null) {
      for (final collision in collisionsLayer.objects) {
        switch (collision.class_) {
          case 'Platform':
            final platform = CollisionBlock(
              position: Vector2(collision.x, collision.y),
              size: Vector2(collision.width, collision.height),
              isPlatform: true,
            );
            collisionBlocks.add(platform);
            add(platform);
            break;
          default:
            final block = CollisionBlock(
              position: Vector2(collision.x, collision.y),
              size: Vector2(collision.width, collision.height),
            );
            collisionBlocks.add(block);
            add(block);
        }
      }
    }
    player.collisionBlocks = collisionBlocks;
  }
}
