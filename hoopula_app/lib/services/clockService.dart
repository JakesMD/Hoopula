import 'dart:async';

/// The service that controls the timers and stopwatches.
class ClockService {
  static Stream<int> stopwatch() {
    StreamController<int> streamController;
    Timer timer;
    Duration timerInterval = Duration(seconds: 1);
    int counter = 0;

    void stopTimer() {
      if (timer != null) {
        timer.cancel();
        timer = null;
        counter = 0;
        streamController.close();
      }
    }

    void tick(_) {
      counter++;
      streamController.add(counter);
    }

    void startTimer() {
      timer = Timer.periodic(timerInterval, tick);
    }

    void pauseTimer() {
      if (timer != null) timer.cancel();
    }

    streamController = StreamController<int>(
      onListen: startTimer,
      onCancel: stopTimer,
      onResume: startTimer,
      onPause: pauseTimer,
    );

    return streamController.stream;
  }

  static Stream<int> countdownTimer(int initialTick) {
    StreamController<int> streamController;
    Timer timer;
    Duration timerInterval = Duration(seconds: 1);
    int counter = initialTick;

    void stopTimer() {
      if (timer != null) {
        timer.cancel();
        timer = null;
        counter = initialTick;
        streamController.close();
      }
    }

    void tick(_) {
      counter--;
      streamController.add(counter);
      if (counter == 0) stopTimer();
    }

    void startTimer() {
      timer = Timer.periodic(timerInterval, tick);
    }

    void pauseTimer() {
      if (timer != null) timer.cancel();
    }

    streamController = StreamController<int>(
      onListen: startTimer,
      onCancel: stopTimer,
      onResume: startTimer,
      onPause: pauseTimer,
    );

    return streamController.stream;
  }
}
