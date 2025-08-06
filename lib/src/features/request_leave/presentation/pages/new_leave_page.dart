import 'package:flutter_neumorphic_plus/flutter_neumorphic.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../widgets/neumorphic_text_field.dart';

class NewLeavePage extends StatefulWidget {
  const NewLeavePage({super.key});

  @override
  State<NewLeavePage> createState() => _NewLeavePageState();
}

class _NewLeavePageState extends State<NewLeavePage> {
  final TextEditingController causeController = TextEditingController();
  final TextEditingController fromDateController = TextEditingController();
  final TextEditingController toDateController = TextEditingController();
  final TextEditingController detailsController = TextEditingController();

  final FocusNode causeFocus = FocusNode();
  final FocusNode fromFocus = FocusNode();
  final FocusNode toFocus = FocusNode();
  final FocusNode detailsFocus = FocusNode();

  FocusNode? activeFocus;

  @override
  void initState() {
    super.initState();
    for (var node in [causeFocus, fromFocus, toFocus, detailsFocus]) {
      node.addListener(() {
        setState(() {
          if (node.hasFocus) {
            activeFocus = node;
          } else if (activeFocus == node) {
            activeFocus = null;
          }
        });
      });
    }
  }

  @override
  void dispose() {
    causeFocus.dispose();
    fromFocus.dispose();
    toFocus.dispose();
    detailsFocus.dispose();
    super.dispose();
  }

  Future<void> _pickDate(TextEditingController controller) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (picked != null) {
      setState(() {
        controller.text = DateFormat('EEE, dd MMM yyyy').format(picked);
      });
    }
  }

  void _submitForm() {
    if (causeController.text.isNotEmpty && fromDateController.text.isNotEmpty) {
      Navigator.pop(context, {
        'fromDate': fromDateController.text.trim(),
        'cause': causeController.text.trim(),
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please fill in both Cause and From Date'),
        ),
      );
    }
  }

@override
Widget build(BuildContext context) {
  return Scaffold(
    backgroundColor: const Color(0xFFF5F5F5), // ⬅️ Replaces bluish NeumorphicBackground
    body: SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  NeumorphicButton(
                    onPressed: () => Navigator.pop(context),
                    style: NeumorphicStyle(
                      shape: NeumorphicShape.flat,
                      boxShape: const NeumorphicBoxShape.circle(),
                      depth: 4,
                      color: Colors.white,
                    ),
                    padding: const EdgeInsets.all(12),
                    child: const Icon(Icons.arrow_back, color: Colors.black),
                  ),
                  const SizedBox(width: 16),
                  const Text(
                    "New Leave",
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              NeumorphicTextField(
                label: "Cause",
                icon: Icons.edit,
                controller: causeController,
                focusNode: causeFocus,
                isFocused: activeFocus == causeFocus,
              ),
              NeumorphicTextField(
                label: "From Date",
                icon: Icons.date_range,
                controller: fromDateController,
                focusNode: fromFocus,
                readOnly: true,
                onTap: () => _pickDate(fromDateController),
                isFocused: activeFocus == fromFocus,
              ),
              NeumorphicTextField(
                label: "To Date",
                icon: Icons.date_range,
                controller: toDateController,
                focusNode: toFocus,
                readOnly: true,
                onTap: () => _pickDate(toDateController),
                isFocused: activeFocus == toFocus,
              ),
              NeumorphicTextField(
                label: "Details",
                controller: detailsController,
                focusNode: detailsFocus,
                maxLines: 10,
                isFocused: activeFocus == detailsFocus,
              ),
              const SizedBox(height: 20),
              NeumorphicButton(
                onPressed: _submitForm,
                style: NeumorphicStyle(
                  color: Colors.blue, // ⬅️ Changed from blue
                  boxShape: NeumorphicBoxShape.roundRect(
                    BorderRadius.circular(16),
                  ),
                  depth: 4,
                ),
                padding: const EdgeInsets.symmetric(vertical: 14),
                child: const Center(
                  child: Text(
                    'Apply for Leave',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    ),
  );
}
}