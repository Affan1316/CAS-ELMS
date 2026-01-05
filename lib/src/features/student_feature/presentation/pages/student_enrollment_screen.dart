import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_cas_app_main/src/features/student_feature/data/student_entity_class.dart';
import 'package:flutter_cas_app_main/src/features/student_feature/presentation/bloc/Student_feature_event.dart';
import 'package:flutter_cas_app_main/src/features/student_feature/presentation/bloc/student_feature_bloc.dart';
import 'package:flutter_cas_app_main/src/features/student_feature/presentation/bloc/student_feature_state.dart';
import 'package:flutter_cas_app_main/src/features/student_feature/presentation/widgets/student_enrollment_form.dart';

class StudentEnrollmentScreen extends StatefulWidget {
  final bool isEditMode;
  final StudentEntityClass? studentData;

  const StudentEnrollmentScreen({
    super.key,
    this.isEditMode = false,
    this.studentData,
  });

  @override
  State<StudentEnrollmentScreen> createState() =>
      _StudentEnrollmentScreenState();
}

class _StudentEnrollmentScreenState extends State<StudentEnrollmentScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  List<String> listOfGroupNamesForDropDownMenue = [];
  final _idController = TextEditingController();
  final _fullNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _cnicController = TextEditingController();
  final _fatherNameController = TextEditingController();
  final _fatherOccupationController = TextEditingController();
  final _phoneController = TextEditingController();
  final _addressController = TextEditingController();
  final _groupController = TextEditingController();

  String _selectedGender = 'Male';
  bool _isInitialized = false;
  bool _isSubmitting = false;

  @override
  void initState() {
    super.initState();
    
    // Pre-fill form if in edit mode
    if (widget.isEditMode && widget.studentData != null) {
      _idController.text = widget.studentData!.id;
      _fullNameController.text = widget.studentData!.name;
      _emailController.text = widget.studentData!.email;
      _cnicController.text = widget.studentData!.cnic;
      _fatherNameController.text = widget.studentData!.fatherName;
      _fatherOccupationController.text = widget.studentData!.fatherOccupation;
      _phoneController.text = widget.studentData!.phone;
      _addressController.text = widget.studentData!.address;
      _groupController.text = widget.studentData!.group;
      _selectedGender = widget.studentData!.gender;
    }
    
    // Fetch groups
    context.read<StudentFeatureBloc>().add(FetchGroupNamesEvent());
  }

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
    _groupController.dispose();
    super.dispose();
  }

  // Show loading dialog - Matches group students screen style
  void _showLoadingDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      barrierColor: Colors.black.withOpacity(0.5),
      builder: (BuildContext context) {
        return Dialog(
          backgroundColor: Colors.transparent,
          elevation: 0,
          child: Container(
            padding: const EdgeInsets.all(32),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.2),
                  blurRadius: 20,
                  offset: const Offset(0, 10),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        Color(0xFF3B82F6),
                        Color(0xFF5D5FEF),
                      ],
                    ),
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: const Center(
                    child: CircularProgressIndicator(
                      strokeWidth: 3,
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Text(
                  widget.isEditMode ? 'Updating student...' : 'Enrolling student...',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF111827),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  // Hide loading dialog
  void _hideLoadingDialog() {
    if (mounted && _isSubmitting) {
      Navigator.of(context, rootNavigator: true).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF3F4F6),
      appBar: AppBar(
        title: Text(
          widget.isEditMode ? 'Update Student' : 'Enroll a New Student',
          style: const TextStyle(color: Colors.white),
        ),
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Color(0xFF3B82F6),
                Color(0xFF5D5FEF),
              ],
            ),
          ),
        ),
        backgroundColor: Colors.transparent,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: BlocConsumer<StudentFeatureBloc, StudentFeatureState>(
        listener: (context, state) {
          if (state is GroupNamesfetchingCompleted) {
            setState(() {
              listOfGroupNamesForDropDownMenue = state.listOfGroupNames;
              _isInitialized = true;
            });
          }

          // Show loading dialog when submitting/updating
          if (state is StudentEnrollmentSubmitting || state is StudentDataUpdating) {
            if (!_isSubmitting) {
              _isSubmitting = true;
              _showLoadingDialog();
            }
          }

          if (state is StudentEnrollmentSuccess) {
            _isSubmitting = false;
            _hideLoadingDialog();
            
            _idController.clear();
            _fullNameController.clear();
            _emailController.clear();
            _cnicController.clear();
            _fatherNameController.clear();
            _fatherOccupationController.clear();
            _phoneController.clear();
            _addressController.clear();
            _groupController.clear();
            setState(() {
              _selectedGender = 'Male';
            });
            
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: const Row(
                  children: [
                    Icon(Icons.check_circle, color: Colors.white),
                    SizedBox(width: 12),
                    Text("Student enrolled successfully!"),
                  ],
                ),
                backgroundColor: const Color(0xFF10B981),
                behavior: SnackBarBehavior.floating,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            );
          }

          if (state is StudentDataUpdateSuccess) {
            _isSubmitting = false;
            _hideLoadingDialog();
            
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: const Row(
                  children: [
                    Icon(Icons.check_circle, color: Colors.white),
                    SizedBox(width: 12),
                    Text("Student updated successfully!"),
                  ],
                ),
                backgroundColor: const Color(0xFF10B981),
                behavior: SnackBarBehavior.floating,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            );
            Navigator.of(context).pop(); // Go back after update
          }

          if (state is StudentDataUpdateFailure) {
            _isSubmitting = false;
            _hideLoadingDialog();
            
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Row(
                  children: [
                    const Icon(Icons.error_outline, color: Colors.white),
                    const SizedBox(width: 12),
                    Expanded(child: Text(state.error)),
                  ],
                ),
                backgroundColor: const Color(0xFFEF4444),
                behavior: SnackBarBehavior.floating,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            );
          }

          if (state is StudentEnrollmentFailure) {
            _isSubmitting = false;
            _hideLoadingDialog();
            
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Row(
                  children: [
                    const Icon(Icons.error_outline, color: Colors.white),
                    const SizedBox(width: 12),
                    Expanded(child: Text(state.error)),
                  ],
                ),
                backgroundColor: const Color(0xFFEF4444),
                behavior: SnackBarBehavior.floating,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            );
          }
        },
        builder: (context, state) {
          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: StudentEnrollmentForm(
              isEditMode: widget.isEditMode,
              listOfGroupsNames: listOfGroupNamesForDropDownMenue,
              formKey: _formKey,
              studentIdController: _idController,
              nameController: _fullNameController,
              emailController: _emailController,
              cnicController: _cnicController,
              fatherNameController: _fatherNameController,
              fatherOccupationController: _fatherOccupationController,
              phoneController: _phoneController,
              addressController: _addressController,
              groupController: _groupController,
              selectedGender: _selectedGender,
              onGenderChanged: (gender) {
                setState(() {
                  _selectedGender = gender;
                });
              },
            ),
          );
        },
      ),
    );
  }
}