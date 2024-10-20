import 'package:flutter/material.dart';

class SwipeDetector extends StatelessWidget {
  final Widget child;
  final VoidCallback? onSwipeLeft;
  final VoidCallback? onSwipeRight;
  final VoidCallback? onSwipeUpwards;
  final VoidCallback? onSwipeDownwards;

  const SwipeDetector(
      {super.key,
      required this.child,
      this.onSwipeLeft,
      this.onSwipeRight,
      this.onSwipeUpwards,
      this.onSwipeDownwards});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onPanEnd: (details) {
          // Constants for gesture detection
          const double threshold = 1.0; // Horizontal vs vertical threshold
          const double minimumVelocity =
              300.0; // Minimum velocity to trigger gesture

          // Get velocity components
          final velocity = details.velocity.pixelsPerSecond;
          final double vx = velocity.dx.abs();
          final double vy = velocity.dy.abs();

          // Helper function to determine if gesture is primarily horizontal
          bool isHorizontalGesture() => vx > threshold * vy;

          // Helper function to determine if gesture is primarily vertical
          bool isVerticalGesture() => vy > threshold * vx;

          // Only process gestures that exceed minimum velocity
          if (vx > minimumVelocity || vy > minimumVelocity) {
            if (isHorizontalGesture()) {
              if (velocity.dx > 0) {
                // Right swipe
                onSwipeRight?.call();
              } else {
                // Left swipe
                onSwipeLeft?.call();
              }
            } else if (isVerticalGesture()) {
              if (velocity.dy < 0) {
                // Upward swipe
                onSwipeUpwards?.call();
              } else {
                // Downward swipe
                onSwipeDownwards?.call();
              }
            }
          }
        },
        child: child);
  }
}
