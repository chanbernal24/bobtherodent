import 'dart:async';

import 'package:bob_the_rodent/bob_the_rodent.dart';
import 'package:bob_the_rodent/components/checkpoint.dart';
import 'package:bob_the_rodent/components/collision_block.dart';
import 'package:bob_the_rodent/components/cheese.dart';
import 'package:bob_the_rodent/components/custom_hitbox.dart';
import 'package:bob_the_rodent/components/utils.dart';
import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flutter/services.dart';

enum PlayerStates {
  idle,
  running,
  jumping,
  falling,
}

class Player extends SpriteAnimationGroupComponent
    with HasGameRef<BobTheRodent>, KeyboardHandler, CollisionCallbacks {
  Player({
    this.character = 'Capybara',
    position,
  }) : super(position: position);
  String character;

  late final SpriteAnimation idleAnimation;
  late final SpriteAnimation runningAnimation;
  late final SpriteAnimation jumpingAnimation;
  late final SpriteAnimation fallingAnimation;

  final double stepTime = 0.05;
  final double _gravity = 15;
  final double _jumpForce = 379;
  final double _terminalVelocity = 349;
  double horizontalMovement = 0;
  double moveSpeed = 169;
  double soundVolume = 0.04;

  Vector2 velocity = Vector2.zero();
  bool isOnGround = false;
  bool hasJumped = false;
  bool isCheckpointReached = false;
  List<CollisionBlock> collisionBlocks = [];
  CustomHitbox hitbox = CustomHitbox(
    offsetX: 4,
    offsetY: 8,
    width: 25,
    height: 24,
  );

  @override
  FutureOr<void> onLoad() {
    priority = 1;
    _loadAllAnimation();

    // debugMode = true;
    add(RectangleHitbox(
        position: Vector2(hitbox.offsetX, hitbox.offsetY),
        size: Vector2(hitbox.width, hitbox.height)));
    return super.onLoad();
  }

  @override
  void update(double dt) {
    if (!isCheckpointReached) {
      _updatePlayerState();
      _updatePlayerMovement(dt);
      _checkHorizontalCollisions();
      _applyGravity(dt);
      _checkVerticalCollisions();
    }
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

  @override
  void onCollisionStart(
      Set<Vector2> intersectionPoints, PositionComponent other) {
    if (other is Cheese) other.collidedWithPlayer();
    super.onCollision(intersectionPoints, other);
    if (other is Checkpoint && !isCheckpointReached) _reachedCheckpoint();
    // if (other is Hole) _respawn();
    super.onCollisionStart(intersectionPoints, other);
  }

  void _loadAllAnimation() {
    runningAnimation = _spriteAnimation('Walk-Updated', 5);
    idleAnimation = _spriteAnimation('Idle-Updated', 5);
    jumpingAnimation = _spriteAnimation('Jump_Double_Fall-Updated', 2);
    fallingAnimation = _spriteAnimation('Faint-Updated', 3);

    animations = {
      PlayerStates.idle: idleAnimation,
      PlayerStates.running: runningAnimation,
      PlayerStates.jumping: jumpingAnimation,
      PlayerStates.falling: fallingAnimation,
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
    if (velocity.y > 0) {
      playerState = PlayerStates.falling;
    }

    current = playerState;
  }

  void _updatePlayerMovement(double dt) {
    if (hasJumped && isOnGround) _playerJump(dt);

    // disable jump while falling

    if (velocity.y > _gravity) isOnGround = false;

    velocity.x = horizontalMovement * moveSpeed;
    position.x += velocity.x * dt;
  }

  void _playerJump(double dt) {
    // for sfx when jumping but it's bugged due to windows and flutter interaction
    // if (game.playSounds) SoundManager().playSound('jump.wav');

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

  void _reachedCheckpoint() {
    isCheckpointReached = true;

    // sfx when checkpoint is reached but bugged due to windows and flutter interaction
    // if (game.playSounds) SoundManager().playSound('teleporting.wav');

    const reachedCheckpointDuration = Duration(milliseconds: 1000);
    Future.delayed(reachedCheckpointDuration, () {
      isCheckpointReached = false;
      position = Vector2.all(-640);
      game.loadNextLevel();
      velocity.x = 0;
    });
  }
}
