import 'dart:io';

import 'package:bob_the_rodent/game/bob_the_rodent.dart';
import 'package:bob_the_rodent/game/game_play.dart';
import 'package:flame/game.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class MainMenu extends StatelessWidget {
  const MainMenu({super.key});

  @override
  Widget build(BuildContext context) {
    BobTheRodent game = BobTheRodent();
    return Scaffold(
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/Background/Forest.jpg'),
            fit: BoxFit.cover,
          ),
        ),
        child: Center(
          child: Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            color: Colors.black.withOpacity(0.4),
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 100, vertical: 40),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    'Bob the Rodent',
                    style: TextStyle(
                        fontSize: 60,
                        color: Colors.white,
                        fontFamily: 'Audiowide'),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Container(
                    height: 50,
                    width: 250,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color.fromRGBO(205, 224, 200, 1),
                      ),
                      child: const Text(
                        'Play',
                        style: TextStyle(
                          fontSize: 30,
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
                    width: 250,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color.fromRGBO(205, 224, 200, 1),
                      ),
                      child: const Text(
                        'Quit Game',
                        style: TextStyle(
                          fontSize: 30,
                          fontFamily: 'Audiowide',
                        ),
                      ),
                      //works on android emulators
                      onPressed: () {
                        // if (Platform.isAndroid) {
                        //   SystemNavigator.pop();
                        // } else {
                        //   exit(0);
                        // }
                        SystemNavigator.pop();
                      },
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
