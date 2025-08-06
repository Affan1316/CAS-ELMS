import 'package:flutter/material.dart';
import 'package:flutter_cas_app_main/src/features/student%20enrolement%20form%20admin%20side/presentation/widgets/student_enrollment_form.dart';

class StudentEnrollmentScreen extends StatefulWidget {
  const StudentEnrollmentScreen({super.key});

  @override
  State<StudentEnrollmentScreen> createState() =>
      _StudentEnrollmentScreenState();
}

class _StudentEnrollmentScreenState extends State<StudentEnrollmentScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final _idController = TextEditingController();
  final _fullNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _cnicController = TextEditingController();
  final _fatherNameController = TextEditingController();
  final _fatherOccupationController = TextEditingController();
  final _phoneController = TextEditingController();
  final _addressController = TextEditingController();

  String _selectedGender = 'Male';

  @override
  void dispose() {
    _idController.dispose();
    _fullNameController.dispose();
    _emailController.dispose();
    _cnicController.dispose();
    _fatherNameController.dispose();
    _fatherOccupationController.dispose();
    _phoneController.dispose();
    _addressController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF3F4F6),
      appBar: AppBar(
        title: const Text('Enroll a New Student'),
        backgroundColor: const Color(0xFF3B82F6),
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: StudentEnrollmentForm(
          formKey: _formKey,
          studentIdController: _idController,
          nameController: _fullNameController,
          emailController: _emailController,
          cnicController: _cnicController,
          fatherNameController: _fatherNameController,
          fatherOccupationController: _fatherOccupationController,
          phoneController: _phoneController,
          addressController: _addressController,
          selectedGender: _selectedGender,
          onGenderChanged: (gender) {
            setState(() {
              _selectedGender = gender;
            });
          },
        ),
      ),
    );
  }
}
