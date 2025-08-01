import 'package:flutter/material.dart';

class GenderSelection extends StatelessWidget {
  final String? gender;
  final void Function(String?) onChanged;

  const GenderSelection({
    super.key,
    required this.gender,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: RadioListTile<String>(
            title: const Text('Male'),
            value: 'Male',
            groupValue: gender,
            onChanged: onChanged,
          ),
        ),
        Expanded(
          child: RadioListTile<String>(
            title: const Text('Female'),
            value: 'Female',
            groupValue: gender,
            onChanged: onChanged,
          ),
        ),
      ],
    );
  }
}
