import 'package:flutter_neumorphic_plus/flutter_neumorphic.dart';
import 'package:animate_do/animate_do.dart';
import 'package:flutter_cas_app_main/src/core/theme/app_colors.dart'; // Import AppColors

class MyAppbar extends StatelessWidget {
  const MyAppbar({
    super.key, 
    this.onTap, 
    required this.studentName,
    this.showSearchBar = false,
    this.onSearchChanged,
  });
  
  final VoidCallback? onTap;
  final String studentName;
  final bool showSearchBar;
  final ValueChanged<String>? onSearchChanged;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final horizontalPadding = size.width * 0.05;
    final titleFontSize = size.width * 0.07;
    final iconSize = size.width * 0.065;
    final backButtonPadding = size.width * 0.04;

    return Column(
      children: [
        // Enhanced Header Section
        Container(
          margin: EdgeInsets.symmetric(
            horizontal: horizontalPadding * 0.8,
            vertical: size.height * 0.02,
          ),
          child: Neumorphic(
            style: NeumorphicStyle(
              depth: 8,
              intensity: 0.65,
              boxShape: NeumorphicBoxShape.roundRect(
                BorderRadius.circular(size.width * 0.06),
              ),
              color: const Color(0xFFE6E9EF),
            ),
            child: Container(
              padding: EdgeInsets.symmetric(
                horizontal: horizontalPadding * 1.2,
                vertical: size.height * 0.025,
              ),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(size.width * 0.06),
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    const Color(0xFFE6E9EF).withOpacity(0.9),
                    const Color(0xFFD8DCE5).withOpacity(0.8),
                  ],
                ),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  FadeInDown(
                    delay: const Duration(milliseconds: 300),
                    child: NeumorphicButton(
                      onPressed: onTap ?? () {
                        Navigator.of(context).maybePop();
                      },
                      style: NeumorphicStyle(
                        boxShape: const NeumorphicBoxShape.circle(),
                        depth: 6,
                        intensity: 0.8,
                        shape: NeumorphicShape.flat,
                        color: const Color(0xFFE6E9EF),
                      ),
                      padding: EdgeInsets.all(backButtonPadding),
                      child: Icon(
                        Icons.arrow_back_ios_new,
                        size: iconSize,
                        color: const Color(0xFF3D4C5F),
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
                                  color: AppColors.primaryDark, // Using AppColors
                                  borderRadius: BorderRadius.circular(size.width * 0.01),
                                ),
                              ),
                              SizedBox(width: size.width * 0.025),
                              Text(
                                studentName,
                                style: TextStyle(
                                  fontSize: titleFontSize * 0.5,
                                  fontWeight: FontWeight.w600,
                                  color: const Color(0xFF3D4C5F).withOpacity(0.7),
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
                              'Workshop Time',
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

        // Optional Search Bar
        if (showSearchBar) ...[
          SizedBox(height: size.height * 0.02),
          FadeInDown(
            delay: const Duration(milliseconds: 400),
            child: Padding(
              padding: EdgeInsets.symmetric(
                horizontal: horizontalPadding,
                vertical: size.height * 0.01,
              ),
              child: Neumorphic(
                style: NeumorphicStyle(
                  depth: -4,
                  intensity: 0.8,
                  boxShape: NeumorphicBoxShape.roundRect(
                    BorderRadius.circular(size.width * 0.075),
                  ),
                  color: const Color(0xFFE6E9EF),
                ),
                child: Material(
                  color: Colors.transparent,
                  child: TextField(
                    style: TextStyle(
                      color: const Color(0xFF3D4C5F),
                      fontSize: size.width * 0.04,
                    ),
                    decoration: InputDecoration(
                      hintText: 'Search...',
                      hintStyle: TextStyle(
                        color: const Color(0xFF3D4C5F).withOpacity(0.5),
                        fontSize: size.width * 0.04,
                      ),
                      prefixIcon: Icon(
                        Icons.search,
                        color: const Color(0xFF3D4C5F).withOpacity(0.5),
                        size: iconSize,
                      ),
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.symmetric(
                        vertical: size.height * 0.017,
                      ),
                    ),
                    onChanged: onSearchChanged,
                  ),
                ),
              ),
            ),
          ),
        ],
      ],
    );
  }
}