import 'package:flutter/material.dart';
import 'package:hoopula/widgets/actionIcon.dart';

/// 2 animated icons that increase or decrease the target.
class PlusMinusIcons extends StatelessWidget {
  /// Called when the minus icon is pressed.
  final Function onMinusPressed;

  /// Called when the plus icon is pressed.
  final Function onPlusPressed;

  PlusMinusIcons({this.onMinusPressed, this.onPlusPressed});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        /// The minus icon.
        ActionIcon(
          icon: Icons.remove_circle_rounded,
          size: 30,
          disabledColor: Colors.white.withAlpha(80),
          onPressed: onMinusPressed,
        ),
        SizedBox(width: 20),

        /// The plus icon.
        ActionIcon(
          icon: Icons.add_circle_rounded,
          size: 30,
          disabledColor: Colors.white.withAlpha(80),
          onPressed: onPlusPressed,
        ),
      ],
    );
  }
}
