import 'package:bob_the_rodent/game/bob_the_rodent.dart';
import 'package:bob_the_rodent/game/game_play.dart';
import 'package:bob_the_rodent/screens/main_menu.dart';
import 'package:bob_the_rodent/widgets/pause_button.dart';
import 'package:flutter/material.dart';

class GameOver extends StatelessWidget {
  final BobTheRodent gameRef;
  static const String ID = 'GameOver';
  const GameOver({super.key, required this.gameRef});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        color: Colors.black.withOpacity(0.5),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 120, vertical: 60),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'GAME COMPLETED',
                style: TextStyle(
                    fontSize: 50, color: Colors.white, fontFamily: 'Audiowide'),
              ),
              const SizedBox(
                height: 20,
              ),
              Container(
                height: 50,
                width: 200,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromRGBO(205, 224, 200, 1),
                  ),
                  child: const Text(
                    'Play Again',
                    style: TextStyle(
                      fontSize: 20,
                      fontFamily: 'Audiowide',
                    ),
                  ),
                  onPressed: () {
                    Navigator.of(context).pushReplacement(
                      MaterialPageRoute(
                        builder: (context) => GamePlay(),
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(
                height: 15,
              ),
              Container(
                height: 50,
                width: 200,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromRGBO(205, 224, 200, 1),
                  ),
                  child: const Text(
                    'Main Menu',
                    style: TextStyle(
                      fontSize: 20,
                      fontFamily: 'Audiowide',
                    ),
                  ),
                  onPressed: () {
                    Navigator.of(context).pushReplacement(
                      MaterialPageRoute(
                        builder: (context) => MainMenu(),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
