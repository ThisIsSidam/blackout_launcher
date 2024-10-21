import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

class SwipeDetector extends StatelessWidget {
  final Widget child;
  final VoidCallback? onSwipeLeft;
  final VoidCallback? onSwipeRight;
  final VoidCallback? onSwipeUpwards;
  final VoidCallback? onSwipeDownwards;
  final double velocityThreshold;

  const SwipeDetector({
    super.key,
    required this.child,
    this.onSwipeLeft,
    this.onSwipeRight,
    this.onSwipeUpwards,
    this.onSwipeDownwards,
    this.velocityThreshold = 1000.0, // Adjust this value as needed
  });

  @override
  Widget build(BuildContext context) {
    return RawGestureDetector(
      behavior: HitTestBehavior.translucent,
      gestures: <Type, GestureRecognizerFactory>{
        HorizontalDragGestureRecognizer: GestureRecognizerFactoryWithHandlers<
            HorizontalDragGestureRecognizer>(
          () => HorizontalDragGestureRecognizer(),
          (HorizontalDragGestureRecognizer instance) {
            instance.onEnd = (details) {
              if (details.primaryVelocity == null) return;
              if (details.primaryVelocity!.abs() < velocityThreshold) return;

              if (details.primaryVelocity! > 0) {
                print('right');
                onSwipeRight?.call();
              } else {
                print('left');
                onSwipeLeft?.call();
              }
            };
          },
        ),
        VerticalDragGestureRecognizer:
            GestureRecognizerFactoryWithHandlers<VerticalDragGestureRecognizer>(
          () => VerticalDragGestureRecognizer(),
          (VerticalDragGestureRecognizer instance) {
            instance.onEnd = (details) {
              if (details.primaryVelocity == null) return;
              if (details.primaryVelocity!.abs() < velocityThreshold) return;

              if (details.primaryVelocity! > 0) {
                print('down');
                onSwipeDownwards?.call();
              } else {
                print('up');
                onSwipeUpwards?.call();
              }
            };
          },
        ),
      },
      child: child,
    );
  }
}
