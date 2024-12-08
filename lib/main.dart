import 'package:bob_the_rodent/game/bob_the_rodent.dart';
import 'package:bob_the_rodent/screens/main_menu.dart';
import 'package:flame/flame.dart';
import 'package:flame/game.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  Flame.device.fullScreen();
  Flame.device.setLandscape();

  // BobTheRodent game = BobTheRodent();
  // runApp(GameWidget(game: kDebugMode ? BobTheRodent() : game));
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Bob the Rodent',
      home: MainMenu(),
    );
  }
}
