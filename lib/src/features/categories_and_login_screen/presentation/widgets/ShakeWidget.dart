// import 'package:flutter/material.dart';

// class ShakeWidget extends StatefulWidget {
//   final Widget child;
//   final bool shouldShake;

//   const ShakeWidget({Key? key, required this.child, required this.shouldShake})
//     : super(key: key);

//   @override
//   _ShakeWidgetState createState() => _ShakeWidgetState();
// }

// class _ShakeWidgetState extends State<ShakeWidget>
//     with SingleTickerProviderStateMixin {
//   late AnimationController _controller;
//   late Animation<double> _animation;

//   @override
//   void initState() {
//     super.initState();
//     _controller = AnimationController(
//       duration: const Duration(milliseconds: 500),
//       vsync: this,
//     );
//     _animation = Tween<double>(
//       begin: 0,
//       end: 10,
//     ).animate(CurvedAnimation(parent: _controller, curve: Curves.elasticIn));
//   }

//   @override
//   void didUpdateWidget(ShakeWidget oldWidget) {
//     super.didUpdateWidget(oldWidget);
//     if (widget.shouldShake && !oldWidget.shouldShake) {
//       _controller.forward().then((_) => _controller.reverse());
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return AnimatedBuilder(
//       animation: _animation,
//       builder: (context, child) {
//         return Transform.translate(
//           offset: Offset(_animation.value, 0),
//           child: widget.child,
//         );
//       },
//     );
//   }

//   @override
//   void dispose() {
//     _controller.dispose();
//     super.dispose();
//   }
// }

import 'package:flutter/widgets.dart';

class ShakeWidget extends StatefulWidget {
  final Widget child;
  final bool shouldShake;

  const ShakeWidget({super.key, required this.child, required this.shouldShake});

  @override
  _ShakeWidgetState createState() => _ShakeWidgetState();
}

class _ShakeWidgetState extends State<ShakeWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );

    _animation = Tween<double>(
      begin: 0,
      end: 1,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.elasticIn));
  }

  @override
  void didUpdateWidget(ShakeWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.shouldShake && !oldWidget.shouldShake) {
      _controller.forward().then((_) => _controller.reverse());
    }
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        double shakeOffset =
            _animation.value *
            8 *
            (1 - _animation.value) *
            (widget.shouldShake
                ? (DateTime.now().millisecondsSinceEpoch % 2 == 0 ? 1 : -1)
                : 0);

        return Transform.translate(
          offset: Offset(shakeOffset, 0),
          child: widget.child,
        );
      },
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
