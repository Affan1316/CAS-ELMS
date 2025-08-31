// import 'package:flutter/material.dart';
// import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_cas_app_main/src/features/group/data/repositories/group_repository_implementation.dart';
import 'package:flutter_cas_app_main/src/features/group/domain/entities/group_entity.dart';
import 'package:flutter_cas_app_main/src/features/group/domain/usecases/update_group_usecase.dart';
import 'package:flutter_cas_app_main/src/features/group/presentation/bloc/group_bloc.dart';
import 'package:flutter_cas_app_main/src/features/group/presentation/bloc/group_events.dart';
import 'package:intl/intl.dart';

class UpdateGroupScreen extends StatefulWidget {
  final GroupEntity groupEntity;
  const UpdateGroupScreen({super.key, required this.groupEntity});

  @override
  State<UpdateGroupScreen> createState() => _UpdateGroupScreenState();
}

class _UpdateGroupScreenState extends State<UpdateGroupScreen> {
  // Form controllers
  final TextEditingController _courseNameController = TextEditingController();
  final TextEditingController _durationController = TextEditingController();
  final TextEditingController _feeController = TextEditingController();

  DateTime? _selectedDate;
  TimeOfDay? _startTime;
  TimeOfDay? _endTime;

  // Form validation key
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _courseNameController.text = widget.groupEntity.courseName;
    _durationController.text = widget.groupEntity.enterDuration;
    _feeController.text = widget.groupEntity.enterFee;
    _startTime = const TimeOfDay(hour: 17, minute: 18);
    _endTime = const TimeOfDay(hour: 19, minute: 18);
    _selectedDate = DateTime.now();
  }

  @override
  void dispose() {
    _courseNameController.dispose();
    _durationController.dispose();
    _feeController.dispose();
    super.dispose();
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: ThemeData.light().copyWith(
            primaryColor: const Color(0xFF4A6FA5),
            colorScheme: const ColorScheme.light(primary: Color(0xFF4A6FA5)),
          ),
          child: child!,
        );
      },
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }


  void _updateGroup() {
    if (_formKey.currentState!.validate()) {
      _showSuccessMessage();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Update Group'),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Header section with subtle neomorphic design
            _buildHeaderSection(),

            // Form section
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildTextField(
                      controller: _courseNameController,
                      label: "Course Name",
                      icon: Icons.book,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter a course name';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 20),
                    _buildTextField(
                      controller: _durationController,
                      label: "Duration (Months)",
                      icon: Icons.calendar_month,
                      keyboardType: TextInputType.number,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter duration';
                        }
                        // if (int.tryParse(value) == null) {
                        //   return 'Please enter a valid number';
                        // }
                        return null;
                      },
                    ),
                    const SizedBox(height: 20),
                    _buildTextField(
                      controller: _feeController,
                      label: "Fee",
                      icon: Icons.currency_rupee,
                      keyboardType: TextInputType.numberWithOptions(
                        decimal: true,
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter fee amount';
                        }
                        if (double.tryParse(value) == null) {
                          return 'Please enter a valid amount';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 20),

                    // Date picker
                    _buildDatePicker(),
                    
                    const SizedBox(height: 40),

                    // Update button
                    _buildUpdateButton(context),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeaderSection() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 30),
      decoration: const BoxDecoration(color: Color(0xFFF5F7FA)),
      child: Column(
        children: [
          // Subtle neomorphic illustration container
          Container(
            height: 120,
            width: 120,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(60),
              boxShadow: [
                BoxShadow(
                  offset: const Offset(2, 2),
                  blurRadius: 8,
                  spreadRadius: 1,
                  color: Colors.grey.withOpacity(0.2),
                ),
                const BoxShadow(
                  offset: Offset(-2, -2),
                  blurRadius: 8,
                  spreadRadius: 1,
                  color: Colors.white,
                ),
              ],
            ),
            child: const Icon(Icons.groups, size: 60, color: Color(0xFF4A6FA5)),
          ),
          const SizedBox(height: 20),
          const Text(
            "Group Information",
            style: TextStyle(
              color: Color(0xFF4A6FA5),
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    TextInputType? keyboardType,
    String? Function(String?)? validator,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            offset: const Offset(2, 2),
            blurRadius: 6,
            spreadRadius: 1,
            color: Colors.grey.withOpacity(0.15),
          ),
          const BoxShadow(
            offset: Offset(-2, -2),
            blurRadius: 6,
            spreadRadius: 1,
            color: Colors.white,
          ),
        ],
      ),
      child: TextFormField(
        controller: controller,
        keyboardType: keyboardType,
        validator: validator,
        decoration: InputDecoration(
          labelText: label,
          prefixIcon: Icon(icon, color: const Color(0xFF4A6FA5)),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 15,
            vertical: 15,
          ),
        ),
      ),
    );
  }

  Widget _buildDatePicker() {
    return InkWell(
      onTap: () => _selectDate(context),
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              offset: const Offset(2, 2),
              blurRadius: 6,
              spreadRadius: 1,
              color: Colors.grey.withOpacity(0.15),
            ),
            const BoxShadow(
              offset: Offset(-2, -2),
              blurRadius: 6,
              spreadRadius: 1,
              color: Colors.white,
            ),
          ],
        ),
        child: Row(
          children: [
            const Icon(Icons.calendar_today, color: Color(0xFF4A6FA5)),
            const SizedBox(width: 15),
            Expanded(
              child: Text(
                _selectedDate == null
                    ? "Select Date"
                    : DateFormat('yyyy-MM-dd').format(_selectedDate!),
                style: TextStyle(
                  fontSize: 16,
                  color:
                      _selectedDate == null
                          ? Colors.grey.shade500
                          : const Color(0xFF4A6FA5),
                ),
              ),
            ),
            const Icon(Icons.arrow_drop_down, color: Color(0xFF4A6FA5)),
          ],
        ),
      ),
    );
  }


  Widget _buildUpdateButton(BuildContext context) {
    return InkWell(
      onTap: () {
        if (_formKey.currentState!.validate()) {
          context.read<AddGroupBloc>().add(
            UpdateGroupEvent(
              groupId: widget.groupEntity.groupName,
              groupEntity: GroupEntity(
                courseName: _courseNameController.text.toString(),
                enterDate: _selectedDate.toString(),
                enterDuration: _durationController.text.toString(),
                enterFee: _feeController.text.toString(),
                groupName: widget.groupEntity.groupName,
              ),
            ),
          );
          _showSuccessMessage();
        }
      },
      borderRadius: BorderRadius.circular(12),
      child: Container(
        width: double.infinity,
        height: 55,
        decoration: BoxDecoration(
          color: const Color(0xFF4A6FA5),
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              offset: const Offset(0, 4),
              blurRadius: 8,
              spreadRadius: 0,
              color: Colors.black.withOpacity(0.2),
            ),
          ],
        ),
        child: const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Update",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            SizedBox(width: 10),
            Icon(Icons.arrow_forward, color: Colors.white),
          ],
        ),
      ),
    );
  }

  void _showSuccessMessage() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('Group updated successfully!'),
        backgroundColor: const Color(0xFF4A6FA5),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }
}
















































//Widget _buildTimeRangePicker() {
  //   return Row(
  //     children: [
  //       Expanded(
  //         child: InkWell(
  //           onTap: () => _selectStartTime(context),
  //           borderRadius: BorderRadius.circular(12),
  //           child: Container(
  //             padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
  //             decoration: BoxDecoration(
  //               color: Colors.white,
  //               borderRadius: BorderRadius.circular(12),
  //               boxShadow: [
  //                 BoxShadow(
  //                   offset: const Offset(2, 2),
  //                   blurRadius: 6,
  //                   spreadRadius: 1,
  //                   color: Colors.grey.withOpacity(0.15),
  //                 ),
  //                 const BoxShadow(
  //                   offset: Offset(-2, -2),
  //                   blurRadius: 6,
  //                   spreadRadius: 1,
  //                   color: Colors.white,
  //                 ),
  //               ],
  //             ),
  //             child: Row(
  //               children: [
  //                 const Icon(Icons.access_time, color: Color(0xFF4A6FA5)),
  //                 const SizedBox(width: 10),
  //                 Expanded(
  //                   child: Text(
  //                     _startTime == null
  //                         ? "Start Time"
  //                         : _startTime!.format(context),
  //                     style: TextStyle(
  //                       fontSize: 16,
  //                       color:
  //                           _startTime == null
  //                               ? Colors.grey.shade500
  //                               : const Color(0xFF4A6FA5),
  //                     ),
  //                   ),
  //                 ),
  //               ],
  //             ),
  //           ),
  //         ),
  //       ),
  //       const SizedBox(width: 10),
  //       const Text(
  //         "To",
  //         style: TextStyle(fontSize: 16, color: Color(0xFF4A6FA5)),
  //       ),
  //       const SizedBox(width: 10),
  //       Expanded(
  //         child: InkWell(
  //           onTap: () => _selectEndTime(context),
  //           borderRadius: BorderRadius.circular(12),
  //           child: Container(
  //             padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
  //             decoration: BoxDecoration(
  //               color: Colors.white,
  //               borderRadius: BorderRadius.circular(12),
  //               boxShadow: [
  //                 BoxShadow(
  //                   offset: const Offset(2, 2),
  //                   blurRadius: 6,
  //                   spreadRadius: 1,
  //                   color: Colors.grey.withOpacity(0.15),
  //                 ),
  //                 const BoxShadow(
  //                   offset: Offset(-2, -2),
  //                   blurRadius: 6,
  //                   spreadRadius: 1,
  //                   color: Colors.white,
  //                 ),
  //               ],
  //             ),
  //             child: Row(
  //               children: [
  //                 const Icon(Icons.access_time, color: Color(0xFF4A6FA5)),
  //                 const SizedBox(width: 10),
  //                 Expanded(
  //                   child: Text(
  //                     _endTime == null ? "End Time" : _endTime!.format(context),
  //                     style: TextStyle(
  //                       fontSize: 16,
  //                       color:
  //                           _endTime == null
  //                               ? Colors.grey.shade500
  //                               : const Color(0xFF4A6FA5),
  //                     ),
  //                   ),
  //                 ),
  //               ],
  //             ),
  //           ),
  //         ),
  //       ),
  //     ],
  //   );
  // }