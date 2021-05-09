import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:hoopula/services/gameService.dart';
import 'package:hoopula/services/providers.dart';
import 'package:hoopula/widgets/clockText.dart';
import 'package:hoopula/widgets/percentIndicator.dart';
import 'package:hoopula/widgets/scoreText.dart';
import 'package:hoopula/widgets/playResetIcons.dart';

/// The tabs that counts how long it takes to get a certain score.
class TimeToXHoopsTab extends StatefulHookWidget {
  TimeToXHoopsTab({Key key = const Key("TimeToXHoopsTab")}) : super(key: key);

  @override
  _TimeToXHoopsTabState createState() => _TimeToXHoopsTabState();
}

class _TimeToXHoopsTabState extends State<TimeToXHoopsTab> {
  GameService _game;
  bool _isFirstBuild = true; // Used to run setup on the first build.
  final ScoreText _scoreText = ScoreText();

  /// Sets up and resets the game.
  void _setup() {
    _game.setup(
      newTargetType: TargetType.score,
      newAudioSoundNumber: 1,
      newOnScored: () => _scoreText.update(_game.score1),
      initialTarget: 10,
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
              // The stopwatch text.
              ClockText(time: _game.time),
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
        // The circular hoops remaining progress bar.
        PercentIndicator(
          text: "${_game.target - _game.score1}",
          percent: _game.score1 / _game.target,
          onMinusPressed:
              _game.canDecreaseTarget ? () => _game.decreaseTarget(1) : null,
          onPlusPressed:
              _game.canIncreaseTarget ? () => _game.increaseTarget(1) : null,
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
