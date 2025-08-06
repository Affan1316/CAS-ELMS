import 'package:flutter_neumorphic_plus/flutter_neumorphic.dart';
import 'package:flutter/material.dart';

class NeumorphicTextField extends StatelessWidget {
  final String label;
  final IconData? icon;
  final TextEditingController controller;
  final FocusNode focusNode;
  final bool readOnly;
  final VoidCallback? onTap;
  final int maxLines;
  final bool isFocused;

  const NeumorphicTextField({
    super.key,
    required this.label,
    this.icon,
    required this.controller,
    required this.focusNode,
    this.readOnly = false,
    this.onTap,
    this.maxLines = 1,
    required this.isFocused,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      curve: Curves.easeInOut,
      margin: const EdgeInsets.symmetric(vertical: 10),
      child: Neumorphic(
        style: NeumorphicStyle(
          depth: isFocused ? 6 : -3,
          boxShape: NeumorphicBoxShape.roundRect(BorderRadius.circular(12)),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
        child: TextField(
          controller: controller,
          focusNode: focusNode,
          readOnly: readOnly,
          onTap: onTap,
          maxLines: maxLines,
          decoration: InputDecoration(
            icon: icon != null ? Icon(icon, color: Colors.deepPurple) : null,
            labelText: label,
            border: InputBorder.none,
          ),
        ),
      ),
    );
  }
}
