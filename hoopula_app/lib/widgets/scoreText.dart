import 'package:flutter/material.dart';
import 'package:hoopula/widgets/animatedText.dart';

/// The animated text that displays the current score.
class ScoreText extends StatefulWidget {
  final _ScoreTextState _scoreTextState = _ScoreTextState();

  ScoreText({Key key}) : super(key: key);

  @override
  _ScoreTextState createState() => _scoreTextState;

  /// Animates to the [newScore].
  void update(int newScore) => _scoreTextState.update(newScore);
}

class _ScoreTextState extends State<ScoreText> {
  int _score = 0;

  void update(int newScore) => setState(() => _score = newScore);

  @override
  Widget build(BuildContext context) {
    return AnimatedText(
      _score.toString(),
      fontSize: 400,
      color: Colors.white,
      //  height: 0.75,
      slideTransitionOn: true,
    );
  }
}
