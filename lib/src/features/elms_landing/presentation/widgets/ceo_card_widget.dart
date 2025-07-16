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
    final cardHeight = height * 0.22;
    final imageSizeWidth = width * 0.37;
    final imageSizeHeight = height * 0.22;

    return OrientationBuilder(
      builder: (context, orientation) {
        final isPortrait = orientation == Orientation.portrait;
        var position = isPortrait ? -imageSizeWidth * 0.2 : -imageSizeWidth * 0.05;
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
                  // Card Background
                  Container(
                    width: cardWidth,
                    height: cardHeight,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          Color(0xFF0E96C5), // Primary blue
                          Color(0xFF39B3D7), // Lighter blue/teal
                          Color(0xFF82D8E8), // Soft aqua
                        ],
                      ),
                      borderRadius: BorderRadius.circular(20),
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
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              FittedBox(
                                child: Text(
                                  "Noman Ameer Khan",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 20,
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
                                    fontSize: 16,
                                    height: 1.3,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 8),
                              FittedBox(
                                child: Text(
                                  "Empowering tech learners through innovation driven education",
                                  style: TextStyle(
                                    color: Colors.white.withOpacity(0.9),
                                    height: 1.3,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        // Spacer for image
                        Expanded(flex: 4, child: SizedBox()),
                      ],
                    ),
                  ),

                  Positioned(
                    top: position, // Pop out from top
                    right: 0,
                    child: Image.asset(
                      'assets/images/person 1-Photoroom.png', // your PNG path
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
