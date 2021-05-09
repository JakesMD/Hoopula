class Tools {
  static String formatTime(int seconds) {
    final String hoursStr =
        ((seconds / (60 * 60)) % 60).floor().toString().padLeft(2, '0');
    final String minutesStr =
        ((seconds / 60) % 60).floor().toString().padLeft(2, '0');
    final String secondsStr = (seconds % 60).floor().toString().padLeft(2, '0');

    return "$hoursStr:$minutesStr:$secondsStr";
  }
}
