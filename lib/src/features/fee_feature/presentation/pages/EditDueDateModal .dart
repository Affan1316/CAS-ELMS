import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class EditDueDateModal extends StatefulWidget {
  final DateTime currentDueDate;
  final Function(DateTime newDueDate) onUpdate;

  const EditDueDateModal({
    super.key,
    required this.currentDueDate,
    required this.onUpdate,
  });

  @override
  State<EditDueDateModal> createState() => _EditDueDateModalState();
}

class _EditDueDateModalState extends State<EditDueDateModal> {
  late DateTime selectedDate;

  @override
  void initState() {
    super.initState();
    selectedDate = widget.currentDueDate;
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: const Color(0xFF3B82F6),
              onPrimary: Colors.white,
              onSurface: Colors.black,
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
      });
    }
  }

  void _handleSubmit() {
    Navigator.of(context).pop();
    widget.onUpdate(selectedDate);
  }

  @override
  Widget build(BuildContext context) {
    final dateFormat = DateFormat('EEEE, MMM dd, yyyy');

    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      title: Row(
        children: [
          Icon(Icons.calendar_today, color: const Color(0xFF3B82F6)),
          const SizedBox(width: 12),
          const Text(
            'Edit Due Date',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
          ),
        ],
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Current Due Date:',
            style: TextStyle(
              fontSize: 14,
              color: Colors.black54,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.grey.shade100,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.grey.shade300),
            ),
            child: Row(
              children: [
                Icon(Icons.event, color: Colors.grey.shade600, size: 20),
                const SizedBox(width: 8),
                Text(
                  dateFormat.format(widget.currentDueDate),
                  style: const TextStyle(fontSize: 14, color: Colors.black87),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          const Text(
            'New Due Date:',
            style: TextStyle(
              fontSize: 14,
              color: Colors.black54,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 8),
          InkWell(
            onTap: () => _selectDate(context),
            borderRadius: BorderRadius.circular(8),
            child: Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: const Color(0xFF3B82F6).withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: const Color(0xFF3B82F6)),
              ),
              child: Row(
                children: [
                  const Icon(
                    Icons.calendar_month,
                    color: Color(0xFF3B82F6),
                    size: 20,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      dateFormat.format(selectedDate),
                      style: const TextStyle(
                        fontSize: 14,
                        color: Color(0xFF3B82F6),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const Icon(
                    Icons.edit_calendar,
                    color: Color(0xFF3B82F6),
                    size: 20,
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.blue.shade50,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.blue.shade200),
            ),
            child: Row(
              children: [
                Icon(Icons.info_outline, color: Colors.blue.shade700, size: 20),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'Tap the date above to select a new due date from the calendar.',
                    style: TextStyle(fontSize: 12, color: Colors.blue.shade900),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: _handleSubmit,
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF3B82F6),
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          child: const Text(
            'Update Date',
            style: TextStyle(color: Colors.white),
          ),
        ),
      ],
    );
  }
}
