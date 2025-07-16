import 'package:flutter/material.dart';

class SlideInWidget extends StatefulWidget {
  final Widget child;
  final Duration delay;
  final Offset begin;

  const SlideInWidget({
    Key? key,
    required this.child,
    this.delay = Duration.zero,
    this.begin = const Offset(0, 1),
  }) : super(key: key);

  @override
  _SlideInWidgetState createState() => _SlideInWidgetState();
}

class _SlideInWidgetState extends State<SlideInWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _slideAnimation = Tween<Offset>(
      begin: widget.begin,
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic));

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));

    Future.delayed(widget.delay, () {
      if (mounted) {
        _controller.forward();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return SlideTransition(
      position: _slideAnimation,
      child: FadeTransition(opacity: _fadeAnimation, child: widget.child),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
