import 'package:flutter/material.dart';

class LoginButton extends AnimatedWidget {
  final VoidCallback onTap;
  final AnimationController animationController;
  final double width;
  const LoginButton({
    super.key,
    required this.width,
    required this.onTap,
    required this.animationController,
    required Animation<Offset> anime,
  }) : super(listenable: anime);
  Animation<Offset> get _animation => listenable as Animation<Offset>;
  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: animationController.drive(
        CurveTween(curve: Interval(0.75, 1.0)),
      ),
      child: SlideTransition(
        position: _animation,
        child: GestureDetector(
          onTap: onTap,
          child: Container(
            width: width * 0.8,
            height: 50,
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [
                  Color(0xFF0E96C5), // Primary color
                  Color(0xFF39B3D7), // Light teal blend
                  Color(0xFF82D8E8), // Soft aqua
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(20),
              boxShadow: const [
                BoxShadow(
                  color: Colors.black12,
                  offset: Offset(4, 4),
                  blurRadius: 8,
                ),
                BoxShadow(
                  color: Colors.white24,
                  offset: Offset(-4, -4),
                  blurRadius: 8,
                ),
              ],
            ),
            alignment: Alignment.center,
            child: const Text(
              'Login',
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.w600,
                letterSpacing: 1.1,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
