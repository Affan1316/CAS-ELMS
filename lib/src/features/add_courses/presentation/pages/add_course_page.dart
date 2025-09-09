import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_cas_app_main/src/features/add_courses/presentation/bloc/add_course_bloc.dart';
import '../widgets/add_course_header.dart';
import '../widgets/course_hero_section.dart';
import '../widgets/course_form.dart';

class AddCoursesPage extends StatefulWidget {
  const AddCoursesPage({super.key});

  @override
  State<AddCoursesPage> createState() => _AddInquiryScreenState();
}

class _AddInquiryScreenState extends State<AddCoursesPage>
    with SingleTickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();

  final bool _isLoading = false;

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
  }

  @override
  void dispose() {
    _animationController.dispose();
    _nameController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      body: BlocConsumer<AddCourseBloc, AddCourseState>(
        listener: (context, state) {
          if(state is AddCourseSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
            content: const Text('Courses added successfully!'),
            backgroundColor: const Color(0xFF10B981),
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            ));
          } else{
            if(state is AddCourseFailure){
              ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
            content: const Text('Course already exits!'),
            backgroundColor: const Color(0xFF10B981),
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            ));
            }
          }
        },
        builder: (context, state) {
          return SafeArea(
            child: Column(
              children: [
                const AddCourseHeader(),
                Expanded(
                  child: FadeTransition(
                    opacity: _fadeAnimation,
                    child: SingleChildScrollView(
                      physics: const BouncingScrollPhysics(),
                      child: Padding(
                        padding: const EdgeInsets.all(20),
                        child: Column(
                          children: [
                            const CourseHeroSection(),
                            const SizedBox(height: 32),
                            CourseForm(
                              formKey: _formKey,
                              nameController: _nameController,
                              descriptionController: _descriptionController,
                              isLoading: _isLoading,
                              onSubmit: _handleSubmit,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
      },
      ),
    );
  }

  void _handleSubmit() async {
    if (_formKey.currentState!.validate()) {
      context.read<AddCourseBloc>().add(
        SubmitCourse(_nameController.text, _descriptionController.text),
      );
    }
  }
}
