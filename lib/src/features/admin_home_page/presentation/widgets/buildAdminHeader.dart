import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_cas_app_main/src/features/admin_home_page/presentation/pages/admin_home_page.dart';
import 'package:flutter_cas_app_main/src/features/admin_login_screen/presentation/bloc/admin_login_bloc.dart';
import 'package:flutter_cas_app_main/src/features/admin_login_screen/presentation/bloc/admin_login_event.dart';
import 'package:flutter_cas_app_main/src/features/admin_login_screen/presentation/bloc/admin_login_state.dart';
import 'package:flutter_cas_app_main/src/features/categories_and_login_screen/presentation/pages/OnboardingScreen.dart';

Widget buildAdminHeader() {
  return LayoutBuilder(
    builder: (context, constraints) {
      final size = MediaQuery.of(context).size;
      final isTablet = size.width >= 600;
      final isDesktop = size.width >= 1024;

      final horizontalPadding = isDesktop ? 40.0 : (isTablet ? 32.0 : 24.0);
      final verticalPadding = isDesktop ? 32.0 : 24.0;
      final buttonPadding = isDesktop ? 18.0 : (isTablet ? 14.0 : 12.0);
      final iconSize = isDesktop ? 22.0 : (isTablet ? 20.0 : 18.0);
      final fontSize = isDesktop ? 16.0 : 15.0;

      return Container(
        padding: EdgeInsets.fromLTRB(
          horizontalPadding,
          verticalPadding,
          horizontalPadding,
          16,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // LOGOUT BUTTON
            GestureDetector(
              onTap: () {
                HapticFeedback.lightImpact();
                _showLogoutDialog(context);
              },
              child: Container(
                padding: EdgeInsets.symmetric(
                  horizontal: isDesktop ? 20 : 16,
                  vertical: isDesktop ? 12 : 10,
                ),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Color(0xFFE5E5E5), width: 1),
                  boxShadow: [
                    BoxShadow(
                      color: Color(0xFF000000).withOpacity(0.04),
                      blurRadius: 8,
                      offset: Offset(0, 2),
                    ),
                  ],
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.logout_outlined,
                      color: Color(0xFF6B7280),
                      size: iconSize,
                    ),
                    SizedBox(width: 8),
                    Text(
                      'Logout',
                      style: TextStyle(
                        color: Color(0xFF374151),
                        fontSize: fontSize,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            // NOTIFICATION BUTTON
            // GestureDetector(
            //   onTap: () {
            //     HapticFeedback.lightImpact();
            //   },
            //   child: Container(
            //     padding: EdgeInsets.all(buttonPadding),
            //     decoration: BoxDecoration(
            //       color: Colors.white,
            //       borderRadius: BorderRadius.circular(12),
            //       border: Border.all(color: Color(0xFFE5E5E5), width: 1),
            //       boxShadow: [
            //         BoxShadow(
            //           color: Color(0xFF000000).withOpacity(0.04),
            //           blurRadius: 8,
            //           offset: Offset(0, 2),
            //         ),
            //       ],
            //     ),
            //     child: Stack(
            //       children: [
            //         Icon(
            //           Icons.notifications_outlined,
            //           color: Color(0xFF6B7280),
            //           size: iconSize,
            //         ),
            //         Positioned(
            //           right: 0,
            //           top: 0,
            //           child: Container(
            //             width: 6,
            //             height: 6,
            //             decoration: BoxDecoration(
            //               color: Color(0xFF3B82F6),
            //               borderRadius: BorderRadius.circular(3),
            //             ),
            //           ),
            //         ),
            //       ],
            //     ),
            //   ),
            // ),
          ],
        ),
      );
    },
  );
}

// LOGOUT CONFIRMATION DIALOG
void _showLogoutDialog(BuildContext context) {
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (BuildContext dialogContext) {
      return BlocProvider.value(
        value: context.read<AdminLoginBloc>(),
        child: BlocConsumer<AdminLoginBloc, AdminLoginState>(
          listener: (context, state) {
            if (state is AdminLoginInitial) {
              // Close dialog
              Navigator.of(dialogContext).pop();

              // Navigate to login screen and remove all previous routes
              Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(
                  builder: (context) => const RoleSelectionScreen(),
                ), // ⚠️ REPLACE WITH YOUR LOGIN ROUTE
                (route) => false,
              );

              // Show success message
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Logged out successfully'),
                  backgroundColor: Colors.green,
                  duration: Duration(seconds: 2),
                ),
              );
            } else if (state is AdminLoginFailure) {
              Navigator.of(dialogContext).pop();
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(state.message),
                  backgroundColor: Colors.red,
                  duration: Duration(seconds: 3),
                ),
              );
            }
          },
          builder: (context, state) {
            return AlertDialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              title: Row(
                children: [
                  Icon(Icons.logout, color: Color(0xFF3B82F6), size: 24),
                  SizedBox(width: 12),
                  Text(
                    'Confirm Logout',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF1F2937),
                    ),
                  ),
                ],
              ),
              content: Text(
                'Are you sure you want to logout?',
                style: TextStyle(fontSize: 16, color: Color(0xFF6B7280)),
              ),
              actions: [
                TextButton(
                  onPressed:
                      state is AdminLoginLoading
                          ? null
                          : () => Navigator.of(dialogContext).pop(),
                  child: Text(
                    'Cancel',
                    style: TextStyle(
                      color: Color(0xFF6B7280),
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                SizedBox(width: 8),
                ElevatedButton(
                  onPressed:
                      state is AdminLoginLoading
                          ? null
                          : () {
                            HapticFeedback.mediumImpact();
                            context.read<AdminLoginBloc>().add(
                              const AdminLogoutRequested(),
                            );
                          },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFF3B82F6),
                    foregroundColor: Colors.white,
                    padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    elevation: 0,
                  ),
                  child:
                      state is AdminLoginLoading
                          ? SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              valueColor: AlwaysStoppedAnimation<Color>(
                                Colors.white,
                              ),
                            ),
                          )
                          : Text(
                            'Logout',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                ),
              ],
            );
          },
        ),
      );
    },
  );
}
