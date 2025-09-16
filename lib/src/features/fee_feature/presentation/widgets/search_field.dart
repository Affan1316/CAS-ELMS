// Data Models

import 'package:flutter/material.dart';
import 'package:flutter_cas_app_main/src/features/fee_feature/presentation/widgets/neu_card.dart';

class SearchField extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  // final ValueChanged<String> onChanged;

  const SearchField({
    super.key,
    required this.controller,
    required this.hintText,
    // required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return NeuCard(
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          hintText: hintText,
          border: InputBorder.none,
          prefixIcon: const Icon(Icons.search, color: Color(0xFF3E206D)),
          suffixIcon: IconButton(
            icon: const Icon(Icons.clear, color: Color(0xFF3E206D)),
            onPressed: () {
              controller.clear();
              // onChanged('');
            },
          ),
        ),
        // onChanged: onChanged,
      ),
    );
  }
}
