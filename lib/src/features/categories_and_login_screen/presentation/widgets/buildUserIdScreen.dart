import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_cas_app_main/src/features/categories_and_login_screen/presentation/bloc/login_onboarding_bloc.dart';
import 'package:flutter_cas_app_main/src/features/categories_and_login_screen/presentation/bloc/login_onboarding_event.dart';
import 'package:flutter_cas_app_main/src/features/categories_and_login_screen/presentation/bloc/login_onboarding_state.dart';
import 'package:flutter_cas_app_main/src/features/categories_and_login_screen/presentation/widgets/SlideInWidget.dart';
import 'package:flutter_cas_app_main/src/features/categories_and_login_screen/presentation/widgets/StudentLoginScreen.dart';

// ── Design tokens ─────────────────────────────────────────────────────────────

class _T {
  static const pageBg = Color(0xFFF5F5F5);
  static const cardBg = Color(0xFFFFFFFF);
  static const surfaceBg = Color(0xFFEAEAEA);
  static const heroBg = Color(0xFF111111);
  static const inkDeep = Color(0xFF111111);
  static const inkMid = Color(0xFF555555);
  static const inkSoft = Color(0xFFAAAAAA);
  static const divider = Color(0xFFEBEBEB);
  static const focusBorder = Color(0xFF111111);

  // Network image — professional student / learning scene from Unsplash
  // Stable production URL (w=800 for crisp rendering on all densities)
  static const heroImageUrl =
      'https://images.unsplash.com/photo-1522202176988-66273c2fd55f'
      '?w=800&q=80&auto=format&fit=crop';
}

// ── Page ──────────────────────────────────────────────────────────────────────

class UserIdInputScreen extends StatefulWidget {
  const UserIdInputScreen({super.key});

  @override
  _UserIdInputScreenState createState() => _UserIdInputScreenState();
}

class _UserIdInputScreenState extends State<UserIdInputScreen>
    with SingleTickerProviderStateMixin {
  // ── LOGIC UNCHANGED ───────────────────────────────────────────────────────
  final TextEditingController _userIdController = TextEditingController();
  late AnimationController _shakeController;
  late Animation<double> _shakeAnimation;

  @override
  void initState() {
    super.initState();
    _shakeController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );
    _shakeAnimation = Tween(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _shakeController, curve: Curves.elasticIn),
    );
  }

  @override
  void dispose() {
    _userIdController.dispose();
    _shakeController.dispose();
    super.dispose();
  }
  // ── END LOGIC ─────────────────────────────────────────────────────────────

  // Focus tracking for field highlight
  final FocusNode _idFocus = FocusNode();
  bool _isFocused = false;

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light,
      ),
    );

    return Scaffold(
      backgroundColor: _T.pageBg,
      // ── LOGIC UNCHANGED: BlocListener ─────────────────────────────────
      body: BlocListener<OnboardingBloc, OnboardingState>(
        listener: (context, state) {
          if (state is OnboardingInitial && state.shouldShake) {
            _shakeController.forward().then((_) => _shakeController.reset());
          }
        },
        child: Column(
          children: [
            // ── Hero image section ───────────────────────────────────────
            _HeroImage(onBack: () => Navigator.pop(context)),

            // ── Form section ─────────────────────────────────────────────
            Expanded(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(22, 24, 22, 32),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Eyebrow + title
                      SlideInWidget(
                        delay: const Duration(milliseconds: 200),
                        begin: const Offset(0, 0.3),
                        child: const Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'CAS LEARNING',
                              style: TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.w600,
                                letterSpacing: 1.2,
                                color: _T.inkSoft,
                              ),
                            ),
                            SizedBox(height: 6),
                            Text(
                              'Welcome back.',
                              style: TextStyle(
                                fontSize: 28,
                                fontWeight: FontWeight.w800,
                                letterSpacing: -0.7,
                                height: 1.1,
                                color: _T.inkDeep,
                              ),
                            ),
                            SizedBox(height: 8),
                            Text(
                              'Enter your student ID to access\nyour dashboard.',
                              style: TextStyle(
                                fontSize: 14,
                                color: _T.inkSoft,
                                height: 1.55,
                              ),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 28),

                      // ── ID input with shake animation (LOGIC UNCHANGED) ──
                      SlideInWidget(
                        delay: const Duration(milliseconds: 350),
                        begin: const Offset(0, 0.3),
                        child: AnimatedBuilder(
                          animation: _shakeAnimation,
                          builder: (context, child) {
                            return Transform.translate(
                              offset: Offset(
                                10.0 *
                                    _shakeAnimation.value *
                                    (1.0 - _shakeAnimation.value) *
                                    2.0 *
                                    (0.5 - _shakeAnimation.value).sign,
                                0.0,
                              ),
                              child: _IdInputField(
                                controller: _userIdController,
                                focusNode: _idFocus,
                                isFocused: _isFocused,
                                onFocusChange:
                                    (v) => setState(() => _isFocused = v),
                              ),
                            );
                          },
                        ),
                      ),

                      const SizedBox(height: 20),

                      // ── Continue button (LOGIC UNCHANGED) ────────────────
                      SlideInWidget(
                        delay: const Duration(milliseconds: 500),
                        begin: const Offset(0, 0.3),
                        child: _ContinueButton(
                          onTap: () {
                            final userId = _userIdController.text.trim();
                            if (userId.isNotEmpty) {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder:
                                      (context) =>
                                          StudentLoginScreen(studentid: userId),
                                ),
                              );
                            } else {
                              // LOGIC UNCHANGED: shake via bloc
                              context.read<OnboardingBloc>().add(
                                LoginEvent(''),
                              );
                            }
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Hero image ────────────────────────────────────────────────────────────────

class _HeroImage extends StatelessWidget {
  final VoidCallback onBack;
  const _HeroImage({required this.onBack});

  @override
  Widget build(BuildContext context) {
    final topPad = MediaQuery.of(context).padding.top;
    return SizedBox(
      height: 260 + topPad,
      child: Stack(
        fit: StackFit.expand,
        children: [
          // Network image
          ClipRRect(
            borderRadius: const BorderRadius.only(
              bottomLeft: Radius.circular(28),
              bottomRight: Radius.circular(28),
            ),
            child: Image.network(
              _T.heroImageUrl,
              fit: BoxFit.cover,
              alignment: Alignment.topCenter,
              // Fallback while loading or on error
              loadingBuilder: (context, child, loadingProgress) {
                if (loadingProgress == null) return child;
                return Container(
                  color: const Color(0xFF1A1A1A),
                  child: const Center(
                    child: CircularProgressIndicator(
                      strokeWidth: 1.5,
                      color: Colors.white38,
                    ),
                  ),
                );
              },
              errorBuilder:
                  (context, error, stackTrace) => Container(
                    color: _T.heroBg,
                    child: Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            width: 64,
                            height: 64,
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.08),
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.school_rounded,
                              color: Colors.white38,
                              size: 30,
                            ),
                          ),
                          const SizedBox(height: 12),
                          const Text(
                            'CAS Learning System',
                            style: TextStyle(
                              color: Colors.white38,
                              fontSize: 13,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
            ),
          ),

          // Dark overlay at bottom for readability
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            height: 80,
            child: ClipRRect(
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(28),
                bottomRight: Radius.circular(28),
              ),
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.transparent,
                      Colors.black.withOpacity(0.35),
                    ],
                  ),
                ),
              ),
            ),
          ),

          // Back button
          Positioned(
            top: topPad + 12,
            left: 16,
            child: GestureDetector(
              onTap: onBack,
              child: Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.85),
                  shape: BoxShape.circle,
                ),
                child: const Center(
                  child: Icon(
                    Icons.arrow_back_ios_new_rounded,
                    size: 15,
                    color: _T.inkDeep,
                  ),
                ),
              ),
            ),
          ),

          // Bottom label
          Positioned(
            left: 20,
            bottom: 18,
            child: const Text(
              'Student Portal',
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: Colors.white70,
                letterSpacing: 0.3,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ── ID input field ────────────────────────────────────────────────────────────

class _IdInputField extends StatelessWidget {
  final TextEditingController controller;
  final FocusNode focusNode;
  final bool isFocused;
  final ValueChanged<bool> onFocusChange;

  const _IdInputField({
    required this.controller,
    required this.focusNode,
    required this.isFocused,
    required this.onFocusChange,
  });

  @override
  Widget build(BuildContext context) {
    return Focus(
      onFocusChange: onFocusChange,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 11),
        decoration: BoxDecoration(
          color: _T.cardBg,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isFocused ? _T.focusBorder : _T.divider,
            width: isFocused ? 1.5 : 1.0,
          ),
        ),
        child: Row(
          children: [
            // Icon bed
            AnimatedContainer(
              duration: const Duration(milliseconds: 150),
              width: 34,
              height: 34,
              decoration: BoxDecoration(
                color: isFocused ? _T.heroBg : _T.surfaceBg,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Center(
                child: Icon(
                  Icons.person_outline_rounded,
                  size: 16,
                  color: isFocused ? Colors.white : _T.inkMid,
                ),
              ),
            ),
            const SizedBox(width: 12),

            // Label + input stacked
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'STUDENT ID',
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 0.8,
                      color: _T.inkSoft,
                    ),
                  ),
                  const SizedBox(height: 3),
                  TextField(
                    controller: controller,
                    focusNode: focusNode,
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                      color: _T.inkDeep,
                      letterSpacing: -0.1,
                    ),
                    decoration: const InputDecoration(
                      hintText: 'Enter your student ID',
                      hintStyle: TextStyle(
                        fontSize: 14,
                        color: _T.inkSoft,
                        fontWeight: FontWeight.w400,
                      ),
                      border: InputBorder.none,
                      isDense: true,
                      contentPadding: EdgeInsets.zero,
                    ),
                    onSubmitted: (_) => focusNode.unfocus(),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Continue button ───────────────────────────────────────────────────────────

class _ContinueButton extends StatelessWidget {
  final VoidCallback onTap;
  const _ContinueButton({required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        height: 52,
        decoration: BoxDecoration(
          color: _T.heroBg,
          borderRadius: BorderRadius.circular(16),
        ),
        child: const Center(
          child: Text(
            'Continue',
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w700,
              color: Colors.white,
              letterSpacing: 0.1,
            ),
          ),
        ),
      ),
    );
  }
}
