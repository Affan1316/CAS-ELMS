import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_cas_app_main/src/features/inquiry/presentation/bloc/inquiry_bloc.dart';

class SubmitButton extends StatelessWidget {
  final TextEditingController studentNameController;
  final TextEditingController fatherNameController;
  final TextEditingController emailAddressController;
  final TextEditingController phoneNoController;
  final TextEditingController groupNameController;
  final String? selectedCourse;
  final String? gender;
  const SubmitButton({
  super.key,
  required this.studentNameController, 
  required this.fatherNameController, 
  required this.emailAddressController, 
  required this.phoneNoController, 
  required this.groupNameController, 
  required this.gender,
  required this.selectedCourse});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 56,
      child: ElevatedButton(
        onPressed: () {
          if (Form.of(context).validate()) {
            context.read<InquiryBloc>().add(
              SubmitInquiry(
                studentNameController.text, 
                fatherNameController.text, 
                emailAddressController.text, 
                phoneNoController.text, 
                groupNameController.text,
                selectedCourse ?? "",
                gender ?? ""
              )
            );
            // ScaffoldMessenger.of(context).showSnackBar(
            //   const SnackBar(content: Text('Inquiry submitted successfully!')),
            // );
          }
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF3B82F6),
          foregroundColor: Colors.white,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
        child: const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.person_add, size: 20),
            SizedBox(width: 8),
            Text(
              'Submit',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),
          ],
        ),
      ),
    );
  }
}
