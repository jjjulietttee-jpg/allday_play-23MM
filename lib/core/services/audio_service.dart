import 'package:audioplayers/audioplayers.dart';

class AudioService {
  static final AudioService _instance = AudioService._internal();
  factory AudioService() => _instance;
  AudioService._internal();

  final AudioPlayer _musicPlayer = AudioPlayer();
  final AudioPlayer _sfxPlayer = AudioPlayer();

  bool _isMusicEnabled = true;
  bool _isSfxEnabled = true;

  // Инициализация
  Future<void> init() async {
    print('🎵 Initializing AudioService...');
    
    // Настройка музыкального плеера
    await _musicPlayer.setReleaseMode(ReleaseMode.loop);
    await _musicPlayer.setPlayerMode(PlayerMode.mediaPlayer); // Важно для фонового воспроизведения
    
    // Настройка плеера для эффектов
    await _sfxPlayer.setReleaseMode(ReleaseMode.stop);
    await _sfxPlayer.setPlayerMode(PlayerMode.lowLatency); // Низкая задержка для эффектов
    
    // Слушаем изменения состояния музыкального плеера
    _musicPlayer.onPlayerStateChanged.listen((state) {
      print('🎵 Music player state: $state');
    });
    
    print('🎵 AudioService initialized successfully!');
  }

  // Фоновая музыка
  Future<void> playBackgroundMusic() async {
    if (!_isMusicEnabled) {
      print('🎵 Music is disabled');
      return;
    }
    
    try {
      print('🎵 Attempting to play background music...');
      
      // Устанавливаем громкость и аудио контекст
      await _musicPlayer.setVolume(0.5); // Увеличил до 50% для лучшей слышимости
      
      // Настройка аудио контекста для Android
      await _musicPlayer.setAudioContext(
        AudioContext(
          iOS: AudioContextIOS(
            category: AVAudioSessionCategory.playback,
            options: {AVAudioSessionOptions.mixWithOthers},
          ),
          android: AudioContextAndroid(
            isSpeakerphoneOn: false,
            stayAwake: true,
            contentType: AndroidContentType.music,
            usageType: AndroidUsageType.game,
            audioFocus: AndroidAudioFocus.gain, // Получаем полный аудио фокус
          ),
        ),
      );
      
      await _musicPlayer.play(AssetSource('sounds/background_music.mp3'));
      print('🎵 Background music started successfully!');
    } catch (e) {
      print('❌ Error playing background music: $e');
    }
  }

  Future<void> stopBackgroundMusic() async {
    print('🎵 Stopping background music');
    await _musicPlayer.stop();
  }

  Future<void> pauseBackgroundMusic() async {
    print('🎵 Pausing background music');
    await _musicPlayer.pause();
  }

  Future<void> resumeBackgroundMusic() async {
    print('🎵 Resuming background music');
    if (!_isMusicEnabled) return;
    await _musicPlayer.resume();
  }

  // Звуковые эффекты
  Future<void> playTapSound() async {
    if (!_isSfxEnabled) return;
    
    try {
      // Создаем новый плеер для каждого звука, чтобы не перебивать предыдущие
      final player = AudioPlayer();
      await player.setPlayerMode(PlayerMode.lowLatency);
      await player.setVolume(0.8); // Увеличил до 80%
      
      // Настраиваем аудио контекст чтобы не перебивать музыку
      await player.setAudioContext(
        AudioContext(
          android: AudioContextAndroid(
            contentType: AndroidContentType.sonification,
            usageType: AndroidUsageType.game,
            audioFocus: AndroidAudioFocus.gainTransientMayDuck, // Не останавливаем музыку
          ),
        ),
      );
      
      await player.play(AssetSource('sounds/tap_sound.mp3'));
      print('🔊 Tap sound played');
      
      // Освобождаем ресурсы после воспроизведения
      player.onPlayerComplete.listen((event) {
        player.dispose();
      });
    } catch (e) {
      print('❌ Error playing tap sound: $e');
    }
  }

  // Управление настройками
  void toggleMusic() {
    _isMusicEnabled = !_isMusicEnabled;
    if (!_isMusicEnabled) {
      stopBackgroundMusic();
    } else {
      playBackgroundMusic();
    }
  }

  void toggleSfx() {
    _isSfxEnabled = !_isSfxEnabled;
  }

  bool get isMusicEnabled => _isMusicEnabled;
  bool get isSfxEnabled => _isSfxEnabled;

  // Очистка ресурсов
  Future<void> dispose() async {
    await _musicPlayer.dispose();
    await _sfxPlayer.dispose();
  }
}
