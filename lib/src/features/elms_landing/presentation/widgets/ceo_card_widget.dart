// unchanged imports
import 'package:flutter/material.dart';

class CeoCardWidget extends AnimatedWidget {
  final AnimationController animationController;
  final double width;
  final double height;

  const CeoCardWidget({
    super.key,
    required this.height,
    required this.width,
    required this.animationController,
    required Animation<Offset> anime,
  }) : super(listenable: anime);

  Animation<Offset> get _animation => listenable as Animation<Offset>;

  @override
  Widget build(BuildContext context) {
    final cardWidth = width * 0.9;
    final cardHeight = height * 0.19;
    final imageSizeWidth = width * 0.37;
    final imageSizeHeight = height * 0.22;

    return OrientationBuilder(
      builder: (context, orientation) {
        final isPortrait = orientation == Orientation.portrait;
        var position =
            isPortrait ? -imageSizeWidth * 0.2 : -imageSizeWidth * 0.05;

        return FadeTransition(
          opacity: animationController.drive(
            CurveTween(curve: Interval(0.0, 0.25)),
          ),
          child: SlideTransition(
            position: _animation,
            child: Center(
              child: Stack(
                clipBehavior: Clip.none,
                children: [
                  // Card with gradient and neumorphic shadows
                  Container(
                    width: cardWidth,
                    height: cardHeight,
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          Color(0xFF0E96C5),
                          Color(0xFF39B3D7),
                          Color(0xFF82D8E8),
                        ],
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
                    padding: EdgeInsets.symmetric(
                      horizontal: cardWidth * 0.05,
                      vertical: cardHeight * 0.15,
                    ),
                    child: Row(
                      children: [
                        // Text Section
                        Expanded(
                          flex: 6,
                          child: SizedBox(
                            width: cardWidth * 0.7,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                FittedBox(
                                  child: Text(
                                    "Noman Ameer Khan",
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 30,
                                      fontWeight: FontWeight.bold,
                                      height: 1.3,
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 8),
                                FittedBox(
                                  child: Text(
                                    "CEO - Center for Advanced Solutions",
                                    style: TextStyle(
                                      color: Colors.white.withOpacity(0.9),
                                      fontSize: 25,
                                      height: 1.3,
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 8),
                                FittedBox(
                                  child: Text(
                                    "Empowering tech learners through innovation \ndriven education",
                                    style: TextStyle(
                                      color: Colors.white.withOpacity(0.9),
                                      fontSize: 20,
                                      height: 1.3,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        const Expanded(flex: 4, child: SizedBox()),
                      ],
                    ),
                  ),

                  // CEO Image
                  Positioned(
                    top: position,
                    right: 8,
                    child: Image.asset(
                      'assets/images/sir.png',
                      width: imageSizeWidth,
                      height: imageSizeHeight,
                      fit: BoxFit.cover,
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
