import 'package:flame_audio/flame_audio.dart';

class SoundManager {
  static final SoundManager _instance = SoundManager._internal();

  factory SoundManager() {
    return _instance;
  }

  SoundManager._internal();

  bool soundsEnabled = true;
  double volume = 0.1;

  Future<void> preloadSounds(List<String> soundFiles) async {
    await FlameAudio.audioCache.loadAll(soundFiles);
  }

  void playSound(String sound) {
    if (soundsEnabled) {
      FlameAudio.play(sound, volume: volume);
    }
  }

  void stopAll() {
    FlameAudio.bgm.stop();
  }
}
