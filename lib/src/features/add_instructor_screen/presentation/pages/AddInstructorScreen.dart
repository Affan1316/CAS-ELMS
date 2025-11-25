import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_cas_app_main/src/features/add_instructor_screen/presentation/bloc/add_instructor_bloc.dart';
import 'package:flutter_cas_app_main/src/features/add_instructor_screen/presentation/bloc/add_instructor_event.dart';
import 'package:flutter_cas_app_main/src/features/add_instructor_screen/presentation/bloc/add_instructor_state.dart';
import 'package:flutter_cas_app_main/src/features/add_instructor_screen/presentation/widgets/AddInstructorHeader%20.dart'
    show AddInstructorHeader;
import 'package:flutter_cas_app_main/src/features/add_instructor_screen/presentation/widgets/AddInstructorHeroSection.dart';
import 'package:flutter_cas_app_main/src/features/add_instructor_screen/presentation/widgets/CustomTextField.dart';
import 'package:flutter_cas_app_main/src/features/add_instructor_screen/presentation/widgets/GenderSelection.dart';
import 'package:flutter_cas_app_main/src/features/add_instructor_screen/presentation/widgets/SubmitButton.dart';

class AddInstructorPage extends StatefulWidget {
  const AddInstructorPage({super.key});

  @override
  State<AddInstructorPage> createState() => _AddInstructorPageState();
}

class _AddInstructorPageState extends State<AddInstructorPage>
    with SingleTickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  // Controllers
  final _instructorIdController = TextEditingController();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _cnicController = TextEditingController();
  final _phoneController = TextEditingController();
  final _addressController = TextEditingController();

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
    _instructorIdController.dispose();
    _nameController.dispose();
    _emailController.dispose();
    _cnicController.dispose();
    _phoneController.dispose();
    _addressController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AddInstructorBloc(),
      child: Scaffold(
        backgroundColor: const Color(0xFFF8FAFC),
        body: SafeArea(
          child: Column(
            children: [
              const AddInstructorHeader(),
              Expanded(
                child: FadeTransition(
                  opacity: _fadeAnimation,
                  child: SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    child: Padding(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        children: [
                          const AddInstructorHeroSection(),
                          const SizedBox(height: 32),
                          _buildForm(),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildForm() {
    return BlocListener<AddInstructorBloc, AddInstructorState>(
      listener: (context, state) {
        if (state.status == AddInstructorStatus.success) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.successMessage ?? 'Success!'),
              backgroundColor: const Color(0xFF10B981),
              behavior: SnackBarBehavior.floating,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          );
          Navigator.pop(context);
        } else if (state.status == AddInstructorStatus.failure) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.errorMessage ?? 'An error occurred'),
              backgroundColor: const Color(0xFFEF4444),
              behavior: SnackBarBehavior.floating,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          );
        }
      },
      child: Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 20,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CustomTextField(
                controller: _instructorIdController,
                label: 'Instructor ID',
                icon: Icons.badge_outlined,
                validator:
                    (value) =>
                        value?.isEmpty ?? true
                            ? 'Please enter instructor ID'
                            : null,
              ),
              const SizedBox(height: 20),
              CustomTextField(
                controller: _nameController,
                label: 'Full Name',
                icon: Icons.person_outline,
                validator:
                    (value) =>
                        value?.isEmpty ?? true
                            ? 'Please enter full name'
                            : null,
              ),
              const SizedBox(height: 20),
              CustomTextField(
                controller: _emailController,
                label: 'Email Address',
                icon: Icons.email_outlined,
                keyboardType: TextInputType.emailAddress,
                validator: (value) {
                  if (value?.isEmpty ?? true) return 'Please enter email';
                  if (!RegExp(
                    r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$',
                  ).hasMatch(value!)) {
                    return 'Please enter a valid email';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              CustomTextField(
                controller: _cnicController,
                label: 'CNIC',
                icon: Icons.credit_card_outlined,
                keyboardType: TextInputType.number,
                validator:
                    (value) =>
                        value?.isEmpty ?? true ? 'Please enter CNIC' : null,
              ),
              const SizedBox(height: 20),
              CustomTextField(
                controller: _phoneController,
                label: 'Phone Number',
                icon: Icons.phone_outlined,
                keyboardType: TextInputType.phone,
                validator:
                    (value) =>
                        value?.isEmpty ?? true
                            ? 'Please enter phone number'
                            : null,
              ),
              const SizedBox(height: 20),
              CustomTextField(
                controller: _addressController,
                label: 'Address',
                icon: Icons.location_on_outlined,
                maxLines: 3,
                validator:
                    (value) =>
                        value?.isEmpty ?? true ? 'Please enter address' : null,
              ),
              const SizedBox(height: 24),
              const GenderSelection(),
              const SizedBox(height: 32),
              SubmitButton(onPressed: () => _handleSubmit(context)),
            ],
          ),
        ),
      ),
    );
  }

  void _handleSubmit(BuildContext context) {
    if (_formKey.currentState!.validate()) {
      final bloc = context.read<AddInstructorBloc>();
      bloc.add(
        SubmitInstructorEvent(
          instructorId: _instructorIdController.text,
          name: _nameController.text,
          email: _emailController.text,
          cnic: _cnicController.text,
          phone: _phoneController.text,
          address: _addressController.text,
          gender: bloc.state.selectedGender,
        ),
      );
    }
  }
}
