import 'package:flutter/material.dart';
import 'package:flutter_cas_app_main/src/features/categories_and_login_screen/presentation/widgets/StudentLoginScreen.dart';

class SignUpFooter extends StatelessWidget {
  final String id;
  const SignUpFooter({Key? key, required this.id}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          'Already have an account? ',
          style: TextStyle(color: Colors.grey.shade600),
        ),
        GestureDetector(
          onTap: () {
            // Navigate to sign in screen
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => StudentLoginScreen(studentid: id),
              ),
            );
          },
          child: Text(
            'Sign In',
            style: TextStyle(
              color: Colors.blue.shade600,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }
}
