# AudioService - Документация

## Описание

`AudioService` - синглтон-сервис для управления звуками в игре.

## Использование

```dart
final audioService = AudioService();

// Инициализация (вызывается в main.dart)
await audioService.init();

// Фоновая музыка
await audioService.playBackgroundMusic();
await audioService.pauseBackgroundMusic();
await audioService.resumeBackgroundMusic();
await audioService.stopBackgroundMusic();

// Звуковые эффекты
await audioService.playTapSound();

// Настройки
audioService.toggleMusic();  // вкл/выкл музыку
audioService.toggleSfx();    // вкл/выкл звуки
bool musicOn = audioService.isMusicEnabled;
bool sfxOn = audioService.isSfxEnabled;
```

## Где используется

### main.dart
```dart
// Инициализация при запуске приложения
await AudioService().init();
```

### rhythm_game_screen.dart
```dart
// Запуск музыки при входе в игру
_audioService.playBackgroundMusic();

// Звук тапа при нажатии
audioService.playTapSound();

// Пауза при паузе игры
audioService.pauseBackgroundMusic();
```

## Настройка громкости

```dart
// В методе playBackgroundMusic()
await _musicPlayer.setVolume(0.3); // 30% - фон

// В методе playTapSound()
await _sfxPlayer.setVolume(0.5); // 50% - эффекты
```

## Добавление новых звуков

### 1. Добавь звуковой файл
Положи файл в `assets/sounds/new_sound.mp3`

### 2. Добавь метод в AudioService
```dart
Future<void> playNewSound() async {
  if (!_isSfxEnabled) return;
  
  try {
    await _sfxPlayer.play(AssetSource('sounds/new_sound.mp3'));
    await _sfxPlayer.setVolume(0.5);
  } catch (e) {
    print('Error playing new sound: $e');
  }
}
```

### 3. Вызови метод где нужно
```dart
audioService.playNewSound();
```

## Технические детали

- Использует пакет `audioplayers: ^6.1.0`
- Два плеера: один для музыки, один для эффектов
- Музыка зацикливается (`ReleaseMode.loop`)
- Эффекты играют один раз (`ReleaseMode.stop`)
- Синглтон паттерн для глобального доступа

## Поддерживаемые форматы

- MP3 ✅
- WAV ✅
- OGG ✅
- M4A ✅ (iOS)
- AAC ✅

## Производительность

- Звуки загружаются из assets (быстро)
- Минимальная задержка воспроизведения
- Не блокирует UI
- Автоматическая очистка ресурсов
