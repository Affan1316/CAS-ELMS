import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_cas_app_main/src/features/add_courses/presentation/bloc/add_course_bloc.dart';
import 'package:flutter_cas_app_main/src/features/inquiry/presentation/bloc/inquiry_bloc.dart';
import '../widgets/header.dart';
import '../widgets/hero_section.dart';
import '../widgets/form_section.dart';

class AddInquiryPage extends StatefulWidget {
  const AddInquiryPage({super.key});

  @override
  State<AddInquiryPage> createState() => _AddInstructorScreenState();
}

class _AddInstructorScreenState extends State<AddInquiryPage>
    with SingleTickerProviderStateMixin {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _studentNameController = TextEditingController();
  final TextEditingController _fatherNameController = TextEditingController();
  final TextEditingController _emailAddressController = TextEditingController();
  final TextEditingController _phoneNoController = TextEditingController();
  final TextEditingController _groupNameController = TextEditingController();

  String? _gender;
  String? _selectedCourse;

  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
    _animationController.forward();

    context.read<AddCourseBloc>().add(LoadCourses());
  }

  @override
  void dispose() {
    _animationController.dispose();
    _studentNameController.dispose();
    _fatherNameController.dispose();
    _emailAddressController.dispose();
    _phoneNoController.dispose();
    _groupNameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      body: SafeArea(
        child: Column(
          children: [
            const Header(),
            Expanded(
              child: FadeTransition(
                opacity: _fadeAnimation,
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    children: [
                      const HeroSection(),
                      const SizedBox(height: 32),
                        BlocConsumer<InquiryBloc, InquiryState>(
                        listener: (context, state) {
                          if (state is InquirySuccess) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: const Text(
                                  'Inquiry added successfully!',
                                ),
                                backgroundColor: const Color(0xFF10B981),
                                behavior: SnackBarBehavior.floating,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                            );
                          }
                        },
                        builder: (context, inquiryState) {
                          return BlocBuilder<AddCourseBloc, AddCourseState>(
                            builder: (context, courseState) {
                              List<String> courses = [];
                              if (courseState is CourseLoaded) {
                                courses =
                                    courseState.courses.map((c) => c.name).toSet().toList();
                              }
                              return FormSection(
                                formKey: _formKey,
                                studentNameController: _studentNameController,
                                fatherNameController: _fatherNameController,
                                emailAddressController: _emailAddressController,
                                phoneNoController: _phoneNoController,
                                groupNameController: _groupNameController,
                                selectedCourse: _selectedCourse,
                                gender: _gender,
                                onGenderChanged: (val) =>
                                    setState(() => _gender = val),
                                onCourseChanged: (val) =>
                                    setState(() => _selectedCourse = val),
                                courses: courses,
                              );
                            },
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
