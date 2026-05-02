import 'package:flutter/material.dart';
import 'package:flutter_cas_app_main/src/features/categories_and_login_screen/presentation/widgets/StudentLoginScreen.dart';

class SignUpFooter extends StatelessWidget {
  // ── LOGIC UNCHANGED: same constructor signature and navigation ────────────
  final String id;
  const SignUpFooter({super.key, required this.id});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: GestureDetector(
        onTap: () {
          // LOGIC UNCHANGED
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => StudentLoginScreen(studentid: id),
            ),
          );
        },
        child: RichText(
          text: const TextSpan(
            style: TextStyle(fontSize: 13, color: Color(0xFFAAAAAA)),
            children: [
              TextSpan(text: 'Already have an account? '),
              TextSpan(
                text: 'Sign in',
                style: TextStyle(
                  color: Color(0xFF111111),
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
