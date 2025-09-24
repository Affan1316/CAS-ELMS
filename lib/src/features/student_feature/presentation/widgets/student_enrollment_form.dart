import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_cas_app_main/src/features/fee_feature/presentation/pages/installment_page.dart';
import 'package:flutter_cas_app_main/src/features/student_feature/presentation/bloc/student_feature_bloc.dart';
import 'package:flutter_cas_app_main/src/features/student_feature/presentation/bloc/Student_feature_event.dart';
import 'package:flutter_cas_app_main/src/features/student_feature/presentation/bloc/student_feature_state.dart';

class StudentEnrollmentForm extends StatelessWidget {
  final GlobalKey<FormState> formKey;
  final TextEditingController studentIdController;
  final TextEditingController nameController;
  final TextEditingController emailController;
  final TextEditingController cnicController;
  final TextEditingController fatherNameController;
  final TextEditingController fatherOccupationController;
  final TextEditingController phoneController;
  final TextEditingController addressController;
  final TextEditingController groupController;
  final List<String> listOfGroupsNames;

  final String selectedGender;
  final ValueChanged<String> onGenderChanged;

  const StudentEnrollmentForm({
    super.key,
    required this.listOfGroupsNames,
    required this.formKey,
    required this.studentIdController,
    required this.nameController,
    required this.emailController,
    required this.cnicController,
    required this.fatherNameController,
    required this.fatherOccupationController,
    required this.phoneController,
    required this.addressController,
    required this.selectedGender,
    required this.onGenderChanged,
    required this.groupController,
  });

  @override
  Widget build(BuildContext context) {
    return BlocListener<StudentFeatureBloc, StudentFeatureState>(
      listener: (context, state) {
        if (state is StudentEnrollmentSuccess) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: const Text('Student enrolled successfully!'),
              backgroundColor: const Color(0xFF10B981),
              behavior: SnackBarBehavior.floating,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          );
          Navigator.of(context).pop();
        } else if (state is StudentEnrollmentFailure) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.error),
              backgroundColor: const Color(0xFFEF4444),
              behavior: SnackBarBehavior.floating,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          );
        }
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFF3B82F6), Color(0xFF6366F1)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFF3B82F6).withOpacity(0.25),
                  blurRadius: 16,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: Column(
              children: [
                Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.18),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: const Icon(
                    Icons.school,
                    size: 44,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 12),
                const Text(
                  'Enroll New Student',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  'Fill in the details below to register a student',
                  style: TextStyle(
                    fontSize: 13,
                    color: Colors.white.withOpacity(0.9),
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),

          const SizedBox(height: 20),

          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 18,
                  offset: const Offset(0, 6),
                ),
              ],
            ),
            child: Form(
              key: formKey,
              child: LayoutBuilder(
                builder: (context, constraints) {
                  final isWide = constraints.maxWidth > 700;
                  final fieldWidth =
                      isWide
                          ? (constraints.maxWidth / 2) - 20
                          : constraints.maxWidth;

                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Wrap(
                        spacing: 16,
                        runSpacing: 16,
                        children: [
                          SizedBox(
                            width: fieldWidth,
                            child: _buildTextField(
                              controller: studentIdController,
                              label: 'Student ID',
                              icon: Icons.badge_outlined,
                              validator:
                                  (v) =>
                                      (v == null || v.isEmpty)
                                          ? 'Student ID required'
                                          : null,
                            ),
                          ),
                          SizedBox(
                            width: fieldWidth,
                            child: _buildTextField(
                              controller: nameController,
                              label: 'Full Name',
                              icon: Icons.person_outline,
                              validator: (v) {
                                if (v == null || v.isEmpty)
                                  return 'Name is required';
                                if (!RegExp(r'^[a-zA-Z\s]+$').hasMatch(v))
                                  return 'Only letters allowed';
                                return null;
                              },
                            ),
                          ),
                          SizedBox(
                            width: fieldWidth,
                            child: _buildTextField(
                              controller: emailController,
                              label: 'Email Address',
                              icon: Icons.email_outlined,
                              keyboardType: TextInputType.emailAddress,
                              validator: (v) {
                                if (v == null || v.isEmpty)
                                  return 'Email is required';
                                if (!RegExp(
                                  r'^[\w\-\.\+]+@([\w\-]+\.)+[\w\-]{2,4}$',
                                ).hasMatch(v))
                                  return 'Enter a valid email';
                                return null;
                              },
                            ),
                          ),
                          SizedBox(
                            width: fieldWidth,
                            child: _buildTextField(
                              controller: cnicController,
                              label: 'CNIC',
                              icon: Icons.credit_card_outlined,
                              keyboardType: TextInputType.number,
                              validator: (v) {
                                if (v == null || v.isEmpty)
                                  return 'CNIC is required';
                                if (!RegExp(r'^\d{13}$').hasMatch(v))
                                  return 'Enter 13 digit CNIC';
                                return null;
                              },
                            ),
                          ),
                          SizedBox(
                            width: fieldWidth,
                            child: _buildTextField(
                              controller: fatherNameController,
                              label: "Father's Name",
                              icon: Icons.person,
                              validator:
                                  (v) =>
                                      (v == null || v.isEmpty)
                                          ? 'Required'
                                          : null,
                            ),
                          ),
                          SizedBox(
                            width: fieldWidth,
                            child: _buildTextField(
                              controller: fatherOccupationController,
                              label: "Father's Occupation",
                              icon: Icons.business_center_outlined,
                              validator:
                                  (v) =>
                                      (v == null || v.isEmpty)
                                          ? 'Required'
                                          : null,
                            ),
                          ),
                          SizedBox(
                            width: fieldWidth,
                            child: _buildTextField(
                              controller: phoneController,
                              label: 'Phone Number',
                              icon: Icons.phone_outlined,
                              keyboardType: TextInputType.phone,
                              validator: (v) {
                                if (v == null || v.isEmpty)
                                  return 'Phone required';
                                if (!RegExp(r'^\d{11}$').hasMatch(v))
                                  return 'Enter 11-digit Pakistani number';
                                return null;
                              },
                            ),
                          ),
                          SizedBox(
                            width: fieldWidth,
                            child: _buildTextField(
                              controller: addressController,
                              label: 'Address',
                              icon: Icons.location_on_outlined,
                              maxLines: 2,
                              validator:
                                  (v) =>
                                      (v == null || v.isEmpty)
                                          ? 'Address required'
                                          : null,
                            ),
                          ),
                          SizedBox(
                            width: fieldWidth,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'Group',
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                FormField<String>(
                                  initialValue:
                                      groupController.text.isNotEmpty
                                          ? groupController.text
                                          : null,
                                  validator:
                                      (value) =>
                                          (value == null || value.isEmpty)
                                              ? 'Required'
                                              : null,
                                  builder: (FormFieldState<String> field) {
                                    return InputDecorator(
                                      decoration: InputDecoration(
                                        prefixIcon: const Icon(
                                          Icons.group,
                                          color: Color(0xFF6B7280),
                                          size: 20,
                                        ),
                                        hintText: 'Select Group',
                                        filled: true,
                                        fillColor: const Color(0xFFF9FAFB),
                                        border: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(
                                            12,
                                          ),
                                          borderSide: const BorderSide(
                                            color: Color(0xFFE5E7EB),
                                          ),
                                        ),
                                        focusedBorder: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(
                                            12,
                                          ),
                                          borderSide: const BorderSide(
                                            color: Color(0xFF3B82F6),
                                            width: 2,
                                          ),
                                        ),
                                        errorText: field.errorText,
                                        contentPadding:
                                            const EdgeInsets.symmetric(
                                              horizontal: 14,
                                              vertical: 12,
                                            ),
                                      ),
                                      child: DropdownButtonHideUnderline(
                                        child: DropdownButton<String>(
                                          value: field.value,
                                          isDense: true,
                                          isExpanded: true,
                                          icon: const Icon(
                                            Icons.arrow_drop_down,
                                            color: Color(0xFF6B7280),
                                          ),
                                          onChanged: (newValue) {
                                            field.didChange(newValue);
                                            groupController.text =
                                                newValue ?? '';
                                          },
                                          items:
                                              listOfGroupsNames.map((
                                                String value,
                                              ) {
                                                return DropdownMenuItem<String>(
                                                  value: value,
                                                  child: Text(value),
                                                );
                                              }).toList(),
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 18),

                      const Text(
                        'Gender',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Row(
                        children: [
                          Expanded(child: _genderTile('Male', Icons.male)),
                          const SizedBox(width: 12),
                          Expanded(child: _genderTile('Female', Icons.female)),
                        ],
                      ),

                      const SizedBox(height: 24),
                      SizedBox(
                        width: double.infinity,
                        height: 52,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF3B82F6),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(14),
                            ),
                            elevation: 4,
                          ),
                          onPressed: () {
                            if (studentIdController.text.trim().isEmpty) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: const Text(
                                    'Please enter Student ID first',
                                  ),
                                  backgroundColor: const Color(0xFFEF4444),
                                  behavior: SnackBarBehavior.floating,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                ),
                              );
                              return;
                            }
                            if (nameController.text.trim().isEmpty) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: const Text(
                                    'Please enter Student name first',
                                  ),
                                  backgroundColor: const Color(0xFFEF4444),
                                  behavior: SnackBarBehavior.floating,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                ),
                              );
                              return;
                            }
                            if (groupController.text.trim().isEmpty) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: const Text(
                                    'Please enter group  first',
                                  ),
                                  backgroundColor: const Color(0xFFEF4444),
                                  behavior: SnackBarBehavior.floating,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                ),
                              );
                              return;
                            }
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder:
                                    (context) => CreateFeePlanPage(
                                      studentId:
                                          studentIdController.text.trim(),
                                      groupId: groupController.text.trim(),
                                      name: nameController.text.trim(),
                                    ),
                              ),
                            );
                          },
                          child: const Text(
                            'Make Installment',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 25),

                      BlocBuilder<StudentFeatureBloc, StudentFeatureState>(
                        builder: (context, state) {
                          final isLoading =
                              state is StudentEnrollmentSubmitting;
                          return SizedBox(
                            width: double.infinity,
                            height: 52,
                            child: ElevatedButton(
                              onPressed:
                                  isLoading
                                      ? null
                                      : () {
                                        if (formKey.currentState?.validate() ??
                                            false) {
                                          context
                                              .read<StudentFeatureBloc>()
                                              .add(
                                                SubmitEnrollmentFormEvent(
                                                  id: studentIdController.text,
                                                  name: nameController.text,
                                                  email: emailController.text,
                                                  cnic: cnicController.text,
                                                  phone: phoneController.text,
                                                  address:
                                                      addressController.text,
                                                  gender: selectedGender,
                                                  fatherName:
                                                      fatherNameController.text,
                                                  fatherOccupation:
                                                      fatherOccupationController
                                                          .text,
                                                  group: groupController.text,
                                                ),
                                              );
                                        }
                                      },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFF3B82F6),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(14),
                                ),
                                elevation: 4,
                              ),
                              child:
                                  isLoading
                                      ? const SizedBox(
                                        width: 20,
                                        height: 20,
                                        child: CircularProgressIndicator(
                                          strokeWidth: 2,
                                          color: Colors.white,
                                        ),
                                      )
                                      : const Text(
                                        'Submit Enrollment',
                                        style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                            ),
                          );
                        },
                      ),
                    ],
                  );
                },
              ),
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
    int maxLines = 1,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          keyboardType: keyboardType,
          maxLines: maxLines,
          validator: validator,
          decoration: InputDecoration(
            prefixIcon: Icon(icon, color: const Color(0xFF6B7280), size: 20),
            hintText: 'Enter $label',
            filled: true,
            fillColor: const Color(0xFFF9FAFB),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Color(0xFFE5E7EB)),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Color(0xFF3B82F6), width: 2),
            ),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 14,
              vertical: 12,
            ),
          ),
        ),
      ],
    );
  }

  Widget _genderTile(String gender, IconData icon) {
    final isSelected = selectedGender == gender;
    return GestureDetector(
      onTap: () => onGenderChanged(gender),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 12),
        decoration: BoxDecoration(
          color:
              isSelected
                  ? const Color(0xFF3B82F6).withOpacity(0.08)
                  : const Color(0xFFF9FAFB),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color:
                isSelected ? const Color(0xFF3B82F6) : const Color(0xFFE5E7EB),
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              color:
                  isSelected
                      ? const Color(0xFF3B82F6)
                      : const Color(0xFF6B7280),
              size: 20,
            ),
            const SizedBox(width: 8),
            Text(
              gender,
              style: TextStyle(
                color:
                    isSelected
                        ? const Color(0xFF3B82F6)
                        : const Color(0xFF374151),
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
