import 'package:flutter/material.dart';
import 'package:hoopula/widgets/animatedSwapper.dart';

/// A custom animated IconButton.
class ActionIcon extends StatelessWidget {
  /// The icon to be (animated).
  final IconData icon;

  /// The color of the icon (animated).
  final Color color;

  /// The color of the icon when no [onPressed] is assigned.
  final Color disabledColor;

  /// The size of the icon (animated).
  final double size;

  /// Called when the icon is pressed.
  final Function onPressed;

  ActionIcon({
    @required this.icon,
    this.color = Colors.white,
    this.disabledColor = Colors.grey,
    this.size = 24,
    this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: AnimatedSwapper(
        duration: Duration(milliseconds: 250),
        child: onPressed != null
            ? Icon(
                icon,
                key: Key("$icon$color$size"),
                color: color,
                size: size,
              )
            : Icon(
                icon,
                key: Key("$icon$disabledColor$size"),
                color: disabledColor,
                size: size,
              ),
      ),
    );
  }
}
