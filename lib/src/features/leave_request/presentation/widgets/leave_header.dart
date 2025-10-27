import 'package:flutter_neumorphic_plus/flutter_neumorphic.dart';

class LeaveHeader extends StatelessWidget {
  final double height;
  final double horizontalPadding;
  final VoidCallback onBackPressed;

  const LeaveHeader({
    super.key,
    required this.height,
    required this.horizontalPadding,
    required this.onBackPressed,
  });

  double _getResponsiveFontSize(double screenWidth, double mobile, double tablet) {
    if (screenWidth >= 768) return tablet;
    return mobile;
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isTablet = screenWidth >= 768;

    return Container(
      height: height,
      width: double.infinity,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFF6366F1),
            Color(0xFF8B5CF6),
          ],
        ),
      ),
      child: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(horizontalPadding),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  NeumorphicButton(
                    onPressed: onBackPressed,
                    style: NeumorphicStyle(
                      shape: NeumorphicShape.flat,
                      boxShape: const NeumorphicBoxShape.circle(),
                      depth: 2,
                      color: Colors.white.withOpacity(0.2),
                    ),
                    padding: EdgeInsets.all(isTablet ? 16 : 12),
                    child: Icon(
                      Icons.arrow_back_rounded,
                      color: Colors.white,
                      size: isTablet ? 24 : 20,
                    ),
                  ),
                  Expanded(
                    child: Padding(
                      padding: EdgeInsets.only(
                        left: isTablet ? 20 : 16,
                        right: isTablet ? 20 : 16,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Leave Requests',
                            style: TextStyle(
                              fontSize: _getResponsiveFontSize(screenWidth, 28, 32),
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                              letterSpacing: -0.5,
                            ),
                          ),
                          SizedBox(height: isTablet ? 8 : 4),
                          Text(
                            'Track and manage your time off',
                            style: TextStyle(
                              fontSize: _getResponsiveFontSize(screenWidth, 16, 18),
                              color: Colors.white70,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}