// Data Models

import 'package:flutter/material.dart';
import 'package:flutter_cas_app_main/src/features/fee_feature/presentation/widgets/responsive_text.dart';

class ScreenHeader extends StatelessWidget {
  final String title;
  final Widget? trailing;
  // final BuildContext context;
  // final String? studentId;
  const ScreenHeader({
    super.key,
    required this.title,
    this.trailing,
    // required this.context,
    // this.studentId,
  });
  // void _refreshData() {
  //   if (studentId == null) {
  //     AssertionError("You did not provide student id but you are trying to refresh student installment data ");
  //   }
  //   context.read<FeeAdminBloc>().add(
  //     GetStudentInstalmentEvent(studentId: studentId!),
  //   );
  // }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xFF3E206D)),
          onPressed: () => Navigator.pop(context),
        ),
        Expanded(
          child: ResponsiveText(
            text: title,
            phoneSize: 20,
            tabletSize: 26,
            weight: FontWeight.bold,
          ),
        ),

        if (trailing != null) trailing!,
      ],
    );
  }
}
