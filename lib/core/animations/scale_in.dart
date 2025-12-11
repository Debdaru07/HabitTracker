import 'package:flutter/material.dart';

class ScaleIn extends StatelessWidget {
  final Widget child;
  final Duration duration;

  const ScaleIn({
    super.key,
    required this.child,
    this.duration = const Duration(milliseconds: 300),
  });

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0.92, end: 1),
      duration: duration,
      curve: Curves.easeOutBack,
      builder: (_, scale, child) => Transform.scale(scale: scale, child: child),
      child: child,
    );
  }
}
