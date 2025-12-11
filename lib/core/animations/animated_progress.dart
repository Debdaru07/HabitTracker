import 'package:flutter/material.dart';

class AnimatedProgress extends StatelessWidget {
  final double value;
  final Color color;

  const AnimatedProgress({super.key, required this.value, required this.color});

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0, end: value),
      duration: const Duration(milliseconds: 450),
      curve: Curves.easeOutCubic,
      builder: (context, animatedValue, child) {
        return FractionallySizedBox(
          alignment: Alignment.centerLeft,
          widthFactor: animatedValue,
          child: Container(color: color),
        );
      },
    );
  }
}
