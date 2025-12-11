import 'package:flutter/material.dart';

class SlideUp extends StatelessWidget {
  final Widget child;
  final Duration duration;
  final double offset;
  final Curve curve;

  const SlideUp({
    super.key,
    required this.child,
    this.duration = const Duration(milliseconds: 400),
    this.offset = 20,
    this.curve = Curves.easeOutCubic,
  });

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<Offset>(
      tween: Tween(begin: Offset(0, offset), end: Offset.zero),
      duration: duration,
      curve: curve,
      builder:
          (_, value, child) =>
              Transform.translate(offset: Offset(0, value.dy), child: child),
      child: child,
    );
  }
}
