import 'package:flutter_neumorphic_plus/flutter_neumorphic.dart';

class InputField extends StatelessWidget {
  const InputField({
    super.key,
    required this.hint,
    required this.controller,
    this.readOnly = false,
  });
  final String hint;
  final TextEditingController controller;
  final bool readOnly;

  @override
  Widget build(BuildContext context) {
    return Neumorphic(
      style: NeumorphicStyle(
        depth: -4,
        boxShape: NeumorphicBoxShape.roundRect(BorderRadius.circular(10)),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: TextField(
        controller: controller,
        readOnly: readOnly,
        keyboardType: TextInputType.number,
        decoration: InputDecoration(border: InputBorder.none, hintText: hint),
      ),
    );
  }
}
