import 'package:flutter_neumorphic_plus/flutter_neumorphic.dart';
import 'package:animate_do/animate_do.dart';
import 'package:flutter_cas_app_main/src/core/theme/app_colors.dart'; // Import AppColors

class LeaveHeader extends StatefulWidget {
  final double height;
  final double horizontalPadding;
  final VoidCallback onBackPressed;
  final Function(String)? onSearchChanged;

  const LeaveHeader({
    super.key,
    required this.height,
    required this.horizontalPadding,
    required this.onBackPressed,
    this.onSearchChanged,
  });

  @override
  State<LeaveHeader> createState() => _LeaveHeaderState();
}

class _LeaveHeaderState extends State<LeaveHeader> {
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final titleFontSize = size.width * 0.07;
    final searchFontSize = size.width * 0.04;
    final iconSize = size.width * 0.065;
    final backButtonPadding = size.width * 0.04;

    return Container(
      color: Colors.white,
      child: SafeArea(
        child: Column(
          children: [
            // Enhanced Header Section
            Container(
              margin: EdgeInsets.symmetric(
                horizontal: widget.horizontalPadding * 0.8,
                vertical: size.height * 0.02,
              ),
              child: Neumorphic(
                style: NeumorphicStyle(
                  depth: 8,
                  intensity: 0.65,
                  boxShape: NeumorphicBoxShape.roundRect(
                    BorderRadius.circular(size.width * 0.06),
                  ),
                  color: Colors.white,
                ),
                child: Container(
                  padding: EdgeInsets.only(
                    left: widget.horizontalPadding * 0.4,
                    right: widget.horizontalPadding * 1.2,
                    top: size.height * 0.025,
                    bottom: size.height * 0.025,
                  ),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(size.width * 0.06),
                    color: Colors.white,
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      FadeInDown(
                        delay: const Duration(milliseconds: 300),
                        child: NeumorphicButton(
                          onPressed: widget.onBackPressed,
                          style: NeumorphicStyle(
                            boxShape: const NeumorphicBoxShape.circle(),
                            depth: 6,
                            intensity: 0.8,
                            shape: NeumorphicShape.flat,
                            color: Colors.white,
                          ),
                          padding: EdgeInsets.all(backButtonPadding),
                          child: Icon(
                            Icons.arrow_back_ios_new,
                            size: iconSize,
                            color: Colors.black87,
                          ),
                        ),
                      ),
                      SizedBox(width: size.width * 0.04),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            FadeInDown(
                              delay: const Duration(milliseconds: 400),
                              child: Row(
                                children: [
                                  Container(
                                    width: size.width * 0.01,
                                    height: titleFontSize * 0.65,
                                    decoration: BoxDecoration(
                                      gradient: LinearGradient(
                                        begin: Alignment.topCenter,
                                        end: Alignment.bottomCenter,
                                        colors: [
                                          AppColors.primary,      // Using AppColors
                                          AppColors.primaryDark,  // Using AppColors
                                        ],
                                      ),
                                      borderRadius: BorderRadius.circular(size.width * 0.01),
                                    ),
                                  ),
                                  SizedBox(width: size.width * 0.025),
                                  Text(
                                    'Manage',
                                    style: TextStyle(
                                      fontSize: titleFontSize * 0.5,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.black54,
                                      letterSpacing: 0.5,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(height: size.height * 0.008),
                            FadeInDown(
                              delay: const Duration(milliseconds: 500),
                              child: ShaderMask(
                                shaderCallback: (bounds) => LinearGradient(
                                  colors: [
                                    AppColors.primary,      // Using AppColors
                                    AppColors.primaryDark,  // Using AppColors
                                  ],
                                ).createShader(bounds),
                                child: Text(
                                  'Leave Requests',
                                  style: TextStyle(
                                    fontSize: titleFontSize * 1.1,
                                    fontWeight: FontWeight.w900,
                                    color: Colors.white,
                                    letterSpacing: -0.5,
                                    height: 1.1,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            SizedBox(height: size.height * 0.02),

            // Search Bar
            if (widget.onSearchChanged != null)
              FadeInDown(
                delay: const Duration(milliseconds: 400),
                child: Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: widget.horizontalPadding,
                    vertical: size.height * 0.01,
                  ),
                  child: Neumorphic(
                    style: NeumorphicStyle(
                      depth: -4,
                      intensity: 0.8,
                      boxShape: NeumorphicBoxShape.roundRect(
                        BorderRadius.circular(size.width * 0.075),
                      ),
                      color: Colors.white,
                    ),
                    child: Material(
                      color: Colors.transparent,
                      child: TextField(
                        style: TextStyle(
                          color: Colors.black87,
                          fontSize: searchFontSize,
                        ),
                        decoration: InputDecoration(
                          hintText: 'Search leave requests...',
                          hintStyle: TextStyle(
                            color: Colors.black54,
                            fontSize: searchFontSize,
                          ),
                          prefixIcon: Icon(
                            Icons.search,
                            color: Colors.black54,
                            size: iconSize,
                          ),
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.symmetric(
                            vertical: size.height * 0.017,
                          ),
                        ),
                        onChanged: widget.onSearchChanged,
                      ),
                    ),
                  ),
                ),
              ),

            SizedBox(height: size.height * 0.02),
          ],
        ),
      ),
    );
  }
}