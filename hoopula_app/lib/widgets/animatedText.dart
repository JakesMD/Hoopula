import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:hoopula/widgets/animatedSwapper.dart';

/// A text widget that animates when values are changed.
class AnimatedText extends StatelessWidget {
  /// The text of the text (animated).
  final String text;

  /// The color of the text (animated).
  final Color color;

  /// The size of the font (animated).
  final double fontSize;

  /// The font thickness (animated).
  final FontWeight fontWeight;

  /// The height of the text.
  final double height;

  /// Uses a [SlideTransition] if true.
  final bool slideTransitionOn;

  /// The duration of the animation.
  final Duration duration;

  /// The alignment of the text.
  final TextAlign textAlign;

  /// The font of the text.
  final String fontFamily;

  AnimatedText(
    this.text, {
    this.color = Colors.white,
    this.fontSize = 18,
    this.fontWeight = FontWeight.bold,
    this.height = 1,
    this.slideTransitionOn = false,
    this.duration = const Duration(milliseconds: 500),
    this.textAlign = TextAlign.center,
    this.fontFamily = "NovaMono",
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedSwapper(
      slideTransitionOn: slideTransitionOn,
      duration: duration,
      child: AutoSizeText(
        text,
        key: Key("$text$color$fontSize$fontWeight"),
        style: TextStyle(
            color: color,
            fontWeight: fontWeight,
            fontSize: fontSize,
            height: height,
            fontFamily: fontFamily),
        maxFontSize: fontSize,
        maxLines: 1,
        textAlign: TextAlign.center,
      ),
    );
  }
}
