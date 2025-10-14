import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_cas_app_main/src/features/student_feature/presentation/bloc/Student_feature_event.dart';
import 'package:flutter_cas_app_main/src/features/student_feature/presentation/bloc/student_feature_bloc.dart';
import 'package:flutter_cas_app_main/src/features/student_feature/presentation/bloc/student_feature_state.dart';
import 'package:flutter_cas_app_main/src/features/student_feature/presentation/widgets/student_enrollment_form.dart';

class StudentEnrollmentScreen extends StatefulWidget {
  const StudentEnrollmentScreen({super.key});

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
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF3F4F6),
      appBar: AppBar(
        title: const Text('Enroll a New Student'),
        backgroundColor: const Color(0xFF3B82F6),
        foregroundColor: Colors.white,
      ),
      body: BlocConsumer<StudentFeatureBloc, StudentFeatureState>(
        listener: (context, state) {
          if (state is GroupNamesfetchingCompleted) {
            // debugPrint("${state.listOfGroupNames}");
            listOfGroupNamesForDropDownMenue = state.listOfGroupNames;
          }
          if (state is StudentEnrollmentSuccess) {
            // ScaffoldMessenger.of(context).showSnackBar(
            //   const SnackBar(
            //     content: Text("✅ Student enrolled successfully"),
            //     backgroundColor: Colors.green,
            //   ),
            // );
            _idController.clear();
            _fullNameController.clear();
            _emailController.clear();
            _cnicController.clear();
            _fatherNameController.clear();
            _fatherOccupationController.clear();
            _phoneController.clear();
            _addressController.clear();
            _groupController.clear;
            setState(() {
              _selectedGender = 'Male';
            });
          }

          if (state is StudentEnrollmentFailure) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text("❌ ${state.error}"),
                backgroundColor: Colors.red,
              ),
            );
          }
        },
        builder: (context, state) {
          if (state is GroupNamesfetching) {
            return Center(child: CircularProgressIndicator());
          }

          return Stack(
            children: [
              SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: StudentEnrollmentForm(
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
              ),

              // Loader overlay when submitting
              if (state is StudentEnrollmentSubmitting)
                Container(
                  color: Colors.black.withOpacity(0.3),
                  child: const Center(child: CircularProgressIndicator()),
                ),
            ],
          );
        },
      ),
    );
  }
}
