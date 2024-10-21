import 'package:bob_the_rodent/bob_the_rodent.dart';
import 'package:flame/flame.dart';
import 'package:flame/game.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  Flame.device.fullScreen();
  Flame.device.setLandscape();

  BobTheRodent game = BobTheRodent();
  runApp(GameWidget(game: kDebugMode ? BobTheRodent() : game));
}
