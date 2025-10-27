import 'package:flutter_neumorphic_plus/flutter_neumorphic.dart';

class LeaveFormField extends StatelessWidget {
  final String label;
  final IconData icon;
  final TextEditingController controller;
  final FocusNode focusNode;
  final FocusNode? activeFocus;
  final bool readOnly;
  final VoidCallback? onTap;
  final int maxLines;
  final String? hint;

  const LeaveFormField({
    super.key,
    required this.label,
    required this.icon,
    required this.controller,
    required this.focusNode,
    required this.activeFocus,
    this.readOnly = false,
    this.onTap,
    this.maxLines = 1,
    this.hint,
  });

  double _getResponsiveFontSize(double screenWidth, double mobile, double tablet) {
    if (screenWidth >= 768) return tablet;
    return mobile;
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isTablet = screenWidth >= 768;
    final bool isFocused = activeFocus == focusNode;
    
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Label
          Padding(
            padding: EdgeInsets.only(
              left: isTablet ? 6 : 4,
              bottom: isTablet ? 12 : 8,
            ),
            child: Text(
              label,
              style: TextStyle(
                fontSize: _getResponsiveFontSize(screenWidth, 14, 16),
                fontWeight: FontWeight.w600,
                color: isFocused ? const Color(0xFF6366F1) : const Color(0xFF8E8E93),
              ),
            ),
          ),
          
          // Input Field
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(isTablet ? 20 : 16),
              boxShadow: [
                if (isFocused)
                  BoxShadow(
                    color: const Color(0xFF6366F1).withOpacity(0.15),
                    blurRadius: isTablet ? 16 : 12,
                    offset: const Offset(0, 4),
                  ),
              ],
            ),
            child: Neumorphic(
              style: NeumorphicStyle(
                depth: isFocused ? -2 : 2,
                intensity: 0.8,
                surfaceIntensity: 0.1,
                boxShape: NeumorphicBoxShape.roundRect(
                  BorderRadius.circular(isTablet ? 20 : 16),
                ),
                color: isFocused ? Colors.white : const Color(0xFFF8F9FA),
                lightSource: LightSource.topLeft,
              ),
              child: Container(
                padding: EdgeInsets.symmetric(
                  horizontal: isTablet ? 20 : 16,
                  vertical: isTablet ? 6 : 4,
                ),
                child: Row(
                  children: [
                    Container(
                      padding: EdgeInsets.all(isTablet ? 12 : 8),
                      decoration: BoxDecoration(
                        color: isFocused 
                            ? const Color(0xFF6366F1).withOpacity(0.1)
                            : Colors.grey.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(isTablet ? 12 : 8),
                      ),
                      child: Icon(
                        icon,
                        size: isTablet ? 24 : 20,
                        color: isFocused 
                            ? const Color(0xFF6366F1)
                            : Colors.grey.shade600,
                      ),
                    ),
                    
                    SizedBox(width: isTablet ? 16 : 12),
                    
                    Expanded(
                      child: TextField(
                        controller: controller,
                        focusNode: focusNode,
                        readOnly: readOnly,
                        onTap: onTap,
                        maxLines: maxLines,
                        style: TextStyle(
                          fontSize: _getResponsiveFontSize(screenWidth, 16, 18),
                          fontWeight: FontWeight.w500,
                          color: const Color(0xFF1C1C1E),
                          height: maxLines > 1 ? 1.4 : 1.2,
                        ),
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: hint,
                          hintStyle: TextStyle(
                            color: Colors.grey.shade500,
                            fontSize: _getResponsiveFontSize(screenWidth, 15, 17),
                            fontWeight: FontWeight.w400,
                          ),
                          contentPadding: EdgeInsets.symmetric(
                            vertical: isTablet ? 16 : 12,
                          ),
                        ),
                        cursorColor: const Color(0xFF6366F1),
                        cursorWidth: 2,
                      ),
                    ),
                    
                    if (readOnly && onTap != null)
                      Container(
                        padding: EdgeInsets.all(isTablet ? 6 : 4),
                        child: Icon(
                          Icons.keyboard_arrow_down_rounded,
                          color: Colors.grey.shade500,
                          size: isTablet ? 24 : 20,
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}