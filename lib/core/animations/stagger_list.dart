import 'package:flutter/material.dart';

class StaggerList extends StatelessWidget {
  final List<Widget> children;
  final Duration interval;

  const StaggerList({
    super.key,
    required this.children,
    this.interval = const Duration(milliseconds: 80),
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: List.generate(
        children.length,
        (i) => _StaggerItem(
          child: children[i],
          delay: Duration(milliseconds: i * interval.inMilliseconds),
        ),
      ),
    );
  }
}

class _StaggerItem extends StatefulWidget {
  final Widget child;
  final Duration delay;

  const _StaggerItem({required this.child, required this.delay});

  @override
  State<_StaggerItem> createState() => _StaggerItemState();
}

class _StaggerItemState extends State<_StaggerItem> {
  bool _visible = false;

  @override
  void initState() {
    super.initState();
    Future.delayed(widget.delay, () {
      if (mounted) setState(() => _visible = true);
    });
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedOpacity(
      duration: const Duration(milliseconds: 300),
      opacity: _visible ? 1 : 0,
      curve: Curves.easeOut,
      child: AnimatedSlide(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
        offset: _visible ? Offset.zero : const Offset(0, 0.2),
        child: widget.child,
      ),
    );
  }
}
