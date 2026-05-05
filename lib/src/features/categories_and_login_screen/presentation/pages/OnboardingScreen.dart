// ══════════════════════════════════════════════════════════════════════════════
// REDESIGNED: RoleSelectionScreen
// Designer note: Rethemed to match StudentHomePage editorial palette.
// Philosophy: "Warm stone editorial" — same _Ink tokens, DM Serif Display,
//             newspaper double-rules, cream surfaces. Zero logic changes.
// ══════════════════════════════════════════════════════════════════════════════

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_cas_app_main/src/features/admin_login_screen/presentation/page/admin_login_page.dart';
import 'package:flutter_cas_app_main/src/features/categories_and_login_screen/presentation/bloc/login_onboarding_bloc.dart';
import 'package:flutter_cas_app_main/src/features/categories_and_login_screen/presentation/bloc/login_onboarding_event.dart';
import 'package:flutter_cas_app_main/src/features/categories_and_login_screen/presentation/bloc/login_onboarding_state.dart';
import 'package:flutter_cas_app_main/src/features/categories_and_login_screen/presentation/widgets/buildStudentAvatar.dart';
import 'package:flutter_cas_app_main/src/features/categories_and_login_screen/presentation/widgets/buildTeacherAvatar.dart';
import 'package:flutter_cas_app_main/src/features/categories_and_login_screen/presentation/widgets/buildUserIdScreen.dart';

// ══════════════════════════════════════════════════════════════════════════════
// PALETTE — mirrors StudentHomePage _Ink tokens exactly
// ══════════════════════════════════════════════════════════════════════════════

class _Ink {
  static const pageBg = Color(0xFFF9F7F4); // warm cream
  static const inkDeep = Color(0xFF1C1A17); // near-black
  static const inkMid = Color(0xFF5A5550); // editorial gray
  static const inkSoft = Color(0xFF8C8680); // muted label
  static const inkFaint = Color(0xFFB5B0A8); // hairline
  static const divider = Color(0xFFDDD9D3); // rule line
  static const surface = Color(0xFFFFFFFF); // card white

  // Feature card tones — same as StudentHomePage
  static const sand = Color(0xFFEDE9E4);
  static const sage = Color(0xFFE4EDE7);

  // Icon bed / stroke tones
  static const sandBed = Color(0xFFC8BCA8);
  static const sageBed = Color(0xFFB5CDB9);
  static const sandStroke = Color(0xFF6B5C44);
  static const sageStroke = Color(0xFF3B6B44);

  // Shared shadow recipe
  static List<BoxShadow> cardShadow = [
    BoxShadow(
      color: const Color(0xFF1C1A17).withOpacity(0.06),
      blurRadius: 24,
      offset: const Offset(0, 8),
    ),
    BoxShadow(
      color: Colors.black.withOpacity(0.03),
      blurRadius: 6,
      offset: const Offset(0, 2),
    ),
  ];

  static List<BoxShadow> cardShadowSelected = [
    BoxShadow(
      color: const Color(0xFF1C1A17).withOpacity(0.13),
      blurRadius: 28,
      offset: const Offset(0, 10),
    ),
  ];

  static List<BoxShadow> buttonShadow = [
    BoxShadow(
      color: const Color(0xFF1C1A17).withOpacity(0.22),
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
      backgroundColor: _Ink.pageBg,
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
// REDESIGNED BODY — editorial scroll layout
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
      duration: const Duration(milliseconds: 1100),
    );
    _fadeIn = CurvedAnimation(
      parent: _enterCtrl,
      curve: const Interval(0.0, 0.65, curve: Curves.easeOut),
    );
    _slideUp = Tween<Offset>(
      begin: const Offset(0, 0.04),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _enterCtrl,
        curve: const Interval(0.0, 0.75, curve: Curves.easeOutCubic),
      ),
    );
    _enterCtrl.forward();
  }

  @override
  void dispose() {
    _enterCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _fadeIn,
      child: SlideTransition(
        position: _slideUp,
        child: SafeArea(
          child: CustomScrollView(
            physics: const BouncingScrollPhysics(),
            slivers: [
              // ── Edition banner (dateline pill) ───────────────────────────
              SliverToBoxAdapter(child: _EditionBanner()),

              // ── Hairline rule ────────────────────────────────────────────
              SliverToBoxAdapter(child: _HeroRule()),

              // ── Typographic greeting block ───────────────────────────────
              SliverToBoxAdapter(child: _HeadlineBlock()),

              // ── Double editorial rule ────────────────────────────────────
              SliverToBoxAdapter(child: _ThickRule()),

              // ── Section label ────────────────────────────────────────────
              SliverToBoxAdapter(child: _SectionLabel('Choose your chapter')),

              // ── Role cards ───────────────────────────────────────────────
              SliverToBoxAdapter(child: _RoleCardRow(state: widget.state)),

              // ── Continue CTA ─────────────────────────────────────────────
              SliverToBoxAdapter(child: _ContinueButton(state: widget.state)),

              // ── Footer colophon ──────────────────────────────────────────
              SliverToBoxAdapter(child: _Footer()),
            ],
          ),
        ),
      ),
    );
  }
}

// ══════════════════════════════════════════════════════════════════════════════
// EDITION BANNER — matches StudentHomePage _EditionBanner exactly
// ══════════════════════════════════════════════════════════════════════════════

class _EditionBanner extends StatelessWidget {
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
          _TagPill('Welcome Edition'),
          Text(
            _dateString,
            style: const TextStyle(
              fontSize: 11,
              color: _Ink.inkSoft,
              letterSpacing: 0.2,
            ),
          ),
        ],
      ),
    );
  }
}

class _TagPill extends StatelessWidget {
  final String label;
  const _TagPill(this.label);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        border: Border.all(color: _Ink.divider),
        borderRadius: BorderRadius.circular(3),
      ),
      child: Text(
        label.toUpperCase(),
        style: const TextStyle(
          fontSize: 9,
          letterSpacing: 1.6,
          fontWeight: FontWeight.w500,
          color: _Ink.inkSoft,
        ),
      ),
    );
  }
}

// ══════════════════════════════════════════════════════════════════════════════
// RULES — identical to StudentHomePage _HeroRule / _ThickRule
// ══════════════════════════════════════════════════════════════════════════════

class _HeroRule extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return const Divider(height: 1, thickness: 0.8, color: _Ink.divider);
  }
}

class _ThickRule extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
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
// HEADLINE BLOCK — DM Serif Display, same style as _GreetingBlock
// ══════════════════════════════════════════════════════════════════════════════

class _HeadlineBlock extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 20, 24, 18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Get started',
            style: TextStyle(
              fontSize: 11,
              letterSpacing: 1.4,
              color: _Ink.inkSoft,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            'Join CAS as a...',
            style: GoogleFonts.dmSerifDisplay(
              fontSize: 44,
              fontWeight: FontWeight.w400,
              color: _Ink.inkDeep,
              height: 1.05,
              letterSpacing: -0.5,
            ),
          ),
          const SizedBox(height: 14),
          const Text(
            '"Education is not the filling of a pail, but the lighting of a fire."',
            style: TextStyle(
              fontSize: 12.5,
              color: _Ink.inkSoft,
              fontStyle: FontStyle.italic,
              height: 1.55,
              letterSpacing: 0.1,
            ),
          ),
        ],
      ),
    );
  }
}

// ══════════════════════════════════════════════════════════════════════════════
// SECTION LABEL — identical to StudentHomePage _SectionLabel
// ══════════════════════════════════════════════════════════════════════════════

class _SectionLabel extends StatelessWidget {
  final String text;
  const _SectionLabel(this.text);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 20, 24, 12),
      child: Text(
        text.toUpperCase(),
        style: const TextStyle(
          fontSize: 10,
          letterSpacing: 1.5,
          fontWeight: FontWeight.w500,
          color: _Ink.inkSoft,
        ),
      ),
    );
  }
}

// ══════════════════════════════════════════════════════════════════════════════
// ROLE CARD ROW — two equal cards, stone-palette tones
// ══════════════════════════════════════════════════════════════════════════════

class _RoleCardRow extends StatelessWidget {
  final OnboardingInitial state;
  const _RoleCardRow({required this.state});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: _EditorialRoleCard(
              role: 'Teacher',
              label: 'Teacher',
              labelItalic: 'Mode',
              sublabel: 'Create & deliver\ncourses',
              avatar: buildTeacherAvatar(),
              bgColor: _Ink.sand,
              iconBed: _Ink.sandBed,
              iconStroke: _Ink.sandStroke,
              isSelected: state.selectedRole == 'Teacher',
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: _EditorialRoleCard(
              role: 'Student',
              label: 'Student',
              labelItalic: 'Mode',
              sublabel: 'Enroll & learn\nat your pace',
              avatar: buildStudentAvatar(),
              bgColor: _Ink.sage,
              iconBed: _Ink.sageBed,
              iconStroke: _Ink.sageStroke,
              isSelected: state.selectedRole == 'Student',
            ),
          ),
        ],
      ),
    );
  }
}

// ══════════════════════════════════════════════════════════════════════════════
// EDITORIAL ROLE CARD — square card styled like _SquareChapterCard
// ══════════════════════════════════════════════════════════════════════════════

class _EditorialRoleCard extends StatefulWidget {
  final String role;
  final String label;
  final String labelItalic;
  final String sublabel;
  final Widget avatar;
  final Color bgColor;
  final Color iconBed;
  final Color iconStroke;
  final bool isSelected;

  const _EditorialRoleCard({
    required this.role,
    required this.label,
    required this.labelItalic,
    required this.sublabel,
    required this.avatar,
    required this.bgColor,
    required this.iconBed,
    required this.iconStroke,
    required this.isSelected,
  });

  @override
  State<_EditorialRoleCard> createState() => _EditorialRoleCardState();
}

class _EditorialRoleCardState extends State<_EditorialRoleCard>
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
      end: 1.03,
    ).animate(CurvedAnimation(parent: _pulseCtrl, curve: Curves.easeInOut));
  }

  @override
  void didUpdateWidget(_EditorialRoleCard old) {
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
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              color: widget.bgColor,
              borderRadius: BorderRadius.circular(22),
              border: Border.all(
                color:
                    widget.isSelected
                        ? _Ink.inkDeep.withOpacity(0.35)
                        : Colors.transparent,
                width: widget.isSelected ? 1.5 : 0,
              ),
              boxShadow:
                  widget.isSelected ? _Ink.cardShadowSelected : _Ink.cardShadow,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // ── Icon bed ───────────────────────────────────────────
                AnimatedContainer(
                  duration: const Duration(milliseconds: 280),
                  width: 38,
                  height: 38,
                  decoration: BoxDecoration(
                    color:
                        widget.isSelected
                            ? _Ink.inkDeep.withOpacity(0.08)
                            : widget.iconBed,
                    borderRadius: BorderRadius.circular(11),
                  ),
                  padding: const EdgeInsets.all(7),
                  child: widget.avatar,
                ),

                const SizedBox(height: 20),

                // ── DM Serif Display label — same as _SquareChapterCard ─
                Text.rich(
                  TextSpan(
                    children: [
                      TextSpan(
                        text: widget.label,
                        style: GoogleFonts.dmSerifDisplay(
                          fontSize: 20,
                          fontWeight: FontWeight.w700,
                          color: _Ink.inkDeep,
                          height: 1.05,
                        ),
                      ),
                      TextSpan(
                        text: '\n${widget.labelItalic}',
                        style: GoogleFonts.dmSerifDisplay(
                          fontSize: 18,
                          fontWeight: FontWeight.w400,
                          fontStyle: FontStyle.italic,
                          color: _Ink.inkDeep,
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 6),

                Text(
                  widget.sublabel,
                  style: const TextStyle(
                    fontSize: 11,
                    color: _Ink.inkSoft,
                    height: 1.5,
                  ),
                ),

                const SizedBox(height: 14),

                // ── Selected pill indicator — same animation as _PremiumRoleCard ──
                AnimatedContainer(
                  duration: const Duration(milliseconds: 250),
                  width: widget.isSelected ? 28 : 8,
                  height: 4,
                  decoration: BoxDecoration(
                    color:
                        widget.isSelected
                            ? _Ink.inkDeep
                            : _Ink.inkFaint.withOpacity(0.5),
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
// CONTINUE BUTTON — inkDeep CTA matching StudentHomePage's dark-slab style
// ══════════════════════════════════════════════════════════════════════════════

class _ContinueButton extends StatelessWidget {
  final OnboardingInitial state;
  const _ContinueButton({required this.state});

  @override
  Widget build(BuildContext context) {
    final isActive =
        state.selectedRole != null && state.selectedRole!.isNotEmpty;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(18),
          boxShadow: isActive ? _Ink.buttonShadow : [],
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
              backgroundColor: isActive ? _Ink.inkDeep : _Ink.divider,
              foregroundColor:
                  isActive ? const Color(0xFFF9F7F4) : _Ink.inkFaint,
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
                  style: GoogleFonts.dmSerifDisplay(
                    fontSize: 17,
                    fontWeight: FontWeight.w400,
                    fontStyle: isActive ? FontStyle.italic : FontStyle.normal,
                    color: isActive ? const Color(0xFFF9F7F4) : _Ink.inkFaint,
                    letterSpacing: 0.1,
                  ),
                ),
                if (isActive) ...[
                  const SizedBox(width: 10),
                  const Icon(
                    Icons.arrow_forward_rounded,
                    size: 17,
                    color: Color(0xFFF9F7F4),
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

// ══════════════════════════════════════════════════════════════════════════════
// FOOTER — masthead colophon, identical to StudentHomePage _Footer style
// ══════════════════════════════════════════════════════════════════════════════

class _Footer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 24),
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 24),
          child: Divider(height: 1, thickness: 0.8, color: _Ink.divider),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(24, 12, 24, 32),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: const [
              Text(
                'CAS LEARNING SYSTEM',
                style: TextStyle(
                  fontSize: 9,
                  letterSpacing: 1.4,
                  color: _Ink.inkFaint,
                  fontWeight: FontWeight.w500,
                ),
              ),
              Text(
                'Onboarding · v1.0',
                style: TextStyle(fontSize: 10, color: _Ink.inkFaint),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
