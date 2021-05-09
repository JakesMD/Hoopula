import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:hoopula/services/gameService.dart';
import 'package:hoopula/services/providers.dart';
import 'package:hoopula/services/tools.dart';
import 'package:hoopula/widgets/percentIndicator.dart';
import 'package:hoopula/widgets/scoreText.dart';
import 'package:hoopula/widgets/playResetIcons.dart';

/// The tab that counts your score within a certain time.
class CountdownSOTab extends StatefulHookWidget {
  CountdownSOTab({Key key = const Key("CountdownSOTab")}) : super(key: key);

  @override
  _CountdownSOTabState createState() => _CountdownSOTabState();
}

class _CountdownSOTabState extends State<CountdownSOTab> {
  GameService _game;
  bool _isFirstBuild = true; // Used to run setup on the first build.
  final ScoreText _scoreText = ScoreText();

  /// Sets up and resets the game.
  void _setup() {
    _game.setup(
      newTargetType: TargetType.time,
      newAudioSoundNumber: 1,
      newOnScored: () => _scoreText.update(_game.score1),
      initialTarget: 30,
    );
    _reset();
    _isFirstBuild = false;
  }

  /// Resets the game.
  void _reset() {
    _game.reset();
    if (!_isFirstBuild) setState(() => _scoreText.update(0));
  }

  @override
  Widget build(BuildContext context) {
    // Gets the GamesService from the provider.
    _game = useProvider(gameProvider);

    // Sets up the game on the first build.
    if (_isFirstBuild && _game.isBTConnected) _setup();

    return Row(
      children: [
        Expanded(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Spacer(),
              // The score text.
              SizedBox(
                height: MediaQuery.of(context).size.height / 3,
                child: _scoreText,
              ),
              Spacer(),
              // The play/pause and reset icons.
              PlayResetIcons(
                isPaused: !_game.isPlaying,
                onPaused: _game.canPause ? _game.playPause : null,
                onReset: _game.isBTConnected ? _reset : null,
              ),
            ],
          ),
        ),
        // The circular time remaining progress bar.
        PercentIndicator(
          text: Tools.formatTime(_game.target - _game.time),
          percent: (1 - _game.time / _game.target),
          onMinusPressed:
              _game.canDecreaseTarget ? () => _game.decreaseTarget(5) : null,
          onPlusPressed:
              _game.canIncreaseTarget ? () => _game.increaseTarget(5) : null,
        ),
      ],
    );
  }

  @override
  void dispose() {
    super.dispose();
    _game.cancel();
  }
}
