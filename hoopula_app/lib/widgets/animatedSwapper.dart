import 'package:flutter/material.dart';

/// A widget that animates between it's children when they change (like a custom [AnimatedSwitcher]).
class AnimatedSwapper extends StatelessWidget {
  /// The child to be animated.
  final Widget child;

  /// Uses a [SlideTransition] if true.
  final bool slideTransitionOn;

  /// The duration of the animation.
  final Duration duration;

  AnimatedSwapper({
    @required this.child,
    this.slideTransitionOn = false,
    this.duration = const Duration(milliseconds: 500),
  });

  @override
  Widget build(BuildContext context) {
    bool isFirstChild = true;

    return ClipRRect(
      child: AnimatedSwitcher(
          duration: duration,
          switchInCurve: Curves.easeInOut,
          switchOutCurve: Curves.easeInOut,
          child: child,
          transitionBuilder: (child, animation) {
            final slideAnimation = isFirstChild
                ? Tween<Offset>(begin: Offset(0.0, 1.0), end: Offset(0.0, 0.0))
                    .animate(animation)
                : Tween<Offset>(begin: Offset(0.0, -1.0), end: Offset(0.0, 0.0))
                    .animate(animation);

            isFirstChild = !isFirstChild;

            return FadeTransition(
              opacity: animation,
              child: slideTransitionOn
                  ? SlideTransition(
                      child: child,
                      position: slideAnimation,
                    )
                  : child,
            );
          }),
    );
  }
}
