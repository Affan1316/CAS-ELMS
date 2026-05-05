// ══════════════════════════════════════════════════════════════════════════════
// REDESIGNED: OnboardingScreen + OnboardingPageWidget
//
// DESIGN LANGUAGE: "The First Edition — Immersive"
// Full-bleed Unsplash hero images, frosted glass chapter badges,
// staggered entrance animations, floating accent particles,
// spring-bounce transitions. Same _Ink palette, zero logic changes.
// ══════════════════════════════════════════════════════════════════════════════

import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_cas_app_main/src/features/elms_landing/presentation/pages/elms_landing_page.dart';
import 'package:flutter_cas_app_main/src/features/onboarding/presentation/pages/OnboardingPageModel.dart';
import 'package:flutter_cas_app_main/src/features/onboarding/presentation/widgets/onboarding_screen_widget.dart';

// ══════════════════════════════════════════════════════════════════════════════
// PALETTE
// ══════════════════════════════════════════════════════════════════════════════

class _Ink {
  static const pageBg = Color(0xFFF9F7F4);
  static const inkDeep = Color(0xFF1C1A17);
  static const inkMid = Color(0xFF5A5550);
  static const inkSoft = Color(0xFF8C8680);
  static const inkFaint = Color(0xFFB5B0A8);
  static const divider = Color(0xFFDDD9D3);
  static const sand = Color(0xFFEDE9E4);

  static const accents = [
    Color(0xFFC4A882), // gold   — page 0
    Color(0xFF7EC8A4), // sage   — page 1
    Color(0xFF9B8FCE), // lav    — page 2
  ];

  static const accentDeep = [
    Color(0xFF6B5C44),
    Color(0xFF3B6B44),
    Color(0xFF5B3D6B),
  ];
}

// ══════════════════════════════════════════════════════════════════════════════
// ONBOARDING SCREEN
// ══════════════════════════════════════════════════════════════════════════════

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen>
    with TickerProviderStateMixin, WidgetsBindingObserver {
  // ── LOGIC UNCHANGED ───────────────────────────────────────────────────────
  final PageController _pageController = PageController();
  int _currentPage = 0;

  final List<OnboardingPageModel> _pages = [
    OnboardingPageModel(
      title: 'Welcome to ELMS',
      description:
          'Your comprehensive Educational Learning Management System. Start your learning journey with us today.',
      imagePath: 'assets/images/image04.png',
      color: Colors.blue,
    ),
    OnboardingPageModel(
      title: 'Learn Anywhere',
      description:
          'Access your courses, assignments, and resources from anywhere at any time. Learning made flexible.',
      imagePath: 'assets/images/image04.png',
      color: Colors.green,
    ),
    OnboardingPageModel(
      title: 'Track Progress',
      description:
          'Monitor your learning progress, view grades, and stay on top of your academic achievements.',
      imagePath: 'assets/images/image03.png',
      color: Colors.purple,
    ),
  ];

  void _nextPage() {
    if (_currentPage < _pages.length - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 600),
        curve: Curves.easeInOutCubic,
      );
    }
  }

  void _previousPage() {
    if (_currentPage > 0) {
      _pageController.previousPage(
        duration: const Duration(milliseconds: 600),
        curve: Curves.easeInOutCubic,
      );
    }
  }

  void _skipOnboarding() => Navigator.of(
    context,
  ).push(MaterialPageRoute(builder: (context) => ElmsLandingPage()));

  void _completeOnboarding() => Navigator.of(
    context,
  ).push(MaterialPageRoute(builder: (context) => ElmsLandingPage()));

  final bool _geofencingStarted = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark,
      ),
    );
  }

  @override
  void dispose() {
    _pageController.dispose();
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {} // LOGIC UNCHANGED
  // ── END LOGIC ─────────────────────────────────────────────────────────────

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

  Color get _accent => _Ink.accents[_currentPage];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _Ink.pageBg,
      body: Stack(
        children: [
          // ── PageView ────────────────────────────────────────────────
          PageView.builder(
            controller: _pageController,
            onPageChanged: (i) => setState(() => _currentPage = i),
            itemCount: _pages.length,
            itemBuilder:
                (context, index) => OnboardingPageWidget(
                  page: _pages[index],
                  pageIndex: index,
                  isActive: index == _currentPage,
                ),
          ),

          // ── Top bar overlay ─────────────────────────────────────────
          SafeArea(
            child: _TopBar(dateString: _dateString, onSkip: _skipOnboarding),
          ),

          // ── Bottom chrome overlay ────────────────────────────────────
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: _BottomChrome(
              currentPage: _currentPage,
              totalPages: _pages.length,
              accent: _accent,
              onNext:
                  _currentPage == _pages.length - 1
                      ? _completeOnboarding
                      : _nextPage,
              onPrev: _previousPage,
            ),
          ),
        ],
      ),
    );
  }
}

// ══════════════════════════════════════════════════════════════════════════════
// TOP BAR
// ══════════════════════════════════════════════════════════════════════════════

class _TopBar extends StatelessWidget {
  final String dateString;
  final VoidCallback onSkip;
  const _TopBar({required this.dateString, required this.onSkip});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(24, 14, 24, 14),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [_Ink.pageBg.withOpacity(.92), _Ink.pageBg.withOpacity(0)],
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Masthead pill
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 5),
            decoration: BoxDecoration(
              color: _Ink.pageBg.withOpacity(.75),
              border: Border.all(color: _Ink.divider),
              borderRadius: BorderRadius.circular(4),
            ),
            child: const Text(
              'ELMS · FIRST EDITION',
              style: TextStyle(
                fontSize: 9,
                letterSpacing: 1.7,
                fontWeight: FontWeight.w600,
                color: _Ink.inkSoft,
              ),
            ),
          ),

          Row(
            children: [
              Text(
                dateString,
                style: const TextStyle(
                  fontSize: 10.5,
                  color: _Ink.inkSoft,
                  letterSpacing: .2,
                ),
              ),
              const SizedBox(width: 12),
              GestureDetector(
                onTap: onSkip,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: _Ink.sand.withOpacity(.9),
                    border: Border.all(color: _Ink.divider, width: .9),
                    borderRadius: BorderRadius.circular(9),
                  ),
                  child: const Text(
                    'Skip',
                    style: TextStyle(
                      fontSize: 11.5,
                      fontWeight: FontWeight.w500,
                      color: _Ink.inkMid,
                    ),
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
// BOTTOM CHROME
// ══════════════════════════════════════════════════════════════════════════════

class _BottomChrome extends StatelessWidget {
  final int currentPage;
  final int totalPages;
  final Color accent;
  final VoidCallback onNext;
  final VoidCallback onPrev;

  const _BottomChrome({
    required this.currentPage,
    required this.totalPages,
    required this.accent,
    required this.onNext,
    required this.onPrev,
  });

  @override
  Widget build(BuildContext context) {
    final isLast = currentPage == totalPages - 1;

    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            _Ink.pageBg.withOpacity(0),
            _Ink.pageBg.withOpacity(.92),
            _Ink.pageBg,
          ],
          stops: const [0, .28, .55],
        ),
      ),
      padding: const EdgeInsets.fromLTRB(24, 28, 24, 44),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Double editorial rule
          _DoubleRule(accent: accent),
          const SizedBox(height: 20),

          // Controls row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Left: dots on page 0, ghost prev on 1+
              if (currentPage == 0)
                _AnimatedDots(
                  current: currentPage,
                  total: totalPages,
                  accent: accent,
                )
              else
                _GhostButton(label: '← Prev', onTap: onPrev),

              // Right: dots (when prev showing) + CTA
              Row(
                children: [
                  if (currentPage > 0) ...[
                    _AnimatedDots(
                      current: currentPage,
                      total: totalPages,
                      accent: accent,
                    ),
                    const SizedBox(width: 16),
                  ],
                  _CtaButton(
                    label: isLast ? 'Begin' : 'Next',
                    isLast: isLast,
                    accent: accent,
                    onTap: onNext,
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// ══════════════════════════════════════════════════════════════════════════════
// ONBOARDING PAGE WIDGET  (full redesign, same props)
// ══════════════════════════════════════════════════════════════════════════════

// Unsplash network images — one per chapter
const _unsplashUrls = [
  'https://images.unsplash.com/photo-1523050854058-8df90110c9f1?w=800&auto=format&fit=crop&q=80',
  'https://images.unsplash.com/photo-1546410531-bb4caa6b424d?w=800&auto=format&fit=crop&q=80',
  'https://images.unsplash.com/photo-1434030216411-0b793f4b4173?w=800&auto=format&fit=crop&q=80',
];

const _chapterNums = ['I', 'II', 'III'];
const _chapterTags = ['WELCOME', 'FLEXIBLE ACCESS', 'ACHIEVEMENTS'];

class OnboardingPageWidget extends StatefulWidget {
  final OnboardingPageModel page;
  final int pageIndex;
  final bool isActive;

  const OnboardingPageWidget({
    super.key,
    required this.page,
    this.pageIndex = 0,
    this.isActive = false,
  });

  @override
  State<OnboardingPageWidget> createState() => _OnboardingPageWidgetState();
}

class _OnboardingPageWidgetState extends State<OnboardingPageWidget>
    with TickerProviderStateMixin {
  // ── Entrance animation controllers ──
  late final AnimationController _enterCtrl;
  late final Animation<double> _accentRuleFade;
  late final Animation<Offset> _accentRuleSlide;
  late final Animation<double> _headlineFade;
  late final Animation<Offset> _headlineSlide;
  late final Animation<double> _bodyFade;
  late final Animation<Offset> _bodySlide;

  // ── Badge spring ──
  late final AnimationController _badgeCtrl;
  late final Animation<double> _badgeScale;
  late final Animation<double> _badgeRotate;
  late final Animation<double> _badgeFade;

  // ── Particles ──
  late final AnimationController _particleCtrl;

  // ── Ken-Burns on image ──
  late final AnimationController _kbCtrl;
  late final Animation<double> _kbScale;

  @override
  void initState() {
    super.initState();

    // Entrance
    _enterCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 700),
    );

    _accentRuleFade = CurvedAnimation(
      parent: _enterCtrl,
      curve: const Interval(0.0, 0.55, curve: Curves.easeOut),
    );
    _accentRuleSlide = Tween<Offset>(
      begin: const Offset(-.06, 0),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _enterCtrl,
        curve: const Interval(0.0, 0.55, curve: Curves.easeOut),
      ),
    );

    _headlineFade = CurvedAnimation(
      parent: _enterCtrl,
      curve: const Interval(0.12, 0.70, curve: Curves.easeOut),
    );
    _headlineSlide = Tween<Offset>(
      begin: const Offset(0, 0.06),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _enterCtrl,
        curve: const Interval(0.12, 0.70, curve: Curves.easeOut),
      ),
    );

    _bodyFade = CurvedAnimation(
      parent: _enterCtrl,
      curve: const Interval(0.28, 0.85, curve: Curves.easeOut),
    );
    _bodySlide = Tween<Offset>(
      begin: const Offset(0, 0.05),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _enterCtrl,
        curve: const Interval(0.28, 0.85, curve: Curves.easeOut),
      ),
    );

    // Badge — spring bounce
    _badgeCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 750),
    );
    _badgeScale = Tween<double>(
      begin: .45,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _badgeCtrl, curve: Curves.elasticOut));
    _badgeRotate = Tween<double>(begin: -.18, end: 0).animate(
      CurvedAnimation(
        parent: _badgeCtrl,
        curve: const Interval(0, .6, curve: Curves.easeOut),
      ),
    );
    _badgeFade = CurvedAnimation(
      parent: _badgeCtrl,
      curve: const Interval(0, .3, curve: Curves.easeOut),
    );

    // Particles — looping
    _particleCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 3800),
    )..repeat();

    // Ken-Burns
    _kbCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 8000),
    );
    _kbScale = Tween<double>(
      begin: 1.0,
      end: 1.07,
    ).animate(CurvedAnimation(parent: _kbCtrl, curve: Curves.easeInOut));

    if (widget.isActive) _playEntrance();
  }

  void _playEntrance() {
    _enterCtrl.forward(from: 0);
    _badgeCtrl.forward(from: 0);
    _kbCtrl.forward(from: 0);
  }

  @override
  void didUpdateWidget(covariant OnboardingPageWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isActive && !oldWidget.isActive) {
      _playEntrance();
    } else if (!widget.isActive) {
      _enterCtrl.reset();
      _badgeCtrl.reset();
      _kbCtrl.reset();
    }
  }

  @override
  void dispose() {
    _enterCtrl.dispose();
    _badgeCtrl.dispose();
    _particleCtrl.dispose();
    _kbCtrl.dispose();
    super.dispose();
  }

  Color get _accent => _Ink.accents[widget.pageIndex.clamp(0, 2)];
  Color get _accentD => _Ink.accentDeep[widget.pageIndex.clamp(0, 2)];
  String get _chNum => _chapterNums[widget.pageIndex.clamp(0, 2)];
  String get _chTag => _chapterTags[widget.pageIndex.clamp(0, 2)];
  String get _imgUrl => _unsplashUrls[widget.pageIndex.clamp(0, 2)];

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final heroH = size.height * .52;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // ── HERO IMAGE BLOCK ─────────────────────────────────────────
        SizedBox(
          height: heroH,
          width: double.infinity,
          child: Stack(
            fit: StackFit.expand,
            children: [
              // Image with Ken-Burns
              AnimatedBuilder(
                animation: _kbScale,
                builder:
                    (_, child) => Transform.scale(
                      scale: _kbScale.value,
                      alignment: Alignment.topCenter,
                      child: child,
                    ),
                child: Image.network(
                  _imgUrl,
                  fit: BoxFit.cover,
                  alignment: Alignment.topCenter,
                  // Fallback to local asset if network fails
                  errorBuilder:
                      (_, __, ___) => Image.asset(
                        widget.page.imagePath,
                        fit: BoxFit.cover,
                        alignment: Alignment.topCenter,
                      ),
                ),
              ),

              // Bottom gradient scrim
              Positioned(
                left: 0,
                right: 0,
                bottom: 0,
                height: heroH * .52,
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.transparent,
                        _Ink.pageBg.withOpacity(.6),
                        _Ink.pageBg,
                      ],
                      stops: const [0, .6, 1],
                    ),
                  ),
                ),
              ),

              // Top dark vignette
              Positioned(
                left: 0,
                right: 0,
                top: 0,
                height: heroH * .35,
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.black.withOpacity(.28),
                        Colors.transparent,
                      ],
                    ),
                  ),
                ),
              ),

              // ── Frosted glass chapter badge ──────────────────────
              Positioned(
                top: 72,
                right: 20,
                child: AnimatedBuilder(
                  animation: _badgeCtrl,
                  builder:
                      (_, child) => Opacity(
                        opacity: _badgeFade.value,
                        child: Transform.rotate(
                          angle: _badgeRotate.value,
                          child: Transform.scale(
                            scale: _badgeScale.value,
                            child: child,
                          ),
                        ),
                      ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(36),
                    child: Container(
                      width: 68,
                      height: 68,
                      decoration: BoxDecoration(
                        color: _accent.withOpacity(.22),
                        borderRadius: BorderRadius.circular(36),
                        border: Border.all(
                          color: Colors.white.withOpacity(.3),
                          width: 1,
                        ),
                      ),
                      alignment: Alignment.center,
                      child: Text(
                        _chNum,
                        style: GoogleFonts.dmSerifDisplay(
                          fontSize: 26,
                          color: Colors.white,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ),
                  ),
                ),
              ),

              // ── Chapter tag — bottom left of image ──────────────
              Positioned(
                bottom: heroH * .12,
                left: 24,
                child: FadeTransition(
                  opacity: _accentRuleFade,
                  child: SlideTransition(
                    position: _accentRuleSlide,
                    child: Row(
                      children: [
                        Container(
                          width: 7,
                          height: 7,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: _accent,
                          ),
                        ),
                        const SizedBox(width: 7),
                        Text(
                          _chTag,
                          style: TextStyle(
                            fontSize: 9.5,
                            fontWeight: FontWeight.w600,
                            letterSpacing: 1.9,
                            color: _Ink.inkDeep,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              // ── Floating particles ────────────────────────────────
              ..._buildParticles(heroH),
            ],
          ),
        ),

        // ── TEXT CONTENT ─────────────────────────────────────────────
        Padding(
          padding: const EdgeInsets.fromLTRB(26, 10, 26, 0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Accent rule + eyebrow
              FadeTransition(
                opacity: _accentRuleFade,
                child: SlideTransition(
                  position: _accentRuleSlide,
                  child: Row(
                    children: [
                      Container(
                        width: 24,
                        height: 2.5,
                        decoration: BoxDecoration(
                          color: _accent,
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                      const SizedBox(width: 9),
                      Text(
                        'CHAPTER $_chNum',
                        style: TextStyle(
                          fontSize: 9.5,
                          letterSpacing: 2,
                          fontWeight: FontWeight.w600,
                          color: _accent,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 13),

              // Headline
              FadeTransition(
                opacity: _headlineFade,
                child: SlideTransition(
                  position: _headlineSlide,
                  child: _buildHeadline(),
                ),
              ),

              const SizedBox(height: 13),

              // Thin rule
              FadeTransition(
                opacity: _bodyFade,
                child: Container(height: .8, color: _Ink.divider),
              ),

              const SizedBox(height: 13),

              // Body copy
              FadeTransition(
                opacity: _bodyFade,
                child: SlideTransition(
                  position: _bodySlide,
                  child: Text(
                    widget.page.description,
                    style: const TextStyle(
                      fontSize: 13.5,
                      color: _Ink.inkSoft,
                      height: 1.65,
                      letterSpacing: .1,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  // Headline with bold + italic split
  Widget _buildHeadline() {
    final title = widget.page.title;
    // Split at first space for bold/italic treatment
    final spaceIdx = title.indexOf(' ');
    if (spaceIdx < 0) {
      return Text(
        title,
        style: GoogleFonts.dmSerifDisplay(
          fontSize: 36,
          color: _Ink.inkDeep,
          height: 1.08,
        ),
      );
    }
    final first = title.substring(0, spaceIdx);
    final rest = title.substring(spaceIdx + 1);
    return Text.rich(
      TextSpan(
        children: [
          TextSpan(
            text: '$first\n',
            style: GoogleFonts.dmSerifDisplay(
              fontSize: 36,
              color: _Ink.inkDeep,
              height: 1.05,
              fontWeight: FontWeight.w400,
            ),
          ),
          TextSpan(
            text: rest,
            style: GoogleFonts.dmSerifDisplay(
              fontSize: 32,
              color: _Ink.inkDeep,
              height: 1.05,
              fontWeight: FontWeight.w400,
              fontStyle: FontStyle.italic,
            ),
          ),
        ],
      ),
    );
  }

  // Floating accent particles
  List<Widget> _buildParticles(double heroH) {
    final specs = [
      _ParticleSpec(
        left: 38,
        bottom: heroH * .22,
        size: 8,
        delay: 0,
        dur: 3500,
        color: _accent,
      ),
      _ParticleSpec(
        left: 110,
        bottom: heroH * .28,
        size: 5,
        delay: 800,
        dur: 4200,
        color: _Ink.divider,
      ),
      _ParticleSpec(
        right: 58,
        bottom: heroH * .20,
        size: 6,
        delay: 1300,
        dur: 3100,
        color: _accent,
      ),
      _ParticleSpec(
        right: 130,
        bottom: heroH * .32,
        size: 4,
        delay: 500,
        dur: 3800,
        color: _Ink.inkFaint,
      ),
    ];

    return specs
        .map(
          (s) => Positioned(
            left: s.left,
            right: s.right,
            bottom: s.bottom,
            child: _FloatingParticle(spec: s, controller: _particleCtrl),
          ),
        )
        .toList();
  }
}

// ══════════════════════════════════════════════════════════════════════════════
// FLOATING PARTICLE
// ══════════════════════════════════════════════════════════════════════════════

class _ParticleSpec {
  final double? left;
  final double? right;
  final double bottom;
  final double size;
  final int delay;
  final int dur;
  final Color color;

  const _ParticleSpec({
    this.left,
    this.right,
    required this.bottom,
    required this.size,
    required this.delay,
    required this.dur,
    required this.color,
  });
}

class _FloatingParticle extends StatelessWidget {
  final _ParticleSpec spec;
  final AnimationController controller;

  const _FloatingParticle({required this.spec, required this.controller});

  @override
  Widget build(BuildContext context) {
    final delayFraction = spec.delay / 4000.0;
    final durationFraction = spec.dur / 4000.0;

    final opacity = TweenSequence<double>([
      TweenSequenceItem(tween: Tween(begin: 0, end: .38), weight: 20),
      TweenSequenceItem(tween: Tween(begin: .38, end: .2), weight: 60),
      TweenSequenceItem(tween: Tween(begin: .2, end: 0), weight: 20),
    ]).animate(
      CurvedAnimation(
        parent: controller,
        curve: Interval(
          delayFraction,
          (delayFraction + durationFraction).clamp(0, 1),
        ),
      ),
    );

    final offset = Tween<Offset>(
      begin: Offset.zero,
      end: const Offset(0, -.018),
    ).animate(
      CurvedAnimation(
        parent: controller,
        curve: Interval(
          delayFraction,
          (delayFraction + durationFraction).clamp(0, 1),
          curve: Curves.easeInOut,
        ),
      ),
    );

    return FadeTransition(
      opacity: opacity,
      child: SlideTransition(
        position: offset,
        child: Container(
          width: spec.size,
          height: spec.size,
          decoration: BoxDecoration(shape: BoxShape.circle, color: spec.color),
        ),
      ),
    );
  }
}

// ══════════════════════════════════════════════════════════════════════════════
// SHARED WIDGETS
// ══════════════════════════════════════════════════════════════════════════════

class _DoubleRule extends StatelessWidget {
  final Color accent;
  const _DoubleRule({required this.accent});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(height: 2.5, color: _Ink.inkDeep),
        const SizedBox(height: 3),
        Row(
          children: [
            Expanded(child: Container(height: .8, color: _Ink.divider)),
            const SizedBox(width: 6),
            Expanded(child: Container(height: .8, color: _Ink.divider)),
          ],
        ),
      ],
    );
  }
}

class _AnimatedDots extends StatelessWidget {
  final int current;
  final int total;
  final Color accent;
  const _AnimatedDots({
    required this.current,
    required this.total,
    required this.accent,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: List.generate(total, (i) {
        final active = i == current;
        return AnimatedContainer(
          duration: const Duration(milliseconds: 280),
          curve: Curves.easeInOutCubic,
          margin: const EdgeInsets.only(right: 5),
          width: active ? 24.0 : 6.0,
          height: 6,
          decoration: BoxDecoration(
            color: active ? _Ink.inkDeep : _Ink.divider,
            borderRadius: BorderRadius.circular(3),
          ),
        );
      }),
    );
  }
}

class _GhostButton extends StatefulWidget {
  final String label;
  final VoidCallback onTap;
  const _GhostButton({required this.label, required this.onTap});

  @override
  State<_GhostButton> createState() => _GhostButtonState();
}

class _GhostButtonState extends State<_GhostButton> {
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => setState(() => _pressed = true),
      onTapUp: (_) {
        setState(() => _pressed = false);
        widget.onTap();
      },
      onTapCancel: () => setState(() => _pressed = false),
      child: AnimatedOpacity(
        opacity: _pressed ? .45 : 1.0,
        duration: const Duration(milliseconds: 100),
        child: Text(
          widget.label,
          style: const TextStyle(
            fontSize: 13.5,
            fontWeight: FontWeight.w500,
            color: _Ink.inkSoft,
          ),
        ),
      ),
    );
  }
}

class _CtaButton extends StatefulWidget {
  final String label;
  final bool isLast;
  final Color accent;
  final VoidCallback onTap;

  const _CtaButton({
    required this.label,
    required this.isLast,
    required this.accent,
    required this.onTap,
  });

  @override
  State<_CtaButton> createState() => _CtaButtonState();
}

class _CtaButtonState extends State<_CtaButton> {
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => setState(() => _pressed = true),
      onTapUp: (_) {
        setState(() => _pressed = false);
        widget.onTap();
      },
      onTapCancel: () => setState(() => _pressed = false),
      child: AnimatedScale(
        scale: _pressed ? .95 : 1.0,
        duration: const Duration(milliseconds: 110),
        child: Stack(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 26, vertical: 15),
              decoration: BoxDecoration(
                color: _Ink.inkDeep,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    widget.label,
                    style: const TextStyle(
                      fontSize: 14.5,
                      fontWeight: FontWeight.w600,
                      color: _Ink.pageBg,
                      letterSpacing: .2,
                    ),
                  ),
                  const SizedBox(width: 8),
                  AnimatedSwitcher(
                    duration: const Duration(milliseconds: 300),
                    child: Text(
                      widget.isLast ? '✦' : '→',
                      key: ValueKey(widget.isLast),
                      style: TextStyle(
                        fontSize: widget.isLast ? 12 : 16,
                        color: widget.accent,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            // Accent underline
            Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 350),
                height: 3,
                decoration: BoxDecoration(
                  color: widget.accent,
                  borderRadius: const BorderRadius.only(
                    bottomLeft: Radius.circular(16),
                    bottomRight: Radius.circular(16),
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
