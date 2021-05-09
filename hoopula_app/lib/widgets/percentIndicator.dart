import 'package:flutter/material.dart';
import 'package:hoopula/widgets/animatedText.dart';
import 'package:hoopula/widgets/plusMinusIcons.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';

/// The circular progress indicator that includes some animated text and [PlusMinusIcons] in the center.
class PercentIndicator extends StatelessWidget {
  /// The text to display in the center.
  final String text;

  /// The progress in %.
  final double percent;

  /// Called when the plus icon is pressed.
  final Function onPlusPressed;

  /// Called when the minus icon is pressed.
  final Function onMinusPressed;

  PercentIndicator({
    @required this.text,
    @required this.percent,
    this.onMinusPressed,
    this.onPlusPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: ConstrainedBox(
          constraints: BoxConstraints(maxHeight: 400),
          child: LayoutBuilder(
            /// The circular progress indicator.
            builder: (context, constraints) => CircularPercentIndicator(
              radius: constraints.maxHeight,
              percent: percent <= 1 ? percent : 1,
              lineWidth: 20,
              circularStrokeCap: CircularStrokeCap.round,
              progressColor: Colors.orange,
              backgroundColor: Colors.white.withAlpha(80),
              animateFromLastPercent: true,
              animation: true,
              animationDuration: 250,
              center: Padding(
                padding: const EdgeInsets.fromLTRB(40, 60, 40, 60),
                child: Column(
                  children: [
                    /// The text.
                    Expanded(
                      child: AnimatedText(
                        text,
                        fontSize: 70,
                        duration: Duration.zero,
                      ),
                    ),

                    /// The plus and minus icons.
                    PlusMinusIcons(
                      onMinusPressed: onMinusPressed,
                      onPlusPressed: onPlusPressed,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
