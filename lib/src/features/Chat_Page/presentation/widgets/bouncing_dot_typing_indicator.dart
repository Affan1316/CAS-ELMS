import 'package:flutter/material.dart';
class LogoColors {
  static const Color first = Color.fromARGB(220, 89, 97, 128);
  static const Color sec = Color.fromARGB(206, 42, 142, 181);
  static const Color third = Color(0xff6C4E6A);
}

class BouncingDotsTypingIndicator extends StatefulWidget {
  const BouncingDotsTypingIndicator({
    super.key,
    this.dotColors = const [LogoColors.first, LogoColors.sec, LogoColors.third],
  }) : assert(dotColors.length == 3, "3 colors are requried only");

  final List<Color> dotColors;

  @override
  State<BouncingDotsTypingIndicator> createState() =>
      _BouncingDotsTypingIndicatorState();
}

class _BouncingDotsTypingIndicatorState
    extends State<BouncingDotsTypingIndicator>
    with TickerProviderStateMixin {
  late final List<AnimationController> _controllers;
  late final List<Animation<double>> _animations;

  @override
  void initState() {
    super.initState();

    _controllers = List.generate(
      3,
      (i) => AnimationController(
        vsync: this,
        duration: const Duration(milliseconds: 400),
      ),
    );

    _animations = _controllers.map((controller) {
      return Tween<double>(
        begin: 0.0,
        end: -6.0,
      ).animate(CurvedAnimation(parent: controller, curve: Curves.easeInOut));
    }).toList();

    // Stagger animation
    for (int i = 0; i < _controllers.length; i++) {
      Future.delayed(Duration(milliseconds: i * 150), () {
        _controllers[i].repeat(reverse: true);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: List.generate(3, (i) {
          return AnimatedBuilder(
            animation: _animations[i],
            builder: (context, child) {
              return Transform.translate(
                offset: Offset(0, _animations[i].value),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 2),
                  child: Dot(color: widget.dotColors[i]),
                ),
              );
            },
          );
        }),
      ),
    );
  }

  @override
  void dispose() {
    for (final controller in _controllers) {
      controller.dispose();
    }
    super.dispose();
  }
}

class Dot extends StatelessWidget {
  const Dot({super.key, required this.color});

  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 8,
      height: 8,
      decoration: BoxDecoration(color: color, shape: BoxShape.circle),
    );
  }
}
