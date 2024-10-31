import 'dart:async';

import 'package:bob_the_rodent/bob_the_rodent.dart';
import 'package:bob_the_rodent/collision_block.dart';
import 'package:bob_the_rodent/player/player_hitbox.dart';
import 'package:bob_the_rodent/utils.dart';
import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
// import 'package:flutter/src/services/hardware_keyboard.dart';
import 'package:flutter/services.dart';
// import 'package:flutter/src/services/keyboard_key.g.dart';

enum PlayerStates {
  idle,
  running,
  jumping,
  // falling,
}

class Player extends SpriteAnimationGroupComponent
    with HasGameRef<BobTheRodent>, KeyboardHandler {
  Player({
    this.character = 'Capybara',
    position,
  }) : super(position: position);
  String character;
  late final SpriteAnimation idleAnimation;
  late final SpriteAnimation runningAnimation;
  late final SpriteAnimation jumpingAnimation;
  // late final SpriteAnimation fallingAnimation;
  final double stepTime = 0.05;

  final double _gravity = 20;
  final double _jumpForce = 400;
  final double _terminalVelocity = 400;
  double horizontalMovement = 0;
  double moveSpeed = 150;
  Vector2 velocity = Vector2.zero();
  bool isOnGround = false;
  bool hasJumped = false;
  List<CollisionBlock> collisionBlocks = [];
  PlayerHitbox hitbox = PlayerHitbox(
    offsetX: 10,
    offsetY: 4,
    width: 14,
    height: 28,
  );

  @override
  FutureOr<void> onLoad() {
    _loadAllAnimation();
    // debugMode = true;
    add(RectangleHitbox(
        position: Vector2(hitbox.offsetX, hitbox.offsetY),
        size: Vector2(hitbox.width, hitbox.height)));
    return super.onLoad();
  }

  @override
  void update(double dt) {
    _updatePlayerState();
    _updatePlayerMovement(dt);
    _checkHorizontalCollisions();
    _applyGravity(dt);
    _checkVerticalCollisions();
    super.update(dt);
  }

  @override
  bool onKeyEvent(KeyEvent event, Set<LogicalKeyboardKey> keysPressed) {
    horizontalMovement = 0;
    final isLeftKeyPressed = keysPressed.contains(LogicalKeyboardKey.keyA) ||
        keysPressed.contains(LogicalKeyboardKey.arrowLeft);
    final isRightKeyPressed = keysPressed.contains(LogicalKeyboardKey.keyD) ||
        keysPressed.contains(LogicalKeyboardKey.arrowRight);

// if leftKeyPressed, decreases the horizontalMovement value (which means it goes left), vise versa
    horizontalMovement += isLeftKeyPressed ? -1 : 0;
    horizontalMovement += isRightKeyPressed ? 1 : 0;

    hasJumped = keysPressed.contains(LogicalKeyboardKey.keyW) ||
        keysPressed.contains(LogicalKeyboardKey.arrowUp) ||
        keysPressed.contains(LogicalKeyboardKey.space);

    return super.onKeyEvent(event, keysPressed);
  }

  void _loadAllAnimation() {
    runningAnimation = _spriteAnimation('Walk', 5);
    idleAnimation = _spriteAnimation('Idle', 5);
    jumpingAnimation = _spriteAnimation('Single_Jump', 1);
    // fallingAnimation = _spriteAnimation('Idle', 3);

    animations = {
      PlayerStates.idle: idleAnimation,
      PlayerStates.running: runningAnimation,
      PlayerStates.jumping: jumpingAnimation,
      // PlayerStates.falling: fallingAnimation,
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

  void _updatePlayerState() {
    PlayerStates playerState = PlayerStates.idle;

// change where player is facing (left or right) based on the key pressed

    if (velocity.x < 0 && scale.x > 0) {
      flipHorizontallyAroundCenter();
    } else if (velocity.x > 0 && scale.x < 0) {
      flipHorizontallyAroundCenter();
    }

// change playerState based on the current action

    // for running animation
    if (velocity.x > 0 || velocity.x < 0) {
      playerState = PlayerStates.running;
    }

    // for jumping animation
    if (velocity.y < 0) {
      playerState = PlayerStates.jumping;
    }

    // for falling animation
    // if (velocity.y > 0) {
    //   playerState = PlayerStates.falling;
    // }

    current = playerState;
  }

  void _updatePlayerMovement(double dt) {
    if (hasJumped && isOnGround) _playerJump(dt);

    // if (velocity.y > _gravity) isOnGround = false;  allows jump while falling (optional)

    velocity.x = horizontalMovement * moveSpeed;
    position.x += velocity.x * dt;
  }

  void _playerJump(double dt) {
    velocity.y = -_jumpForce;
    position.y += velocity.y * dt;
    isOnGround = false;
    hasJumped = false;
  }

  void _checkHorizontalCollisions() {
    for (final block in collisionBlocks) {
      if (!block.isPlatform) {
        if (checkCollision(this, block)) {
          if (velocity.x > 0) {
            velocity.x = 0;
            position.x = block.x - hitbox.offsetX - hitbox.width;
            break;
          }
          if (velocity.x < 0) {
            velocity.x = 0;
            position.x = block.x + block.width + hitbox.width + hitbox.offsetX;
            break;
          }
        }
      }
    }
  }

  void _applyGravity(double dt) {
    velocity.y += _gravity;
    velocity.y = velocity.y.clamp(-_jumpForce, _terminalVelocity);
    position.y += velocity.y * dt;
  }

  void _checkVerticalCollisions() {
    for (final block in collisionBlocks) {
      if (block.isPlatform) {
        //for platform objects
        if (checkCollision(this, block)) {
          if (velocity.y > 0) {
            if (velocity.y > 0) {
              velocity.y = 0;
              position.y = block.y - hitbox.height - hitbox.offsetY;
              isOnGround = true;
              break;
            }
          }
        }
      } else {
        if (checkCollision(this, block)) {
          //for normal blocks
          if (velocity.y > 0) {
            velocity.y = 0;
            position.y = block.y - hitbox.height - hitbox.offsetY;
            isOnGround = true;
            break;
          }
          if (velocity.y < 0) {
            velocity.y = 0;
            position.y = block.y + block.height - hitbox.offsetY;
          }
        }
      }
    }
  }
}
