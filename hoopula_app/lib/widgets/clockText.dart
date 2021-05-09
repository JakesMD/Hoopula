import 'package:flutter/material.dart';
import 'package:hoopula/services/tools.dart';
import 'package:hoopula/widgets/animatedText.dart';

/// The text that animates the time.
class ClockText extends StatelessWidget {
  /// The current time.
  final int time;

  ClockText({@required this.time});

  @override
  Widget build(BuildContext context) {
    return AnimatedText(
      Tools.formatTime(time),
      fontSize: 25,
      color: Colors.white,
      duration: Duration.zero,
    );
  }
}
