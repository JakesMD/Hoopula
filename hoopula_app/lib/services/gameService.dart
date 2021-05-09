import 'dart:async';
import 'package:flutter/material.dart';
import 'package:hoopula/services/audioService.dart';
import 'package:hoopula/services/bluetoothService.dart';
import 'package:hoopula/services/clockService.dart';

/// The service that controls the game including the scores.
class GameService extends ChangeNotifier {
  final BluetoothService bluetoothService = BluetoothService();
  final AudioService audioService = AudioService();

  GameService() {
    // Start listening to the bluetooth as soon as this is initialized.
    bluetoothService.onData = onData;
    bluetoothService.addListener(() => notifyListeners());
  }

  /// The type of target (score or time).
  TargetType targetType = TargetType.score;

  /// The audio sound to play (1,2).
  int audioSoundNumber = 1;

  /// Called when a hoop is scored.
  Function onScored = () {};

  /// The stopwatch.
  StreamSubscription<int> _stopwatch;

  /// The score for player 1.
  int score1 = 0;

  /// The score for player 2.
  int score2 = 0;

  /// The current time elapsed.
  int time = 0;

  /// The target number.
  int target = 10;

  /// The current players turn (first, second).
  Player currentPlayer = Player.first;

  /// Returns true if the bluetooth is connected.
  bool get isBTConnected => bluetoothService.isConnected;

  /// Returns true if the game is over.
  bool get isGameOver =>
      (targetType == TargetType.score &&
          (score1 >= target || score2 >= target)) ||
      (targetType == TargetType.time && time >= target);

  /// Returns true if the game is not over and has not been paused.
  bool get isPlaying =>
      _stopwatch != null &&
      !_stopwatch.isPaused &&
      isBTConnected &&
      !isGameOver;

  /// Returns true if pausing the game is possible.
  bool get canPause => _stopwatch != null && isBTConnected && !isGameOver;

  /// Returns true if increasing the target is possible.
  bool get canIncreaseTarget => !isPlaying;

  /// Returns true if decreasing the target is possible.
  bool get canDecreaseTarget =>
      !isPlaying &&
      ((targetType == TargetType.score &&
              target - score1 > 1 &&
              target - score2 > 1) ||
          (targetType == TargetType.time &&
              target >= 10 &&
              target - time >= 10));

  /// Stops the game and plays "completed" sound.
  void doGameOver() {
    _stopwatch.pause();
    audioService.play("completed");
  }

  /// Increases the target number by [amount].
  void increaseTarget(int amount) {
    if (canIncreaseTarget) {
      target += amount;
      notifyListeners();
    }
  }

  /// Decreases the target number by [amount].
  void decreaseTarget(int amount) {
    if (canDecreaseTarget) {
      target -= amount;
      notifyListeners();
    }
  }

  /// Swap the current players (first <-> second).
  void swapPlayers() {
    currentPlayer =
        currentPlayer == Player.first ? Player.second : Player.first;
    notifyListeners();
  }

  /// Sets up a new game.
  void setup({
    @required TargetType newTargetType,
    @required int newAudioSoundNumber,
    @required Function newOnScored,
    @required int initialTarget,
  }) {
    targetType = newTargetType;
    audioSoundNumber = newAudioSoundNumber;
    onScored = newOnScored;
    target = initialTarget;
  }

  /// Resets the current game.
  void reset() async {
    score1 = 0;
    score2 = 0;
    time = 0;
    currentPlayer = Player.first;
    if (_stopwatch != null) await _stopwatch.cancel();
    _stopwatch = ClockService.stopwatch().listen((newTick) {
      time = newTick;
      if (isGameOver) doGameOver();
      notifyListeners();
    });
    _stopwatch.pause();
  }

  /// Cancels the stopwatch.
  void cancel() => _stopwatch != null ? _stopwatch.cancel() : null;

  /// Plays/Pauses the current game.
  void playPause() {
    if (canPause) {
      isPlaying ? _stopwatch.pause() : _stopwatch.resume();
      notifyListeners();
    }
  }

  /// Called when a message is received from the Hoopula ESP32.
  void onData(String data) {
    if (isPlaying) {
      if (data == "scored") {
        currentPlayer == Player.first ? score1++ : score2++;
        onScored();
        isGameOver
            ? doGameOver()
            : audioService.play("scored$audioSoundNumber");
      } else if (data == "missed") {
        audioService.play("missed$audioSoundNumber");
      }
    }
    notifyListeners();
  }
}

class TargetType {
  static final ScoreTargetType score = ScoreTargetType();
  static final TimeTargetType time = TimeTargetType();
}

class ScoreTargetType extends TargetType {}

class TimeTargetType extends TargetType {}

class Player {
  static final FirstPlayer first = FirstPlayer();
  static final SecondPlayer second = SecondPlayer();
}

class FirstPlayer extends Player {}

class SecondPlayer extends Player {}
