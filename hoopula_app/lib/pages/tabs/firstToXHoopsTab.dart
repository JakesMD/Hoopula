import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:hoopula/services/gameService.dart';
import 'package:hoopula/services/providers.dart';
import 'package:hoopula/widgets/animatedText.dart';
import 'package:hoopula/widgets/clockText.dart';
import 'package:hoopula/widgets/plusMinusIcons.dart';
import 'package:hoopula/widgets/scoreText.dart';
import 'package:hoopula/widgets/playResetIcons.dart';

/// The multiplayer tab that tests who can reach the target first.
class FirstToXHoopsTab extends StatefulHookWidget {
  FirstToXHoopsTab({Key key = const Key("FirstToXHoopsTab")}) : super(key: key);

  @override
  _FirstToXHoopsTabState createState() => _FirstToXHoopsTabState();
}

class _FirstToXHoopsTabState extends State<FirstToXHoopsTab> {
  GameService _game;
  bool _isFirstBuild = true; // Used to run setup on the first build.
  final ScoreText _score1Text = ScoreText(key: Key("score1"));
  final ScoreText _score2Text = ScoreText(key: Key("score2"));

  /// Sets up and resets the game.
  void _setup() {
    _game.setup(
      newTargetType: TargetType.score,
      newAudioSoundNumber: 1,
      newOnScored: () => _game.currentPlayer == Player.first
          ? _score1Text.update(_game.score1)
          : _score2Text.update(_game.score2),
      initialTarget: 10,
    );
    _reset();
    _isFirstBuild = false;
  }

  /// Resets the game.
  void _reset() {
    _game.reset();
    if (!_isFirstBuild)
      setState(() {
        _score1Text.update(0);
        _score2Text.update(0);
      });
  }

  @override
  Widget build(BuildContext context) {
    // Gets the GamesService from the provider.
    _game = useProvider(gameProvider);

    // Sets up the game on the first build.
    if (_isFirstBuild && _game.isBTConnected) _setup();

    return Row(
      children: [
        // The score text for the player 1.
        PlayerScore(
          scoreText: _score1Text,
          hasTurn: _game.currentPlayer == Player.first,
          onPressed:
              _game.currentPlayer != Player.first ? _game.swapPlayers : null,
        ),
        Expanded(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Spacer(),
              // The target text.
              AnimatedText(
                _game.target.toString(),
                fontSize: 70,
                duration: Duration.zero,
              ),
              // The icons to increase and decrease the target.
              PlusMinusIcons(
                onMinusPressed: _game.canDecreaseTarget
                    ? () => _game.decreaseTarget(1)
                    : null,
                onPlusPressed: _game.canIncreaseTarget
                    ? () => _game.increaseTarget(1)
                    : null,
              ),
              Spacer(),
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
        // The score text for the player 2.
        PlayerScore(
          scoreText: _score2Text,
          hasTurn: _game.currentPlayer == Player.second,
          onPressed:
              _game.currentPlayer != Player.second ? _game.swapPlayers : null,
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

/// The button with the score text to represent a player on the [FirstToXHoopsTab].
class PlayerScore extends StatelessWidget {
  /// Called when the button is pressed.
  final Function onPressed;

  /// The score text for the player.
  final Widget scoreText;

  /// Displays orange bar if true.
  final bool hasTurn;

  PlayerScore({@required this.scoreText, this.hasTurn = false, this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: onPressed,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // The score text.
            SizedBox(
              height: MediaQuery.of(context).size.height / 3,
              child: scoreText,
            ),
            // The bar that indicates whether it is the players turn or not.
            AnimatedContainer(
              duration: Duration(milliseconds: 250),
              margin: EdgeInsets.symmetric(horizontal: 20),
              height: 20,
              decoration: BoxDecoration(
                color: hasTurn ? Colors.orange : Colors.transparent,
                borderRadius: BorderRadius.circular(20),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
