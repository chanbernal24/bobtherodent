import 'package:bob_the_rodent/game/bob_the_rodent.dart';
import 'package:bob_the_rodent/widgets/pause_menu.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class PauseButton extends StatelessWidget {
  final BobTheRodent gameRef;
  static const String ID = 'PauseButton';

  const PauseButton({super.key, required this.gameRef});

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: const Icon(
        Icons.pause,
        color: Color.fromRGBO(205, 224, 200, 1),
        size: 60,
      ),
      onPressed: () {
        gameRef.pauseEngine();
        gameRef.overlays.add(PauseMenu.ID);
        gameRef.overlays.remove(PauseButton.ID);
      },
    );
  }
}
