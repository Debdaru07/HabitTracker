import 'package:flutter/material.dart';

class FadeIn extends StatelessWidget {
  final Widget child;
  final Duration duration;
  final Curve curve;

  const FadeIn({
    super.key,
    required this.child,
    this.duration = const Duration(milliseconds: 350),
    this.curve = Curves.easeOut,
  });

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0, end: 1),
      duration: duration,
      curve: curve,
      builder: (_, value, child) => Opacity(opacity: value, child: child),
      child: child,
    );
  }
}
