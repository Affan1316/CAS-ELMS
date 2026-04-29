// ══════════════════════════════════════════════════════════════════════════════
// REDESIGNED: RoleSelectionScreen
// Designer note: Full UI facelift — zero logic changes.
// Philosophy: "Frosted glass meets warm teal" — premium, calm, intentional.
// ══════════════════════════════════════════════════════════════════════════════

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_cas_app_main/src/features/admin_login_screen/presentation/page/admin_login_page.dart';
import 'package:flutter_cas_app_main/src/features/categories_and_login_screen/presentation/bloc/login_onboarding_bloc.dart';
import 'package:flutter_cas_app_main/src/features/categories_and_login_screen/presentation/bloc/login_onboarding_event.dart';
import 'package:flutter_cas_app_main/src/features/categories_and_login_screen/presentation/bloc/login_onboarding_state.dart';
import 'package:flutter_cas_app_main/src/features/categories_and_login_screen/presentation/widgets/buildStudentAvatar.dart';
import 'package:flutter_cas_app_main/src/features/categories_and_login_screen/presentation/widgets/buildTeacherAvatar.dart';
import 'package:flutter_cas_app_main/src/features/categories_and_login_screen/presentation/widgets/buildUserIdScreen.dart';

// ── Design Tokens ─────────────────────────────────────────────────────────────

class _DS {
  // Core palette — derived from existing app teal + white
  static const bgTop = Color(0xFFD8F0EF); // existing teal bg (preserved)
  static const bgBottom = Color(0xFFF5FAFA); // warm off-white
  static const tealCore = Color(0xFF26B5AE); // richer teal for interactive
  static const tealLight = Color(0xFF4DD0C9); // button / selected ring
  static const tealFaint = Color(0xFFE2F7F6); // card bg when selected
  static const ink = Color(0xFF0F2526); // near-black for text
  static const inkMid = Color(0xFF4A6366); // secondary text
  static const inkFaint = Color(0xFF8FADB0); // hint / label
  static const surface = Color(0xFFFFFFFF); // card surface
  static const divider = Color(0xFFD4ECEC);

  // Elevation — single consistent shadow recipe
  static List<BoxShadow> cardShadow = [
    BoxShadow(
      color: const Color(0xFF26B5AE).withValues(alpha: 0.08),
      blurRadius: 24,
      offset: const Offset(0, 8),
    ),
    BoxShadow(
      color: Colors.black.withValues(alpha: 0.04),
      blurRadius: 8,
      offset: const Offset(0, 2),
    ),
  ];

  static List<BoxShadow> cardShadowSelected = [
    BoxShadow(
      color: const Color(0xFF26B5AE).withValues(alpha: 0.22),
      blurRadius: 32,
      offset: const Offset(0, 10),
    ),
  ];

  static List<BoxShadow> buttonShadow = [
    BoxShadow(
      color: const Color(0xFF26B5AE).withValues(alpha: 0.38),
      blurRadius: 20,
      offset: const Offset(0, 8),
    ),
  ];
}

// ══════════════════════════════════════════════════════════════════════════════
// MAIN SCREEN — only build() changed, all BLoC/nav logic preserved exactly
// ══════════════════════════════════════════════════════════════════════════════

class RoleSelectionScreen extends StatelessWidget {
  const RoleSelectionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // ── Preserved: same status bar overlay ──────────────────────────────────
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark,
      ),
    );

    return Scaffold(
      backgroundColor: _DS.bgBottom,
      body: BlocBuilder<OnboardingBloc, OnboardingState>(
        builder: (context, state) {
          // ── Preserved: exact same state cast ────────────────────────────
          final currentState =
              state is OnboardingInitial ? state : OnboardingInitial();
          return _RedesignedBody(state: currentState);
        },
      ),
    );
  }

  // ── Preserved: exact navigation logic, untouched ────────────────────────
  static void navigateToLogin(BuildContext context, String role) {
    if (role == 'Teacher') {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => AdminLoginScreen()),
      );
    } else {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => UserIdInputScreen()),
      );
    }
  }
}

// ══════════════════════════════════════════════════════════════════════════════
// REDESIGNED BODY
// ══════════════════════════════════════════════════════════════════════════════

class _RedesignedBody extends StatefulWidget {
  final OnboardingInitial state;
  const _RedesignedBody({required this.state});

  @override
  State<_RedesignedBody> createState() => _RedesignedBodyState();
}

class _RedesignedBodyState extends State<_RedesignedBody>
    with TickerProviderStateMixin {
  late final AnimationController _enterCtrl;
  late final Animation<double> _fadeIn;
  late final Animation<Offset> _slideUp;

  @override
  void initState() {
    super.initState();
    _enterCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    );
    _fadeIn = CurvedAnimation(parent: _enterCtrl, curve: Curves.easeOut);
    _slideUp = Tween<Offset>(
      begin: const Offset(0, 0.06),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _enterCtrl, curve: Curves.easeOutCubic));
    _enterCtrl.forward();
  }

  @override
  void dispose() {
    _enterCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final mq = MediaQuery.of(context);
    final h = mq.size.height;
    final top = mq.padding.top;

    return FadeTransition(
      opacity: _fadeIn,
      child: SlideTransition(
        position: _slideUp,
        child: Stack(
          children: [
            // ── Background: soft gradient arch (replaces flat teal rect) ──
            _GradientArch(topInset: top),

            // ── Subtle dot-grid texture — depth without noise ──────────────
            Positioned.fill(child: _DotGrid()),

            // ── Main content ──────────────────────────────────────────────
            SafeArea(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(height: h * 0.04),

                  // Logo mark
                  _CasLogo(),

                  SizedBox(height: h * 0.032),

                  // Headline
                  _Headline(),

                  SizedBox(height: h * 0.048),

                  // Role cards — side by side, equal weight
                  Expanded(child: _RoleCardRow(state: widget.state)),

                  SizedBox(height: h * 0.028),

                  // CTA Button
                  _ContinueButton(state: widget.state),

                  SizedBox(height: h * 0.04),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ══════════════════════════════════════════════════════════════════════════════
// BACKGROUND COMPONENTS
// ══════════════════════════════════════════════════════════════════════════════

class _GradientArch extends StatelessWidget {
  final double topInset;
  const _GradientArch({required this.topInset});

  @override
  Widget build(BuildContext context) {
    final h = MediaQuery.of(context).size.height;
    return Positioned(
      top: 0,
      left: 0,
      right: 0,
      child: Container(
        height: h * 0.50,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFFC2EAE8), // slightly cooler at top-left
              Color(0xFFD8F0EF), // existing teal bg — preserved
              Color(0xFFE8F8F7), // feathers into white
            ],
            stops: [0.0, 0.55, 1.0],
          ),
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(48),
            bottomRight: Radius.circular(48),
          ),
        ),
      ),
    );
  }
}

class _DotGrid extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return CustomPaint(painter: _DotGridPainter());
  }
}

class _DotGridPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint =
        Paint()
          ..color = const Color(0xFF26B5AE).withValues(alpha: 0.055)
          ..strokeCap = StrokeCap.round
          ..style = PaintingStyle.fill;

    const gap = 28.0;
    const r = 1.4;
    for (double x = gap; x < size.width; x += gap) {
      for (double y = gap; y < size.height * 0.50; y += gap) {
        canvas.drawCircle(Offset(x, y), r, paint);
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

// ══════════════════════════════════════════════════════════════════════════════
// LOGO MARK — premium app identity touch
// ══════════════════════════════════════════════════════════════════════════════

class _CasLogo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: 52,
          height: 52,
          decoration: BoxDecoration(
            color: _DS.tealCore,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: _DS.tealCore.withValues(alpha: 0.35),
                blurRadius: 18,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: const Center(
            child: Text(
              'CAS',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w800,
                color: Colors.white,
                letterSpacing: 1.2,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

// ══════════════════════════════════════════════════════════════════════════════
// HEADLINE — clean typographic hierarchy
// ══════════════════════════════════════════════════════════════════════════════

class _Headline extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 32),
      child: Column(
        children: [
          const Text(
            'Join CAS as a...',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 30,
              fontWeight: FontWeight.w700,
              color: _DS.ink,
              letterSpacing: -0.5,
              height: 1.1,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            'Create and deliver courses as a Teacher,\nor learn and grow as a Student.',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 14.5,
              color: _DS.inkMid,
              height: 1.6,
              fontWeight: FontWeight.w400,
            ),
          ),
        ],
      ),
    );
  }
}

// ══════════════════════════════════════════════════════════════════════════════
// ROLE CARD ROW — side-by-side, equal sizing, premium card treatment
// ══════════════════════════════════════════════════════════════════════════════

class _RoleCardRow extends StatelessWidget {
  final OnboardingInitial state;
  const _RoleCardRow({required this.state});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: _PremiumRoleCard(
              role: 'Teacher',
              label: 'Teacher',
              sublabel: 'Create & deliver\ncourses',
              avatar: buildTeacherAvatar(),
              accentColor: _DS.tealCore,
              isSelected: state.selectedRole == 'Teacher',
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: _PremiumRoleCard(
              role: 'Student',
              label: 'Student',
              sublabel: 'Enroll & learn\nat your pace',
              avatar: buildStudentAvatar(),
              accentColor: const Color(0xFF3A8FC7),
              isSelected: state.selectedRole == 'Student',
            ),
          ),
        ],
      ),
    );
  }
}

// ══════════════════════════════════════════════════════════════════════════════
// PREMIUM ROLE CARD
// ══════════════════════════════════════════════════════════════════════════════

class _PremiumRoleCard extends StatefulWidget {
  final String role;
  final String label;
  final String sublabel;
  final Widget avatar;
  final Color accentColor;
  final bool isSelected;

  const _PremiumRoleCard({
    required this.role,
    required this.label,
    required this.sublabel,
    required this.avatar,
    required this.accentColor,
    required this.isSelected,
  });

  @override
  State<_PremiumRoleCard> createState() => _PremiumRoleCardState();
}

class _PremiumRoleCardState extends State<_PremiumRoleCard>
    with SingleTickerProviderStateMixin {
  bool _pressed = false;
  late final AnimationController _pulseCtrl;
  late final Animation<double> _pulseAnim;

  @override
  void initState() {
    super.initState();
    _pulseCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1600),
    );
    _pulseAnim = Tween<double>(
      begin: 1.0,
      end: 1.04,
    ).animate(CurvedAnimation(parent: _pulseCtrl, curve: Curves.easeInOut));
  }

  @override
  void didUpdateWidget(_PremiumRoleCard old) {
    super.didUpdateWidget(old);
    if (widget.isSelected && !old.isSelected) {
      _pulseCtrl.repeat(reverse: true);
    } else if (!widget.isSelected) {
      _pulseCtrl.stop();
      _pulseCtrl.reset();
    }
  }

  @override
  void dispose() {
    _pulseCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // ── Preserved: same BLoC dispatch ─────────────────────────────────────
    return GestureDetector(
      onTapDown: (_) => setState(() => _pressed = true),
      onTapUp: (_) {
        setState(() => _pressed = false);
        context.read<OnboardingBloc>().add(SelectRoleEvent(widget.role));
      },
      onTapCancel: () => setState(() => _pressed = false),
      child: AnimatedScale(
        scale: _pressed ? 0.96 : 1.0,
        duration: const Duration(milliseconds: 130),
        curve: Curves.easeInOut,
        child: ScaleTransition(
          scale: _pulseAnim,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 280),
            curve: Curves.easeInOut,
            padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 14),
            decoration: BoxDecoration(
              color:
                  widget.isSelected
                      ? widget.accentColor.withValues(alpha: 0.07)
                      : _DS.surface,
              borderRadius: BorderRadius.circular(24),
              border: Border.all(
                color:
                    widget.isSelected
                        ? widget.accentColor.withValues(alpha: 0.55)
                        : _DS.divider,
                width: widget.isSelected ? 2.0 : 1.0,
              ),
              boxShadow:
                  widget.isSelected
                      ? [
                        BoxShadow(
                          color: widget.accentColor.withValues(alpha: 0.18),
                          blurRadius: 28,
                          offset: const Offset(0, 10),
                        ),
                      ]
                      : _DS.cardShadow,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // ── Avatar container ──────────────────────────────────
                AnimatedContainer(
                  duration: const Duration(milliseconds: 280),
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    color:
                        widget.isSelected
                            ? widget.accentColor.withValues(alpha: 0.15)
                            : const Color(0xFFF2FAFA),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color:
                          widget.isSelected
                              ? widget.accentColor.withValues(alpha: 0.3)
                              : Colors.transparent,
                    ),
                  ),
                  padding: const EdgeInsets.all(10),
                  child: widget.avatar,
                ),

                const SizedBox(height: 16),

                // ── Role label ───────────────────────────────────────
                AnimatedDefaultTextStyle(
                  duration: const Duration(milliseconds: 280),
                  style: TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.w700,
                    color: widget.isSelected ? widget.accentColor : _DS.ink,
                    letterSpacing: -0.2,
                  ),
                  child: Text(widget.label, textAlign: TextAlign.center),
                ),

                const SizedBox(height: 5),

                // ── Role sublabel ─────────────────────────────────────
                Text(
                  widget.sublabel,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 11.5,
                    color: _DS.inkFaint,
                    height: 1.5,
                    fontWeight: FontWeight.w400,
                  ),
                ),

                const SizedBox(height: 14),

                // ── Selected indicator dot ────────────────────────────
                AnimatedContainer(
                  duration: const Duration(milliseconds: 250),
                  width: widget.isSelected ? 28 : 8,
                  height: 5,
                  decoration: BoxDecoration(
                    color: widget.isSelected ? widget.accentColor : _DS.divider,
                    borderRadius: BorderRadius.circular(10),
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
// CONTINUE BUTTON — premium CTA with shadow glow
// ══════════════════════════════════════════════════════════════════════════════

class _ContinueButton extends StatelessWidget {
  final OnboardingInitial state;
  const _ContinueButton({required this.state});

  @override
  Widget build(BuildContext context) {
    final isActive =
        state.selectedRole != null && state.selectedRole!.isNotEmpty;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(18),
          boxShadow: isActive ? _DS.buttonShadow : [],
        ),
        child: SizedBox(
          width: double.infinity,
          height: 58,
          child: ElevatedButton(
            // ── Preserved: exact same onPressed logic ─────────────────────
            onPressed: () {
              if (state.selectedRole == null || state.selectedRole!.isEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Please select your role first'),
                    backgroundColor: Colors.orange,
                    duration: Duration(seconds: 2),
                  ),
                );
              } else {
                RoleSelectionScreen.navigateToLogin(
                  context,
                  state.selectedRole!,
                );
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor:
                  isActive ? _DS.tealCore : const Color(0xFFCDE9E8),
              foregroundColor: isActive ? Colors.white : _DS.inkFaint,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(18),
              ),
              elevation: 0,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  isActive
                      ? 'Continue as ${state.selectedRole}'
                      : 'Select a role to continue',
                  style: TextStyle(
                    fontSize: 15.5,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 0.1,
                    color: isActive ? Colors.white : _DS.inkFaint,
                  ),
                ),
                if (isActive) ...[
                  const SizedBox(width: 8),
                  const Icon(
                    Icons.arrow_forward_rounded,
                    size: 18,
                    color: Colors.white,
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}
