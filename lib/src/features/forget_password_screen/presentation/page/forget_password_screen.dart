// import 'package:flutter/material.dart';
// import 'dart:async';

// import 'package:flutter_cas_app_main/src/auth/data/service/AuthService.dart';

// enum ForgotPasswordStep { email, emailSent }

// class ForgotPasswordScreen extends StatefulWidget {
//   const ForgotPasswordScreen({super.key});

//   @override
//   State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
// }

// class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
//   final _formKey = GlobalKey<FormState>();
//   final _emailController = TextEditingController();
//   final _authService = AuthService();

//   ForgotPasswordStep _currentStep = ForgotPasswordStep.email;
//   bool _isLoading = false;

//   Timer? _resendTimer;
//   int _resendCountdown = 0;
//   bool _canResendEmail = true;

//   @override
//   void dispose() {
//     _emailController.dispose();
//     _resendTimer?.cancel();
//     super.dispose();
//   }

//   // Validator
//   String? _validateEmail(String? value) {
//     if (value == null || value.isEmpty) return 'Please enter your email';
//     final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
//     if (!emailRegex.hasMatch(value)) return 'Please enter a valid email';
//     return null;
//   }

//   // Timer for resend functionality
//   void _startResendTimer() {
//     setState(() {
//       _canResendEmail = false;
//       _resendCountdown = 60;
//     });

//     _resendTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
//       setState(() {
//         if (_resendCountdown > 0) {
//           _resendCountdown--;
//         } else {
//           _canResendEmail = true;
//           timer.cancel();
//         }
//       });
//     });
//   }

//   // Firebase password reset
//   Future<void> _handleEmailSubmit() async {
//     if (_formKey.currentState!.validate()) {
//       setState(() => _isLoading = true);

//       try {
//         final success = await _authService.sendPasswordResetEmail(
//           _emailController.text.trim(),
//         );

//         setState(() => _isLoading = false);

//         if (success) {
//           setState(() => _currentStep = ForgotPasswordStep.emailSent);
//           _startResendTimer();

//           ScaffoldMessenger.of(context).showSnackBar(
//             SnackBar(
//               content: Text(
//                 'Reset link sent to ${_emailController.text.trim()}',
//               ),
//               backgroundColor: Colors.green,
//               behavior: SnackBarBehavior.floating,
//               shape: RoundedRectangleBorder(
//                 borderRadius: BorderRadius.circular(10),
//               ),
//             ),
//           );
//         } else {
//           ScaffoldMessenger.of(context).showSnackBar(
//             SnackBar(
//               content: const Text(
//                 'Failed to send reset email. Please check your email and try again.',
//               ),
//               backgroundColor: Colors.red,
//               behavior: SnackBarBehavior.floating,
//               shape: RoundedRectangleBorder(
//                 borderRadius: BorderRadius.circular(10),
//               ),
//             ),
//           );
//         }
//       } catch (e) {
//         setState(() => _isLoading = false);

//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(
//             content: Text('An unexpected error occurred. Please try again.'),
//             backgroundColor: Colors.red,
//             behavior: SnackBarBehavior.floating,
//             shape: RoundedRectangleBorder(
//               borderRadius: BorderRadius.circular(10),
//             ),
//           ),
//         );
//       }
//     }
//   }

//   Future<void> _handleResendEmail() async {
//     setState(() => _isLoading = true);

//     try {
//       final success = await _authService.sendPasswordResetEmail(
//         _emailController.text.trim(),
//       );

//       setState(() => _isLoading = false);

//       if (success) {
//         _startResendTimer();
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(
//             content: Text('Reset link resent to your email!'),
//             backgroundColor: Colors.blue,
//             behavior: SnackBarBehavior.floating,
//             shape: RoundedRectangleBorder(
//               borderRadius: BorderRadius.circular(10),
//             ),
//           ),
//         );
//       } else {
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(
//             content: Text('Failed to resend email. Please try again.'),
//             backgroundColor: Colors.red,
//             behavior: SnackBarBehavior.floating,
//             shape: RoundedRectangleBorder(
//               borderRadius: BorderRadius.circular(10),
//             ),
//           ),
//         );
//       }
//     } catch (e) {
//       setState(() => _isLoading = false);

//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(
//           content: Text('An unexpected error occurred. Please try again.'),
//           backgroundColor: Colors.red,
//           behavior: SnackBarBehavior.floating,
//           shape: RoundedRectangleBorder(
//             borderRadius: BorderRadius.circular(10),
//           ),
//         ),
//       );
//     }
//   }

//   String _getTitle() {
//     switch (_currentStep) {
//       case ForgotPasswordStep.email:
//         return 'Forgot Password';
//       case ForgotPasswordStep.emailSent:
//         return 'Check Your Email';
//     }
//   }

//   String _getSubtitle() {
//     switch (_currentStep) {
//       case ForgotPasswordStep.email:
//         return 'Enter your email to receive reset instructions';
//       case ForgotPasswordStep.emailSent:
//         return 'We sent a password reset link to ${_emailController.text.trim()}';
//     }
//   }

//   Widget _buildCurrentStep() {
//     switch (_currentStep) {
//       case ForgotPasswordStep.email:
//         return _buildEmailStep();
//       case ForgotPasswordStep.emailSent:
//         return _buildEmailSentStep();
//     }
//   }

//   Widget _buildEmailStep() {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.stretch,
//       children: [
//         // Email icon
//         Container(
//           width: 80,
//           height: 80,
//           margin: const EdgeInsets.only(bottom: 32),
//           decoration: BoxDecoration(
//             color: Colors.blue.shade100,
//             borderRadius: BorderRadius.circular(40),
//           ),
//           child: Icon(
//             Icons.email_outlined,
//             size: 40,
//             color: Colors.blue.shade600,
//           ),
//         ),

//         // Email input field
//         TextFormField(
//           controller: _emailController,
//           keyboardType: TextInputType.emailAddress,
//           validator: _validateEmail,
//           decoration: InputDecoration(
//             labelText: 'Email',
//             hintText: 'Enter your email',
//             prefixIcon: const Icon(Icons.email_outlined),
//             border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
//             enabledBorder: OutlineInputBorder(
//               borderRadius: BorderRadius.circular(12),
//               borderSide: BorderSide(color: Colors.grey.shade300),
//             ),
//             focusedBorder: OutlineInputBorder(
//               borderRadius: BorderRadius.circular(12),
//               borderSide: BorderSide(color: Colors.blue.shade600),
//             ),
//             errorBorder: OutlineInputBorder(
//               borderRadius: BorderRadius.circular(12),
//               borderSide: const BorderSide(color: Colors.red),
//             ),
//             focusedErrorBorder: OutlineInputBorder(
//               borderRadius: BorderRadius.circular(12),
//               borderSide: const BorderSide(color: Colors.red),
//             ),
//           ),
//         ),

//         const SizedBox(height: 32),

//         // Send reset link button
//         SizedBox(
//           height: 48,
//           child: ElevatedButton(
//             onPressed: _isLoading ? null : _handleEmailSubmit,
//             style: ElevatedButton.styleFrom(
//               backgroundColor: Colors.blue.shade600,
//               foregroundColor: Colors.white,
//               shape: RoundedRectangleBorder(
//                 borderRadius: BorderRadius.circular(12),
//               ),
//               elevation: 2,
//             ),
//             child:
//                 _isLoading
//                     ? const SizedBox(
//                       width: 20,
//                       height: 20,
//                       child: CircularProgressIndicator(
//                         strokeWidth: 2,
//                         valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
//                       ),
//                     )
//                     : const Text(
//                       'Send Reset Link',
//                       style: TextStyle(
//                         fontSize: 16,
//                         fontWeight: FontWeight.w600,
//                       ),
//                     ),
//           ),
//         ),
//       ],
//     );
//   }

//   Widget _buildEmailSentStep() {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.stretch,
//       children: [
//         // Success icon
//         Container(
//           width: 80,
//           height: 80,
//           margin: const EdgeInsets.only(bottom: 32),
//           decoration: BoxDecoration(
//             color: Colors.green.shade100,
//             borderRadius: BorderRadius.circular(40),
//           ),
//           child: Icon(
//             Icons.mark_email_read_outlined,
//             size: 40,
//             color: Colors.green.shade600,
//           ),
//         ),

//         // Instructions
//         Container(
//           padding: const EdgeInsets.all(16),
//           margin: const EdgeInsets.only(bottom: 24),
//           decoration: BoxDecoration(
//             color: Colors.blue.shade50,
//             borderRadius: BorderRadius.circular(12),
//             border: Border.all(color: Colors.blue.shade100),
//           ),
//           child: Column(
//             children: [
//               Icon(Icons.info_outline, color: Colors.blue.shade600, size: 24),
//               const SizedBox(height: 8),
//               Text(
//                 'Click the link in your email to reset your password. The link will expire in 1 hour.',
//                 style: TextStyle(color: Colors.blue.shade700, fontSize: 14),
//                 textAlign: TextAlign.center,
//               ),
//             ],
//           ),
//         ),

//         // Resend email section
//         Container(
//           padding: const EdgeInsets.all(16),
//           decoration: BoxDecoration(
//             color: Colors.grey.shade50,
//             borderRadius: BorderRadius.circular(12),
//           ),
//           child: Column(
//             children: [
//               Text(
//                 "Didn't receive the email?",
//                 style: TextStyle(color: Colors.grey.shade700, fontSize: 14),
//               ),
//               const SizedBox(height: 8),
//               Text(
//                 'Check your spam folder or',
//                 style: TextStyle(color: Colors.grey.shade600, fontSize: 12),
//               ),
//               const SizedBox(height: 12),
//               GestureDetector(
//                 onTap:
//                     _canResendEmail && !_isLoading ? _handleResendEmail : null,
//                 child: Text(
//                   _canResendEmail
//                       ? 'Resend Email'
//                       : 'Resend in ${_resendCountdown}s',
//                   style: TextStyle(
//                     color:
//                         _canResendEmail
//                             ? Colors.blue.shade600
//                             : Colors.grey.shade500,
//                     fontWeight: FontWeight.w600,
//                     fontSize: 14,
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         ),

//         const SizedBox(height: 32),

//         // Back to login button
//         SizedBox(
//           height: 48,
//           child: ElevatedButton(
//             onPressed: () => Navigator.of(context).pop(),
//             style: ElevatedButton.styleFrom(
//               backgroundColor: Colors.grey.shade100,
//               foregroundColor: Colors.blue.shade600,
//               shape: RoundedRectangleBorder(
//                 borderRadius: BorderRadius.circular(12),
//                 side: BorderSide(color: Colors.blue.shade600),
//               ),
//               elevation: 0,
//             ),
//             child: const Text(
//               'Back to Login',
//               style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
//             ),
//           ),
//         ),

//         const SizedBox(height: 16),

//         // Try different email button
//         TextButton(
//           onPressed: () {
//             setState(() {
//               _currentStep = ForgotPasswordStep.email;
//               _emailController.clear();
//               _resendTimer?.cancel();
//             });
//           },
//           child: Text(
//             'Try a different email',
//             style: TextStyle(color: Colors.grey.shade600, fontSize: 14),
//           ),
//         ),
//       ],
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.white,
//       appBar: AppBar(
//         backgroundColor: Colors.transparent,
//         elevation: 0,
//         leading: IconButton(
//           icon: Icon(Icons.arrow_back_ios, color: Colors.grey.shade700),
//           onPressed: () => Navigator.of(context).pop(),
//         ),
//       ),
//       body: SafeArea(
//         child: SingleChildScrollView(
//           padding: const EdgeInsets.all(24),
//           child: Form(
//             key: _formKey,
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.stretch,
//               children: [
//                 const SizedBox(height: 40),

//                 Text(
//                   _getTitle(),
//                   style: Theme.of(context).textTheme.headlineLarge?.copyWith(
//                     fontWeight: FontWeight.bold,
//                     color: Colors.grey.shade800,
//                   ),
//                   textAlign: TextAlign.center,
//                 ),

//                 const SizedBox(height: 8),

//                 Text(
//                   _getSubtitle(),
//                   style: Theme.of(context).textTheme.titleMedium?.copyWith(
//                     color: Colors.grey.shade600,
//                   ),
//                   textAlign: TextAlign.center,
//                 ),

//                 const SizedBox(height: 48),

//                 _buildCurrentStep(),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:async';
import 'package:google_fonts/google_fonts.dart';

import 'package:flutter_cas_app_main/src/auth/data/service/AuthService.dart';

// ══════════════════════════════════════════════════════════════════════════════
// PALETTE — matches home page _Ink tokens exactly
// ══════════════════════════════════════════════════════════════════════════════

class _Ink {
  static const pageBg = Color(0xFFF9F7F4);
  static const inkDeep = Color(0xFF1C1A17);
  static const inkMid = Color(0xFF5A5550);
  static const inkSoft = Color(0xFF8C8680);
  static const inkFaint = Color(0xFFB5B0A8);
  static const divider = Color(0xFFDDD9D3);
  static const sand = Color(0xFFEDE9E4);
  static const sandBed = Color(0xFFC8BCA8);
  static const sandStroke = Color(0xFF6B5C44);

  // Success tones
  static const sageLight = Color(0xFFE4EDE7);
  static const sageBed = Color(0xFFB5CDB9);
  static const sageDeep = Color(0xFF3B6B44);
}

// ══════════════════════════════════════════════════════════════════════════════
// STEP ENUM — LOGIC UNCHANGED
// ══════════════════════════════════════════════════════════════════════════════

enum ForgotPasswordStep { email, emailSent }

// ══════════════════════════════════════════════════════════════════════════════
// FORGOT PASSWORD SCREEN
// ══════════════════════════════════════════════════════════════════════════════

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen>
    with TickerProviderStateMixin {
  // ── LOGIC UNCHANGED ───────────────────────────────────────────────────────
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _authService = AuthService();

  ForgotPasswordStep _currentStep = ForgotPasswordStep.email;
  bool _isLoading = false;

  Timer? _resendTimer;
  int _resendCountdown = 0;
  bool _canResendEmail = true;

  @override
  void dispose() {
    _emailController.dispose();
    _resendTimer?.cancel();
    _entryCtrl.dispose();
    _stepCtrl.dispose();
    _emailFocus.dispose();
    super.dispose();
  }

  String? _validateEmail(String? value) {
    if (value == null || value.isEmpty) return 'Please enter your email';
    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    if (!emailRegex.hasMatch(value)) return 'Please enter a valid email';
    return null;
  }

  void _startResendTimer() {
    setState(() {
      _canResendEmail = false;
      _resendCountdown = 60;
    });
    _resendTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        if (_resendCountdown > 0) {
          _resendCountdown--;
        } else {
          _canResendEmail = true;
          timer.cancel();
        }
      });
    });
  }

  Future<void> _handleEmailSubmit() async {
    if (_formKey.currentState!.validate()) {
      setState(() => _isLoading = true);
      try {
        final success = await _authService.sendPasswordResetEmail(
          _emailController.text.trim(),
        );
        setState(() => _isLoading = false);
        if (success) {
          setState(() => _currentStep = ForgotPasswordStep.emailSent);
          _stepCtrl.forward(from: 0);
          _startResendTimer();
          _showSnack(
            'Reset link sent to ${_emailController.text.trim()}',
            success: true,
          );
        } else {
          _showSnack(
            'Failed to send reset email. Please check your email.',
            success: false,
          );
        }
      } catch (e) {
        setState(() => _isLoading = false);
        _showSnack('Something went wrong. Please try again.', success: false);
      }
    }
  }

  Future<void> _handleResendEmail() async {
    setState(() => _isLoading = true);
    try {
      final success = await _authService.sendPasswordResetEmail(
        _emailController.text.trim(),
      );
      setState(() => _isLoading = false);
      if (success) {
        _startResendTimer();
        _showSnack('Reset link resent to your email.', success: true);
      } else {
        _showSnack('Failed to resend email. Please try again.', success: false);
      }
    } catch (e) {
      setState(() => _isLoading = false);
      _showSnack('Something went wrong. Please try again.', success: false);
    }
  }

  void _showSnack(String message, {required bool success}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          message,
          style: const TextStyle(
            color: Color(0xFFF9F7F4),
            fontSize: 13,
            fontWeight: FontWeight.w500,
          ),
        ),
        backgroundColor: success ? _Ink.sageDeep : const Color(0xFFA32D2D),
        behavior: SnackBarBehavior.floating,
        margin: const EdgeInsets.all(16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        duration: const Duration(seconds: 3),
      ),
    );
  }
  // ── END LOGIC ─────────────────────────────────────────────────────────────

  // ── Animation controllers (UI only) ──────────────────────────────────────
  late final AnimationController _entryCtrl = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 900),
  )..forward();

  late final AnimationController _stepCtrl = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 600),
  );

  final FocusNode _emailFocus = FocusNode();
  bool _emailFocused = false;

  @override
  void initState() {
    super.initState();
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark,
      ),
    );
    _emailFocus.addListener(
      () => setState(() => _emailFocused = _emailFocus.hasFocus),
    );
  }

  // ══════════════════════════════════════════════════════════════════════════
  // BUILD
  // ══════════════════════════════════════════════════════════════════════════

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _Ink.pageBg,
      body: SafeArea(
        child: FadeTransition(
          opacity: CurvedAnimation(parent: _entryCtrl, curve: Curves.easeOut),
          child: SlideTransition(
            position: Tween<Offset>(
              begin: const Offset(0, 0.04),
              end: Offset.zero,
            ).animate(
              CurvedAnimation(parent: _entryCtrl, curve: Curves.easeOutCubic),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // ── Editorial banner ───────────────────────────────────
                _EditionBanner(onBack: () => Navigator.of(context).pop()),

                // ── Hairline ───────────────────────────────────────────
                const Divider(height: 1, thickness: 0.8, color: _Ink.divider),

                // ── Hero network image ─────────────────────────────────
                _HeroImageBlock(step: _currentStep),

                // ── Double rule ────────────────────────────────────────
                const _DoubleRule(),

                // ── Scrollable form body ───────────────────────────────
                Expanded(
                  child: SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    child: Form(
                      key: _formKey,
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(24, 20, 24, 40),
                        child: AnimatedSwitcher(
                          duration: const Duration(milliseconds: 400),
                          switchInCurve: Curves.easeOut,
                          switchOutCurve: Curves.easeIn,
                          transitionBuilder:
                              (child, anim) => FadeTransition(
                                opacity: anim,
                                child: SlideTransition(
                                  position: Tween<Offset>(
                                    begin: const Offset(0.05, 0),
                                    end: Offset.zero,
                                  ).animate(anim),
                                  child: child,
                                ),
                              ),
                          child:
                              _currentStep == ForgotPasswordStep.email
                                  ? _EmailStepBody(
                                    key: const ValueKey('email'),
                                    emailController: _emailController,
                                    emailFocus: _emailFocus,
                                    emailFocused: _emailFocused,
                                    isLoading: _isLoading,
                                    onSubmit: _handleEmailSubmit,
                                    validateEmail: _validateEmail,
                                  )
                                  : _EmailSentBody(
                                    key: const ValueKey('sent'),
                                    email: _emailController.text.trim(),
                                    isLoading: _isLoading,
                                    canResend: _canResendEmail,
                                    countdown: _resendCountdown,
                                    onResend: _handleResendEmail,
                                    onTryDifferent: () {
                                      setState(() {
                                        _currentStep = ForgotPasswordStep.email;
                                        _emailController.clear();
                                        _resendTimer?.cancel();
                                      });
                                      _entryCtrl.forward(from: 0.4);
                                    },
                                    onBack: () => Navigator.of(context).pop(),
                                  ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// ══════════════════════════════════════════════════════════════════════════════
// EDITION BANNER — top bar with tag pill + back button
// ══════════════════════════════════════════════════════════════════════════════

class _EditionBanner extends StatelessWidget {
  final VoidCallback onBack;
  const _EditionBanner({required this.onBack});

  String get _dateString {
    final now = DateTime.now();
    const days = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
    const months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];
    return '${days[now.weekday - 1]}, ${now.day} ${months[now.month - 1]} ${now.year}';
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 14, 24, 14),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Tag pill
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              border: Border.all(color: _Ink.divider),
              borderRadius: BorderRadius.circular(3),
            ),
            child: const Text(
              'ACCOUNT ACCESS',
              style: TextStyle(
                fontSize: 9,
                letterSpacing: 1.6,
                fontWeight: FontWeight.w500,
                color: _Ink.inkSoft,
              ),
            ),
          ),
          Row(
            children: [
              Text(
                _dateString,
                style: const TextStyle(
                  fontSize: 11,
                  color: _Ink.inkSoft,
                  letterSpacing: 0.2,
                ),
              ),
              const SizedBox(width: 12),
              GestureDetector(
                onTap: onBack,
                child: Container(
                  width: 32,
                  height: 32,
                  decoration: BoxDecoration(
                    color: _Ink.sand,
                    shape: BoxShape.circle,
                    border: Border.all(color: _Ink.divider),
                  ),
                  child: const Icon(
                    Icons.arrow_back_ios_new_rounded,
                    size: 13,
                    color: _Ink.inkMid,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// ══════════════════════════════════════════════════════════════════════════════
// HERO IMAGE BLOCK — context-aware network image with greeting
// ══════════════════════════════════════════════════════════════════════════════

class _HeroImageBlock extends StatelessWidget {
  final ForgotPasswordStep step;
  const _HeroImageBlock({required this.step});

  // Curated, context-appropriate Unsplash images
  static const _emailImg =
      'https://images.unsplash.com/photo-1596526131083-e8c633c948d2'
      '?w=800&q=75&auto=format&fit=crop'; // clean envelope on desk

  static const _sentImg =
      'https://images.unsplash.com/photo-1557200134-90327ee9fafa'
      '?w=800&q=75&auto=format&fit=crop'; // phone with message notification

  @override
  Widget build(BuildContext context) {
    final url = step == ForgotPasswordStep.email ? _emailImg : _sentImg;
    final eyebrow =
        step == ForgotPasswordStep.email ? 'RESET PASSWORD' : 'EMAIL SENT';
    final headline =
        step == ForgotPasswordStep.email
            ? 'Forgot\nyour password?'
            : 'Check your\ninbox.';

    return SizedBox(
      height: 180,
      child: Stack(
        fit: StackFit.expand,
        children: [
          // Image
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 500),
            child: Image.network(
              url,
              key: ValueKey(url),
              fit: BoxFit.cover,
              alignment: Alignment.center,
              loadingBuilder: (context, child, progress) {
                if (progress == null) return child;
                return Container(color: _Ink.sand);
              },
              errorBuilder:
                  (_, __, ___) => Container(
                    color: _Ink.inkDeep,
                    child: Center(
                      child: Icon(
                        step == ForgotPasswordStep.email
                            ? Icons.lock_reset_rounded
                            : Icons.mark_email_read_outlined,
                        size: 40,
                        color: Colors.white24,
                      ),
                    ),
                  ),
            ),
          ),

          // Gradient scrim — left-side for text legibility
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
                colors: [Color(0xCC1C1A17), Colors.transparent],
                stops: [0.0, 0.75],
              ),
            ),
          ),

          // Text over image
          Positioned(
            left: 20,
            bottom: 16,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  eyebrow,
                  style: const TextStyle(
                    fontSize: 9,
                    letterSpacing: 1.8,
                    fontWeight: FontWeight.w500,
                    color: Color(0xFF8C8680),
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  headline,
                  style: GoogleFonts.dmSerifDisplay(
                    fontSize: 26,
                    color: const Color(0xFFF9F7F4),
                    height: 1.1,
                    fontStyle: FontStyle.italic,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ══════════════════════════════════════════════════════════════════════════════
// DOUBLE RULE — same as home page
// ══════════════════════════════════════════════════════════════════════════════

class _DoubleRule extends StatelessWidget {
  const _DoubleRule();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        children: [
          Container(height: 2.5, color: _Ink.inkDeep),
          const SizedBox(height: 3),
          Row(
            children: [
              Expanded(child: Container(height: 0.8, color: _Ink.divider)),
              const SizedBox(width: 6),
              Expanded(child: Container(height: 0.8, color: _Ink.divider)),
            ],
          ),
        ],
      ),
    );
  }
}

// ══════════════════════════════════════════════════════════════════════════════
// STEP 1 — EMAIL INPUT BODY
// ══════════════════════════════════════════════════════════════════════════════

class _EmailStepBody extends StatelessWidget {
  final TextEditingController emailController;
  final FocusNode emailFocus;
  final bool emailFocused;
  final bool isLoading;
  final VoidCallback onSubmit;
  final String? Function(String?) validateEmail;

  const _EmailStepBody({
    super.key,
    required this.emailController,
    required this.emailFocus,
    required this.emailFocused,
    required this.isLoading,
    required this.onSubmit,
    required this.validateEmail,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Eyebrow + headline
        const Text(
          'ENTER YOUR EMAIL',
          style: TextStyle(
            fontSize: 9,
            letterSpacing: 1.6,
            fontWeight: FontWeight.w500,
            color: _Ink.inkSoft,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'We\'ll send you a\nreset link.',
          style: GoogleFonts.dmSerifDisplay(
            fontSize: 30,
            color: _Ink.inkDeep,
            height: 1.1,
          ),
        ),
        const SizedBox(height: 6),
        const Text(
          'Enter the email address associated with your\nCAS Learning account.',
          style: TextStyle(fontSize: 12.5, color: _Ink.inkSoft, height: 1.55),
        ),

        const SizedBox(height: 28),

        // Email field — editorial style matching login screen
        _EditorialField(
          controller: emailController,
          focusNode: emailFocus,
          isFocused: emailFocused,
          label: 'Email address',
          hint: 'your@email.com',
          icon: Icons.alternate_email_rounded,
          keyboardType: TextInputType.emailAddress,
          validator: validateEmail,
        ),

        const SizedBox(height: 24),

        // Submit button
        _DarkButton(
          label: 'Send reset link',
          isLoading: isLoading,
          onTap: onSubmit,
        ),
      ],
    );
  }
}

// ══════════════════════════════════════════════════════════════════════════════
// STEP 2 — EMAIL SENT BODY
// ══════════════════════════════════════════════════════════════════════════════

class _EmailSentBody extends StatelessWidget {
  final String email;
  final bool isLoading;
  final bool canResend;
  final int countdown;
  final VoidCallback onResend;
  final VoidCallback onTryDifferent;
  final VoidCallback onBack;

  const _EmailSentBody({
    super.key,
    required this.email,
    required this.isLoading,
    required this.canResend,
    required this.countdown,
    required this.onResend,
    required this.onTryDifferent,
    required this.onBack,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Eyebrow + headline
        const Text(
          'LINK DISPATCHED',
          style: TextStyle(
            fontSize: 9,
            letterSpacing: 1.6,
            fontWeight: FontWeight.w500,
            color: _Ink.inkSoft,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'Now check\nyour inbox.',
          style: GoogleFonts.dmSerifDisplay(
            fontSize: 30,
            color: _Ink.inkDeep,
            height: 1.1,
          ),
        ),
        const SizedBox(height: 6),
        RichText(
          text: TextSpan(
            style: const TextStyle(
              fontSize: 12.5,
              color: _Ink.inkSoft,
              height: 1.55,
            ),
            children: [
              const TextSpan(text: 'A reset link was sent to\n'),
              TextSpan(
                text: email,
                style: const TextStyle(
                  color: _Ink.inkDeep,
                  fontWeight: FontWeight.w600,
                  fontStyle: FontStyle.italic,
                ),
              ),
              const TextSpan(text: '. The link expires in 1 hour.'),
            ],
          ),
        ),

        const SizedBox(height: 28),

        // Info card — editorial styled
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: _Ink.sageLight,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: _Ink.sageBed, width: 0.8),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 28,
                height: 28,
                decoration: BoxDecoration(
                  color: _Ink.sageBed,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(
                  Icons.info_outline_rounded,
                  size: 14,
                  color: _Ink.sageDeep,
                ),
              ),
              const SizedBox(width: 12),
              const Expanded(
                child: Text(
                  'Check your spam folder if you don\'t see it within a few minutes.',
                  style: TextStyle(
                    fontSize: 12,
                    color: _Ink.sageDeep,
                    height: 1.5,
                  ),
                ),
              ),
            ],
          ),
        ),

        const SizedBox(height: 16),

        // Resend row — editorial inline link style
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          decoration: BoxDecoration(
            color: _Ink.sand,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: _Ink.divider, width: 0.8),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Didn\'t receive it?',
                style: TextStyle(fontSize: 12.5, color: _Ink.inkSoft),
              ),
              GestureDetector(
                onTap: canResend && !isLoading ? onResend : null,
                child: AnimatedDefaultTextStyle(
                  duration: const Duration(milliseconds: 200),
                  style: TextStyle(
                    fontSize: 12.5,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 0.1,
                    color: canResend ? _Ink.inkDeep : _Ink.inkFaint,
                  ),
                  child: Text(
                    canResend ? 'Resend link →' : 'Resend in ${countdown}s',
                  ),
                ),
              ),
            ],
          ),
        ),

        const SizedBox(height: 28),

        // Back to login — primary dark button
        _DarkButton(label: 'Back to login', isLoading: false, onTap: onBack),

        const SizedBox(height: 12),

        // Try different email — ghost style
        Center(
          child: GestureDetector(
            onTap: onTryDifferent,
            child: const Padding(
              padding: EdgeInsets.symmetric(vertical: 8),
              child: Text(
                'Try a different email',
                style: TextStyle(
                  fontSize: 12.5,
                  color: _Ink.inkSoft,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

// ══════════════════════════════════════════════════════════════════════════════
// EDITORIAL FIELD — matches login screen _InputField pattern
// ══════════════════════════════════════════════════════════════════════════════

class _EditorialField extends StatelessWidget {
  final TextEditingController controller;
  final FocusNode focusNode;
  final bool isFocused;
  final String label;
  final String hint;
  final IconData icon;
  final TextInputType keyboardType;
  final String? Function(String?)? validator;

  const _EditorialField({
    required this.controller,
    required this.focusNode,
    required this.isFocused,
    required this.label,
    required this.hint,
    required this.icon,
    this.keyboardType = TextInputType.text,
    this.validator,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 150),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isFocused ? _Ink.inkDeep : _Ink.divider,
          width: isFocused ? 1.5 : 0.8,
        ),
      ),
      child: Row(
        children: [
          // Icon bed
          AnimatedContainer(
            duration: const Duration(milliseconds: 150),
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: isFocused ? _Ink.inkDeep : _Ink.sand,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Center(
              child: Icon(
                icon,
                size: 15,
                color: isFocused ? Colors.white : _Ink.inkMid,
              ),
            ),
          ),
          const SizedBox(width: 12),

          // Label + field
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label.toUpperCase(),
                  style: const TextStyle(
                    fontSize: 9,
                    letterSpacing: 1.0,
                    fontWeight: FontWeight.w600,
                    color: _Ink.inkSoft,
                  ),
                ),
                const SizedBox(height: 3),
                TextFormField(
                  controller: controller,
                  focusNode: focusNode,
                  keyboardType: keyboardType,
                  validator: validator,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: _Ink.inkDeep,
                    letterSpacing: -0.1,
                  ),
                  decoration: InputDecoration(
                    hintText: hint,
                    hintStyle: const TextStyle(
                      fontSize: 13,
                      color: _Ink.inkFaint,
                      fontWeight: FontWeight.w400,
                    ),
                    border: InputBorder.none,
                    isDense: true,
                    contentPadding: EdgeInsets.zero,
                    errorStyle: const TextStyle(
                      fontSize: 10,
                      color: Color(0xFFA32D2D),
                      height: 1.3,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ══════════════════════════════════════════════════════════════════════════════
// DARK BUTTON — matches home page / attendance page button style
// ══════════════════════════════════════════════════════════════════════════════

class _DarkButton extends StatefulWidget {
  final String label;
  final bool isLoading;
  final VoidCallback? onTap;

  const _DarkButton({
    required this.label,
    required this.isLoading,
    required this.onTap,
  });

  @override
  State<_DarkButton> createState() => _DarkButtonState();
}

class _DarkButtonState extends State<_DarkButton> {
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => setState(() => _pressed = true),
      onTapUp: (_) {
        setState(() => _pressed = false);
        widget.onTap?.call();
      },
      onTapCancel: () => setState(() => _pressed = false),
      child: AnimatedScale(
        scale: _pressed ? 0.97 : 1.0,
        duration: const Duration(milliseconds: 110),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 150),
          width: double.infinity,
          height: 52,
          decoration: BoxDecoration(
            color: widget.isLoading ? _Ink.inkMid : _Ink.inkDeep,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Center(
            child:
                widget.isLoading
                    ? const SizedBox(
                      width: 18,
                      height: 18,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: Color(0xFF8C8680),
                      ),
                    )
                    : Text(
                      widget.label,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFFF9F7F4),
                        letterSpacing: 0.2,
                      ),
                    ),
          ),
        ),
      ),
    );
  }
}
