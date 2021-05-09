import 'package:flutter/material.dart';
import 'package:hoopula/widgets/actionIcon.dart';

/// 2 animated icons that play/pause and reset the game.
class PlayResetIcons extends StatelessWidget {
  /// Displays play icon if true, pause icon if false.
  final bool isPaused;

  /// Called when the play icon is pressed.
  final Function onPaused;

  /// Called when the reset icon is pressed.
  final Function onReset;

  PlayResetIcons({this.onPaused, this.onReset, this.isPaused = true});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        /// The play/pause icon.
        ActionIcon(
          icon: isPaused ? Icons.play_arrow_rounded : Icons.pause_rounded,
          onPressed: onPaused,
          color: Colors.white,
          disabledColor: Colors.white.withAlpha(80),
          size: 50,
        ),

        /// The reset icon.
        ActionIcon(
          icon: Icons.refresh_rounded,
          onPressed: onReset,
          color: Colors.white,
          disabledColor: Colors.white.withAlpha(80),
          size: 50,
        ),
      ],
    );
  }
}
