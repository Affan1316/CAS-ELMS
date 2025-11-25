// AdminLoginScreen.dart (MODIFIED)

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_cas_app_main/src/features/admin_home_page/presentation/pages/admin_home_page.dart';
import 'package:flutter_cas_app_main/src/features/admin_login_screen/presentation/bloc/admin_login_bloc.dart';
import 'package:flutter_cas_app_main/src/features/admin_login_screen/presentation/bloc/admin_login_event.dart';
import 'package:flutter_cas_app_main/src/features/admin_login_screen/presentation/bloc/admin_login_state.dart';
import 'package:flutter_cas_app_main/src/features/admin_login_screen/presentation/bloc/forget_password_bloc.dart';
import 'package:flutter_cas_app_main/src/features/admin_login_screen/presentation/page/forget_password_screen.dart'
    hide AdminHomePage;
// --- ADDED: Import the service file to get the AdminRole enum ---
import 'package:flutter_cas_app_main/src/features/admin_login_screen/presentation/data/service/admin_storage_service.dart';
import 'package:flutter_cas_app_main/src/features/super_admin_feature/super_admin_home_page/presentation/pages/super_admin_home_page.dart';
// --- END ADDED ---

// --- ADDED: You will need to create and import your Super Admin screen ---
// For example:
// import 'package:flutter_cas_app_main/src/features/super_admin_home_page/presentation/pages/super_admin_home_page.dart';
// --- END ADDED ---

class AdminLoginScreen extends StatefulWidget {
  const AdminLoginScreen({super.key});

  @override
  _AdminLoginScreenState createState() => _AdminLoginScreenState();
}

class _AdminLoginScreenState extends State<AdminLoginScreen> {
  // ... (all your existing code, initState, dispose, etc. remains the same) ...
  final TextEditingController _userIdController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final FocusNode _userIdFocusNode = FocusNode();
  final FocusNode _passwordFocusNode = FocusNode();
  bool _obscurePassword = true;
  late AdminLoginBloc _adminLoginBloc;

  @override
  void initState() {
    super.initState();
    _adminLoginBloc = AdminLoginBloc();
    _adminLoginBloc.add(AdminLoginInitialized());

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _userIdController.clear();
      _passwordController.clear();
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _refreshTextFields();
  }

  void _refreshTextFields() {
    final userId = _userIdController.text;
    final password = _passwordController.text;

    _userIdController.clear();
    _passwordController.clear();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        _userIdController.text = userId;
        _passwordController.text = password;
      }
    });
  }

  void _handleLogin() {
    print('Handle login called');
    print('AdminId: ${_userIdController.text}');
    print('Password: ${_passwordController.text}');

    _adminLoginBloc.add(
      AdminLoginSubmitted(
        adminId: _userIdController.text.trim(),
        password: _passwordController.text,
      ),
    );
  }

  void _showMessage(String message, {bool isError = false}) {
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(message),
          backgroundColor: isError ? Colors.red : Colors.green,
          behavior: SnackBarBehavior.floating,
          duration: Duration(seconds: 3),
        ),
      );
    }
  }
  // --- END OF UNCHANGED CODE ---

  @override
  Widget build(BuildContext context) {
    return BlocProvider<AdminLoginBloc>(
      create: (context) => _adminLoginBloc,
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          // ... (appBar code remains the same) ...
        ),
        body: BlocListener<AdminLoginBloc, AdminLoginState>(
          bloc: _adminLoginBloc,
          // --- THIS LISTENER IS THE KEY CHANGE ---
          listener: (context, state) {
            print('BLoC State Changed: $state');

            if (state is AdminLoginSuccess) {
              print(
                'Login success - Role: ${state.role}',
              ); // state now has 'role'
              _passwordController.clear();
              _showMessage('Login successful!');

              // --- ADDED: Logic to decide where to navigate ---
              Widget destinationPage;
              if (state.role == AdminRole.superAdmin) {
                print('Navigating to SUPER ADMIN home');
                destinationPage =
                    SuperAdminDashboard(); // <-- Use your real page

                // Placeholder page until you create yours:
                // destinationPage = Scaffold(
                //   appBar: AppBar(title: Text('Super Admin Home')),
                //   body: Center(child: Text('Welcome, Super Admin!')),
                // );
              } else {
                // It must be AdminRole.admin
                print('Navigating to ADMIN home');
                destinationPage = AdminHomePage();
              }
              // --- END ADDED LOGIC ---

              Future.delayed(Duration(milliseconds: 500), () {
                if (mounted) {
                  Navigator.of(context).pushReplacement(
                    MaterialPageRoute(builder: (context) => destinationPage),
                  );
                }
              });
            } else if (state is AdminLoginFailure) {
              print('Login failure: ${state.message}');
              _passwordController.clear();
              _showMessage(state.message, isError: true);
              Future.delayed(Duration(milliseconds: 100), () {
                if (mounted) {
                  _adminLoginBloc.add(AdminLoginReset());
                }
              });
            }
          },
          // --- END OF LISTENER CHANGES ---
          child: _buildBody(),
        ),
      ),
    );
  }

  // ... (The rest of your file, _buildBody, _buildInputField, dispose, etc., remains the same) ...
  Widget _buildBody() {
    final screenSize = MediaQuery.of(context).size;
    final screenHeight = screenSize.height;
    final screenWidth = screenSize.width;
    final keyboardHeight = MediaQuery.of(context).viewInsets.bottom;

    final isSmallScreen = screenWidth < 360;
    final isMediumScreen = screenWidth >= 360 && screenWidth < 600;
    final isKeyboardOpen = keyboardHeight > 0;

    final topSectionHeight =
        isKeyboardOpen ? screenHeight * 0.2 : screenHeight * 0.35;
    final horizontalPadding = (screenWidth * 0.06).clamp(16.0, 32.0);
    final illustrationSize =
        isSmallScreen
            ? screenWidth * 0.45
            : isMediumScreen
            ? screenWidth * 0.5
            : screenWidth * 0.4;

    final titleFontSize = isSmallScreen ? 20.0 : 24.0;
    final subtitleFontSize = isSmallScreen ? 13.0 : 14.0;
    final inputFontSize = isSmallScreen ? 15.0 : 16.0;

    final titleSpacing = isKeyboardOpen ? 8.0 : 15.0;
    final inputSpacing = isKeyboardOpen ? 12.0 : 18.0;
    final verticalSpacing = isKeyboardOpen ? 6.0 : 15.0;

    return SingleChildScrollView(
      physics: const ClampingScrollPhysics(),
      child: ConstrainedBox(
        constraints: BoxConstraints(
          minHeight: screenHeight - keyboardHeight - kToolbarHeight,
        ),
        child: Column(
          children: [
            // Top section with illustration
            Container(
              height: topSectionHeight,
              width: double.infinity,
              decoration: const BoxDecoration(
                color: Color.fromARGB(255, 216, 240, 239),
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(30),
                  bottomRight: Radius.circular(30),
                ),
              ),
              child: Center(
                child: Container(
                  margin: EdgeInsets.only(top: isKeyboardOpen ? 10 : 20),
                  width: illustrationSize.clamp(150.0, 220.0),
                  height: illustrationSize.clamp(150.0, 220.0),
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        width: 80,
                        height: 60,
                        decoration: BoxDecoration(
                          color: Colors.orange.shade100,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Icon(
                          Icons.admin_panel_settings,
                          size: 40,
                          color: Colors.orange.shade600,
                        ),
                      ),
                      const SizedBox(height: 15),
                      Container(
                        width: 100,
                        height: 40,
                        decoration: BoxDecoration(
                          color: Colors.blue.shade100,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Icon(
                          Icons.security,
                          size: 25,
                          color: Colors.blue.shade600,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            // Bottom section with form
            Container(
              width: double.infinity,
              color: Colors.white,
              padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
              child: Column(
                children: [
                  SizedBox(height: verticalSpacing),

                  // Title
                  Text(
                    'Welcome Admin!',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: titleFontSize,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                      height: 1.3,
                    ),
                  ),

                  SizedBox(height: isKeyboardOpen ? 4 : 8),

                  // Subtitle
                  Text(
                    'Access your admin dashboard securely.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: subtitleFontSize,
                      color: Colors.grey,
                      height: 1.4,
                    ),
                  ),

                  SizedBox(height: titleSpacing),

                  // Admin ID input
                  _buildInputField(
                    controller: _userIdController,
                    focusNode: _userIdFocusNode,
                    hintText: 'Admin ID',
                    icon: Icons.admin_panel_settings,
                    fontSize: inputFontSize,
                    isSmallScreen: isSmallScreen,
                  ),

                  SizedBox(height: inputSpacing),

                  // Password input
                  _buildInputField(
                    controller: _passwordController,
                    focusNode: _passwordFocusNode,
                    hintText: 'Password',
                    icon: Icons.lock_outline,
                    fontSize: inputFontSize,
                    isSmallScreen: isSmallScreen,
                    isPassword: true,
                  ),

                  SizedBox(height: isKeyboardOpen ? 8 : 10),

                  // Forgot Password
                  Align(
                    alignment: Alignment.centerRight,
                    child: GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder:
                                (context) => BlocProvider(
                                  create: (context) => ForgotPasswordBloc(),
                                  child: ForgotPasswordScreen(),
                                ),
                          ),
                        );
                      },
                      child: Text(
                        'Forgot Password?',
                        style: TextStyle(
                          fontSize: isSmallScreen ? 13.0 : 14.0,
                          color: Colors.teal,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),

                  SizedBox(height: 20),

                  // Login Button
                  BlocBuilder<AdminLoginBloc, AdminLoginState>(
                    bloc: _adminLoginBloc,
                    builder: (context, state) {
                      bool isLoading = state is AdminLoginLoading;

                      return SizedBox(
                        width: double.infinity,
                        height: 56,
                        child: ElevatedButton(
                          onPressed: isLoading ? null : _handleLogin,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.teal,
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                            elevation: 0,
                          ),
                          child:
                              isLoading
                                  ? const SizedBox(
                                    width: 24,
                                    height: 24,
                                    child: CircularProgressIndicator(
                                      color: Colors.white,
                                      strokeWidth: 2,
                                    ),
                                  )
                                  : const Text(
                                    'Login as Admin',
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                        ),
                      );
                    },
                  ),

                  SizedBox(height: isKeyboardOpen ? 20 : 40),

                  // Debug info (remove in production)
                  if (true) // Set to false in production
                    Container(
                      padding: EdgeInsets.all(16),
                      margin: EdgeInsets.only(top: 20),
                      decoration: BoxDecoration(
                        color: Colors.grey.shade100,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Column(
                        children: [
                          Text(
                            'Default Credentials:',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.grey.shade700,
                            ),
                          ),
                          SizedBox(height: 8),
                          Text(
                            'Admin ID: admin001\nAdmin Pass: admin123\n\nSuper ID: superadmin\nSuper Pass: super123',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Colors.grey.shade600,
                              fontFamily: 'monospace',
                            ),
                          ),
                        ],
                      ),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInputField({
    required TextEditingController controller,
    required FocusNode focusNode,
    required String hintText,
    required IconData icon,
    required double fontSize,
    required bool isSmallScreen,
    bool isPassword = false,
  }) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(
        horizontal: isSmallScreen ? 12 : 16,
        vertical: 4,
      ),
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.shade400,
            offset: const Offset(-4, -4),
            blurRadius: 8,
            spreadRadius: -1,
          ),
          BoxShadow(
            color: Colors.grey.shade300,
            offset: const Offset(4, 4),
            blurRadius: 8,
            spreadRadius: -1,
          ),
          BoxShadow(
            color: Colors.grey.shade200,
            offset: const Offset(0, 0),
            blurRadius: 4,
            spreadRadius: -2,
          ),
        ],
      ),
      child: TextField(
        controller: controller,
        focusNode: focusNode,
        obscureText: isPassword ? _obscurePassword : false,
        style: TextStyle(fontSize: fontSize),
        enableSuggestions: false,
        autocorrect: false,
        keyboardType:
            isPassword ? TextInputType.visiblePassword : TextInputType.text,
        textInputAction:
            isPassword ? TextInputAction.done : TextInputAction.next,
        onSubmitted: (_) {
          if (!isPassword) {
            _passwordFocusNode.requestFocus();
          } else {
            _handleLogin();
          }
        },
        decoration: InputDecoration(
          hintText: hintText,
          hintStyle: TextStyle(color: Colors.grey, fontSize: fontSize),
          border: InputBorder.none,
          contentPadding: EdgeInsets.symmetric(
            vertical: isSmallScreen ? 12 : 16,
          ),
          prefixIcon: Icon(
            icon,
            color: Colors.grey,
            size: isSmallScreen ? 20 : 24,
          ),
          suffixIcon:
              isPassword
                  ? GestureDetector(
                    onTap:
                        () => setState(
                          () => _obscurePassword = !_obscurePassword,
                        ),
                    child: Icon(
                      _obscurePassword
                          ? Icons.visibility_off_outlined
                          : Icons.visibility_outlined,
                      color: Colors.grey,
                      size: isSmallScreen ? 20 : 24,
                    ),
                  )
                  : null,
        ),
      ),
    );
  }

  @override
  void dispose() {
    _userIdController.dispose();
    _passwordController.dispose();
    _userIdFocusNode.dispose();
    _passwordFocusNode.dispose();
    _adminLoginBloc.close();
    super.dispose();
  }
}
