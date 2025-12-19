// Data Models

import 'package:flutter/material.dart';
import 'package:flutter_cas_app_main/src/features/fee_feature/presentation/widgets/responsive_text.dart';

class ScreenHeader extends StatelessWidget {
  final String title;
  final Widget? trailing;
  const ScreenHeader({super.key, required this.title, this.trailing});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        IconButton(
          icon: const Icon(
            Icons.arrow_back,
            color: Color(0xFF6B7280), // Input Icon Color
          ),
          onPressed: () => Navigator.pop(context),
        ),
        Expanded(
          child: ResponsiveText(
            text: title,
            phoneSize: 20,
            tabletSize: 26,
            weight: FontWeight.bold,
            color: const Color(0xFF111827), // Primary Text
          ),
        ),
        if (trailing != null) trailing!,
      ],
    );
  }
}
