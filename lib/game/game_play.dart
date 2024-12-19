import 'package:bob_the_rodent/game/bob_the_rodent.dart';
import 'package:bob_the_rodent/widgets/game_over.dart';
import 'package:bob_the_rodent/widgets/pause_button.dart';
import 'package:bob_the_rodent/widgets/pause_menu.dart';
import 'package:flame/game.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class GamePlay extends StatelessWidget {
  GamePlay({super.key});
  final BobTheRodent game = BobTheRodent();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GameWidget(
          game: kDebugMode ? BobTheRodent() : game,
          initialActiveOverlays: [
            PauseButton.ID
          ],
          overlayBuilderMap: {
            PauseButton.ID: (BuildContext context, BobTheRodent gameRef) =>
                PauseButton(
                  gameRef: gameRef,
                ),
            PauseMenu.ID: (BuildContext context, BobTheRodent gameRef) =>
                PauseMenu(
                  gameRef: gameRef,
                ),
            GameOver.ID: (BuildContext context, BobTheRodent gameRef) =>
                GameOver(
                  gameRef: gameRef,
                ),
          }),
    );
  }
}
