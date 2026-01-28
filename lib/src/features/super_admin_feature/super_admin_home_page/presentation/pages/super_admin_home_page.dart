import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_cas_app_main/src/features/admin_login_screen/presentation/bloc/admin_login_bloc.dart';
import 'package:flutter_cas_app_main/src/features/admin_login_screen/presentation/bloc/admin_login_event.dart';
import 'package:flutter_cas_app_main/src/features/admin_login_screen/presentation/bloc/admin_login_state.dart';
import 'package:flutter_cas_app_main/src/features/categories_and_login_screen/presentation/pages/OnboardingScreen.dart';
import 'package:flutter_cas_app_main/src/features/fee_feature/presentation/pages/DayWiseFeePage.dart';
import 'package:flutter_cas_app_main/src/features/fee_feature/presentation/pages/fee_defaulters.dart';
import 'package:flutter_cas_app_main/src/features/fee_feature/presentation/pages/fee_history_screen.dart';
import 'package:flutter_cas_app_main/src/features/inquiry/presentation/pages/inquiry_detail_page.dart';
import 'package:flutter_cas_app_main/src/features/super_admin_fee_feature/presentation/pages/groups_report_page.dart';
import 'package:flutter_cas_app_main/src/features/super_admin_fee_feature/presentation/pages/super_admin_fee_notifications_screen.dart';
import 'package:flutter_neumorphic_plus/flutter_neumorphic.dart';

class SuperAdminDashboard extends StatelessWidget {
  const SuperAdminDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    return NeumorphicTheme(
      themeMode: ThemeMode.light,
      theme: const NeumorphicThemeData(
        baseColor: Color(0xFFE6E8F0),
        lightSource: LightSource.topLeft,
        depth: 8,
        intensity: 0.65,
      ),
      child: Scaffold(
        backgroundColor: const Color(0xFFE6E8F0),
        body: SafeArea(
          child: LayoutBuilder(
            builder: (context, constraints) {
              return SingleChildScrollView(
                child: ConstrainedBox(
                  constraints: BoxConstraints(minHeight: constraints.maxHeight),
                  child: Padding(
                    padding: EdgeInsets.all(
                      _getResponsivePadding(constraints.maxWidth),
                    ),
                    child: Column(
                      children: [
                        // Header Section
                        _buildHeader(constraints.maxWidth, context),
                        SizedBox(
                          height: _getResponsiveSpacing(constraints.maxWidth),
                        ),

                        // Dashboard Items Grid
                        _buildDashboardGrid(context, constraints.maxWidth),
                        SizedBox(
                          height: _getResponsivePadding(constraints.maxWidth),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  // Responsive helper methods
  double _getResponsivePadding(double screenWidth) {
    if (screenWidth > 1200) return 40.0; // Desktop
    if (screenWidth > 800) return 30.0; // Tablet
    if (screenWidth > 600) return 25.0; // Large Mobile
    return 20.0; // Mobile
  }

  double _getResponsiveSpacing(double screenWidth) {
    if (screenWidth > 1200) return 40.0; // Desktop
    if (screenWidth > 800) return 35.0; // Tablet
    if (screenWidth > 600) return 30.0; // Large Mobile
    return 25.0; // Mobile
  }

  int _getGridCrossAxisCount(double screenWidth) {
    if (screenWidth > 1200) return 4; // Desktop - 4 columns
    if (screenWidth > 900) return 3; // Large Tablet - 3 columns
    if (screenWidth > 600) return 2; // Tablet/Large Mobile - 2 columns
    return 2; // Mobile - 2 columns
  }

  double _getGridChildAspectRatio(double screenWidth) {
    if (screenWidth > 1200) return 1.2; // Desktop
    if (screenWidth > 900) return 1.15; // Large Tablet
    if (screenWidth > 600) return 1.1; // Tablet
    return 1.0; // Mobile - more square
  }

  double _getHeaderFontSize(double screenWidth, {bool isTitle = false}) {
    if (isTitle) {
      if (screenWidth > 1200) return 36.0; // Desktop
      if (screenWidth > 800) return 32.0; // Tablet
      if (screenWidth > 600) return 28.0; // Large Mobile
      return 24.0; // Mobile
    } else {
      if (screenWidth > 1200) return 18.0; // Desktop
      if (screenWidth > 800) return 16.0; // Tablet
      if (screenWidth > 600) return 15.0; // Large Mobile
      return 14.0; // Mobile
    }
  }

  double _getCardIconSize(double screenWidth) {
    if (screenWidth > 1200) return 32.0; // Desktop
    if (screenWidth > 800) return 30.0; // Tablet
    if (screenWidth > 600) return 28.0; // Large Mobile
    return 26.0; // Mobile
  }

  double _getCardTitleSize(double screenWidth) {
    if (screenWidth > 1200) return 18.0; // Desktop
    if (screenWidth > 800) return 16.0; // Tablet
    if (screenWidth > 600) return 15.0; // Large Mobile
    return 14.0; // Mobile
  }

  Widget _buildHeader(double screenWidth, BuildContext context) {
    final bool isDesktop = screenWidth > 1200;
    final bool isTablet = screenWidth > 800;
    final bool isMobile = screenWidth <= 600;

    return Neumorphic(
      style: NeumorphicStyle(
        depth: -5,
        boxShape: NeumorphicBoxShape.roundRect(BorderRadius.circular(20)),
        lightSource: LightSource.topLeft,
      ),
      padding: EdgeInsets.all(
        isDesktop
            ? 25
            : isTablet
            ? 20
            : 15,
      ),
      child:
          isMobile
              ? _buildMobileHeader(screenWidth, context)
              : _buildDesktopTabletHeader(screenWidth),
    );
  }

  Widget _buildMobileHeader(double screenWidth, BuildContext context) {
    return Column(
      children: [
        // Top row with logo, profile, and logout
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _buildLogo(screenWidth),

            // Right side: Notification and Logout buttons
            Row(
              children: [
                // Notification Button
                // GestureDetector(
                //   onTap: () {
                //     HapticFeedback.lightImpact();
                //     // Add notification functionality here
                //   },
                //   child: Neumorphic(
                //     style: NeumorphicStyle(
                //       depth: 3,
                //       boxShape: NeumorphicBoxShape.circle(),
                //     ),
                //     padding: EdgeInsets.all(10),
                //     child: Stack(
                //       children: [
                //         Icon(
                //           Icons.notifications_outlined,
                //           color: Color(0xFF6B7280),
                //           size: 20,
                //         ),
                //         // Notification dot
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

                // SizedBox(width: 10),

                // Logout Button
                GestureDetector(
                  onTap: () {
                    HapticFeedback.lightImpact();
                    _showLogoutDialog(context);
                  },
                  child: Neumorphic(
                    style: NeumorphicStyle(
                      depth: 3,
                      boxShape: NeumorphicBoxShape.roundRect(
                        BorderRadius.circular(10),
                      ),
                    ),
                    padding: EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.logout_outlined,
                          color: Color(0xFFEF4444),
                          size: 18,
                        ),
                        SizedBox(width: 5),
                        Text(
                          'Logout',
                          style: TextStyle(
                            color: Color(0xFF374151),
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
        const SizedBox(height: 15),

        // Company info centered
        Column(
          children: [
            NeumorphicText(
              "CAS",
              style: NeumorphicStyle(depth: 4, color: const Color(0xFF2D3748)),
              textStyle: NeumorphicTextStyle(
                fontSize: _getHeaderFontSize(screenWidth, isTitle: true),
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              "Center of Advance Solution",
              style: TextStyle(
                fontSize: _getHeaderFontSize(screenWidth),
                color: Colors.grey[600],
                fontWeight: FontWeight.w500,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 5),
            Text(
              "Super Admin Dashboard",
              style: TextStyle(
                fontSize: _getHeaderFontSize(screenWidth) - 2,
                color: Colors.grey[500],
                fontStyle: FontStyle.italic,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ],
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
                  ), // ⚠️ REPLACE WITH YOUR LOGIN ROUTE, // ⚠️ REPLACE WITH YOUR ACTUAL LOGIN ROUTE
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
                      padding: EdgeInsets.symmetric(
                        horizontal: 24,
                        vertical: 12,
                      ),
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

  Widget _buildDesktopTabletHeader(double screenWidth) {
    return Row(
      children: [
        // Company Logo
        _buildLogo(screenWidth),
        SizedBox(width: screenWidth > 1200 ? 25 : 20),

        // Company Name and Title
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              NeumorphicText(
                "CAS",
                style: NeumorphicStyle(
                  depth: 4,
                  color: const Color(0xFF2D3748),
                ),
                textStyle: NeumorphicTextStyle(
                  fontSize: _getHeaderFontSize(screenWidth, isTitle: true),
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                "Center of Advance Solution",
                style: TextStyle(
                  fontSize: _getHeaderFontSize(screenWidth),
                  color: Colors.grey[600],
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 5),
              Text(
                "Super Admin Dashboard",
                style: TextStyle(
                  fontSize: _getHeaderFontSize(screenWidth) - 2,
                  color: Colors.grey[500],
                  fontStyle: FontStyle.italic,
                ),
              ),
            ],
          ),
        ),

        // Profile Avatar
        _buildProfileAvatar(screenWidth),
      ],
    );
  }

  Widget _buildLogo(double screenWidth) {
    final double logoSize =
        screenWidth > 1200
            ? 70
            : screenWidth > 800
            ? 65
            : 55;
    final double iconSize =
        screenWidth > 1200
            ? 35
            : screenWidth > 800
            ? 32
            : 28;

    return Neumorphic(
      style: NeumorphicStyle(depth: 8, boxShape: NeumorphicBoxShape.circle()),
      child: Container(
        width: logoSize,
        height: logoSize,
        decoration: const BoxDecoration(
          shape: BoxShape.circle,
          gradient: LinearGradient(
            colors: [Color(0xFF667eea), Color(0xFF764ba2)],
          ),
        ),
        child: Icon(Icons.business, color: Colors.white, size: iconSize),
      ),
    );
  }

  Widget _buildProfileAvatar(double screenWidth) {
    final double avatarSize =
        screenWidth > 1200
            ? 60
            : screenWidth > 800
            ? 55
            : 45;
    final double iconSize =
        screenWidth > 1200
            ? 30
            : screenWidth > 800
            ? 27
            : 22;

    return NeumorphicButton(
      onPressed: () {},
      style: NeumorphicStyle(depth: 6, boxShape: NeumorphicBoxShape.circle()),
      child: Container(
        width: avatarSize,
        height: avatarSize,
        decoration: const BoxDecoration(
          shape: BoxShape.circle,
          gradient: LinearGradient(
            colors: [Color(0xFFff9a9e), Color(0xFFfecfef)],
          ),
        ),
        child: Icon(Icons.person, color: Colors.white, size: iconSize),
      ),
    );
  }

  Widget _buildDashboardGrid(BuildContext context, double screenWidth) {
    final List<DashboardItem> items = [
      DashboardItem(
        title: "Fee History",
        icon: Icons.history,
        color: const Color(0xFF667eea),
        onTap: () => _navigateToScreen(context, "Fee History"),
      ),
      DashboardItem(
        title: "Fee Defaulter",
        icon: Icons.warning_amber_rounded,
        color: const Color(0xFFf093fb),
        onTap: () => _navigateToScreen(context, "Fee Defaulter"),
      ),
      // DashboardItem(
      //   title: "Inquiry",
      //   icon: Icons.help_outline,
      //   color: const Color(0xFF4facfe),
      //   onTap: () => _navigateToScreen(context, "Inquiry"),
      // ),
      // DashboardItem(
      //   title: "Student Management",
      //   icon: Icons.school,
      //   color: const Color(0xFF43e97b),
      //   onTap: () => _navigateToScreen(context, "Student Management"),
      // ),
      // DashboardItem(
      //   title: "Course Management",
      //   icon: Icons.book,
      //   color: const Color(0xFFfa709a),
      //   onTap: () => _navigateToScreen(context, "Course Management"),
      // ),
      DashboardItem(
        title: "Reports",
        icon: Icons.assessment,
        color: const Color(0xFFffecd2),
        onTap: () => _navigateToScreen(context, "Reports"),
      ),
      // DashboardItem(
      //   title: "Settings",
      //   icon: Icons.settings,
      //   color: const Color(0xFFa8edea),
      //   onTap: () => _navigateToScreen(context, "Settings"),
      // ),
      // DashboardItem(
      //   title: "Analytics",
      //   icon: Icons.analytics,
      //   color: const Color(0xFFd299c2),
      //   onTap: () => _navigateToScreen(context, "Analytics"),
      // ),
      DashboardItem(
        title: "Notifications",
        icon: Icons.notifications,
        color: const Color(0xFFfed6e3),
        onTap: () => _navigateToScreen(context, "Notifications"),
      ),
      DashboardItem(
        title: "Inquiry",
        icon: Icons.info_outline,
        color: const Color.fromARGB(255, 0, 0, 0),
        onTap: () => _navigateToScreen(context, "Inquiry"),
      ),
    ];

    final crossAxisCount = _getGridCrossAxisCount(screenWidth);
    final childAspectRatio = _getGridChildAspectRatio(screenWidth);
    final crossAxisSpacing =
        screenWidth > 1200
            ? 25.0
            : screenWidth > 800
            ? 22.0
            : 18.0;
    final mainAxisSpacing =
        screenWidth > 1200
            ? 25.0
            : screenWidth > 800
            ? 22.0
            : 18.0;

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: crossAxisCount,
        crossAxisSpacing: crossAxisSpacing,
        mainAxisSpacing: mainAxisSpacing,
        childAspectRatio: childAspectRatio,
      ),
      itemCount: items.length,
      itemBuilder: (context, index) {
        return _buildDashboardCard(items[index], screenWidth);
      },
    );
  }

  Widget _buildDashboardCard(DashboardItem item, double screenWidth) {
    final double cardPadding =
        screenWidth > 1200
            ? 25
            : screenWidth > 800
            ? 20
            : 15;
    final double iconContainerSize =
        screenWidth > 1200
            ? 70
            : screenWidth > 800
            ? 65
            : 55;
    final double spacingBetween =
        screenWidth > 1200
            ? 18
            : screenWidth > 800
            ? 15
            : 12;

    return NeumorphicButton(
      onPressed: item.onTap,
      style: NeumorphicStyle(
        depth: 8,
        intensity: 0.65,
        boxShape: NeumorphicBoxShape.roundRect(BorderRadius.circular(20)),
        lightSource: LightSource.topLeft,
      ),
      child: Container(
        padding: EdgeInsets.all(cardPadding),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Icon Container
            Neumorphic(
              style: NeumorphicStyle(
                depth: -4,
                boxShape: NeumorphicBoxShape.circle(),
                lightSource: LightSource.topLeft,
              ),
              child: Container(
                width: iconContainerSize,
                height: iconContainerSize,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [item.color, item.color.withOpacity(0.7)],
                  ),
                ),
                child: Icon(
                  item.icon,
                  color: Colors.white,
                  size: _getCardIconSize(screenWidth),
                ),
              ),
            ),
            SizedBox(height: spacingBetween),

            // Title
            Flexible(
              child: NeumorphicText(
                item.title,
                style: NeumorphicStyle(
                  depth: 2,
                  color: const Color(0xFF2D3748),
                ),
                textStyle: NeumorphicTextStyle(
                  fontSize: _getCardTitleSize(screenWidth),
                  fontWeight: FontWeight.w600,
                ),
                textAlign: TextAlign.center,
                // maxLines: 2,
                // overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _navigateToScreen(BuildContext context, String screenName) {
    // Show a snackbar for demonstration
    // ScaffoldMessenger.of(context).showSnackBar(
    //   SnackBar(
    //     content: Text("Navigating to $screenName"),
    //     backgroundColor: const Color(0xFF667eea),
    //     behavior: SnackBarBehavior.floating,
    //     shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
    //     margin: EdgeInsets.all(
    //       _getResponsivePadding(MediaQuery.of(context).size.width),
    //     ),
    //   ),
    // );

    // Here you would implement actual navigation
    if (screenName == "Notifications") {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => SuperAdminFeeNotificationsScreen(),
        ),
      );
    }
    if (screenName == "Fee Defaulter") {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) {
            return FeeDefaulters();
          },
        ),
      );
    }
    if (screenName == "Fee History") {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) {
            return DayWiseFeePage();
          },
        ),
      );
    }
    if (screenName == "Reports") {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) {
            return GroupsReportPage();
          },
        ),
      );
    }
    if (screenName == "Inquiry") {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) {
            return InquiryDetailPage();
          },
        ),
      );
    }
  }
}

class DashboardItem {
  final String title;
  final IconData icon;
  final Color color;
  final VoidCallback onTap;

  DashboardItem({
    required this.title,
    required this.icon,
    required this.color,
    required this.onTap,
  });
}
