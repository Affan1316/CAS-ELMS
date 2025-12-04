import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/theme/app_colors.dart';
import '../bloc/Student_feature_event.dart';
import '../bloc/student_feature_bloc.dart';

Future<void> showLogoutDialog(BuildContext context) {
  return showDialog(
    context: context,
    barrierDismissible: false,
    builder: (context) {
      return AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text(
          "Logout",
          style: TextStyle(
            color: AppColors.textPrimary,
            fontWeight: FontWeight.bold,
          ),
        ),
        content: Text(
          "Are you sure you want to logout?",
          style: TextStyle(color: AppColors.textSecondary),
        ),
        actionsPadding: const EdgeInsets.only(bottom: 8, right: 12),
        actions: [
          // Cancel Button
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              "Cancel",
              style: TextStyle(
                color: AppColors.textSecondary,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),

          // Logout Button
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primaryColor,
              foregroundColor: AppColors.buttonText,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            onPressed: () {
              Navigator.pop(context);
              // Add your logout logic here
              context.read<StudentFeatureBloc>().add(SignOutEvent());
            },
            child: const Text(
              "Logout",
              style: TextStyle(fontWeight: FontWeight.w600),
            ),
          ),
        ],
      );
    },
  );
}
