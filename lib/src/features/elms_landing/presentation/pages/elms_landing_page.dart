// ══════════════════════════════════════════════════════════════════════════════
// REDESIGNED: ElmsLandingPage + all child widgets
//
// DESIGN LANGUAGE: "The Cover Edition"
// The landing page is the front page of the CAS newspaper — the boldest,
// most confident expression of the editorial identity that runs through the
// entire app. Dark hero masthead → warm cream body → section teasers.
//
// CONSTRAINT: Zero logic changes. Pure UI layer only.
// ══════════════════════════════════════════════════════════════════════════════

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_cas_app_main/src/features/Chat_Page/presentation/pages/chat_page.dart';
import 'package:flutter_cas_app_main/src/features/categories_and_login_screen/presentation/pages/OnboardingScreen.dart';
import 'package:flutter_cas_app_main/src/features/courses_detail_page/presentation/pages/course_catalog.dart';
import 'package:flutter_cas_app_main/src/features/elms_landing/presentation/pages/about_cas_page.dart';
import 'package:flutter_cas_app_main/src/features/elms_landing/presentation/pages/contact_us_page.dart';
import 'package:flutter_cas_app_main/src/features/elms_landing/presentation/pages/why_choose_cas_page.dart';

// ══════════════════════════════════════════════════════════════════════════════
// PALETTE — extends the app-wide _Ink tokens + dark hero layer
// ══════════════════════════════════════════════════════════════════════════════

class _Ink {
  // Core — shared with home page
  static const pageBg = Color(0xFFF9F7F4); // warm cream
  static const inkDeep = Color(0xFF1C1A17); // near-black
  static const inkMid = Color(0xFF5A5550); // editorial gray
  static const inkSoft = Color(0xFF8C8680); // muted label
  static const inkFaint = Color(0xFFB5B0A8); // hairline
  static const divider = Color(0xFFDDD9D3); // rule line
  static const sand = Color(0xFFEDE9E4);
  static const sandBed = Color(0xFFC8BCA8);
  static const sandStroke = Color(0xFF6B5C44);

  // Hero masthead tones — dark slab
  static const heroDeep = Color(0xFF111009); // richest near-black
  static const heroMid = Color(0xFF2A2720); // card bg within hero

  // Feature card colours — same as home page chapter cards
  static const sage = Color(0xFFE4EDE7);
  static const lavender = Color(0xFFE9E4ED);
  static const mist = Color(0xFFE4EAE9);
  static const stone = Color(0xFFEDE8E4);

  static const sageBed = Color(0xFFB5CDB9);
  static const lavBed = Color(0xFFC8B5CF);
  static const mistBed = Color(0xFFB0C4C2);
  static const stoneBed = Color(0xFFCCB8A8);

  static const sageStroke = Color(0xFF3B6B44);
  static const lavStroke = Color(0xFF5B3D6B);
  static const mistStroke = Color(0xFF3B5C5A);
  static const stoneStroke = Color(0xFF6B4A33);

  // Gold accent — used only on the hero
  static const gold = Color(0xFFC4A882);
  static const goldLight = Color(0xFFDDD0BE);
}

// ══════════════════════════════════════════════════════════════════════════════
// MAIN PAGE
// ══════════════════════════════════════════════════════════════════════════════

class ElmsLandingPage extends StatefulWidget {
  const ElmsLandingPage({super.key});

  @override
  State<ElmsLandingPage> createState() => _ElmsLandingPageState();
}

class _ElmsLandingPageState extends State<ElmsLandingPage>
    with SingleTickerProviderStateMixin {
  // ── LOGIC UNCHANGED: exact same AnimationController + Animation setup ─────
  late AnimationController _animationController;
  late Animation<Offset> _ceoCardAnimation;
  late Animation<Offset> _coursesAnimation;
  late Animation<Offset> _loginButtonAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1400),
    );
    _ceoCardAnimation = Tween<Offset>(
      begin: const Offset(-1, 0),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: const Interval(0.0, 0.33),
      ),
    );
    _coursesAnimation = Tween<Offset>(
      begin: const Offset(1, 0),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: const Interval(0.33, 0.66),
      ),
    );
    _loginButtonAnimation = Tween<Offset>(
      begin: const Offset(1, 0),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: const Interval(0.66, 1.0),
      ),
    );

    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light, // light text on dark hero
      ),
    );
  }

  @override
  void dispose() {
    _animationController.dispose(); // ── LOGIC UNCHANGED ──
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // ── LOGIC UNCHANGED: same forward() call ─────────────────────────────
    _animationController.forward(from: 0);

    final size = MediaQuery.sizeOf(context);
    final width = size.width;
    final height = size.height;

    return Scaffold(
      backgroundColor: _Ink.heroDeep, // dark base so scroll overscroll is dark
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ══════════════════════════════════════════════════════════
            // DARK HERO SECTION — masthead + CEO card
            // ══════════════════════════════════════════════════════════
            Container(
              color: _Ink.heroDeep,
              child: SafeArea(
                bottom: false,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // ── Masthead banner ───────────────────────────────
                    _MastheadBanner(),

                    // ── Thin divider ──────────────────────────────────
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24),
                      child: Divider(
                        height: 1,
                        thickness: 0.5,
                        color: Colors.white.withOpacity(0.12),
                      ),
                    ),

                    // ── Headline copy ─────────────────────────────────
                    Padding(
                      padding: const EdgeInsets.fromLTRB(24, 22, 24, 0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'EDUCATION',
                            style: TextStyle(
                              fontSize: 9.5,
                              letterSpacing: 2.4,
                              fontWeight: FontWeight.w600,
                              color: _Ink.gold.withOpacity(0.8),
                            ),
                          ),
                          const SizedBox(height: 10),
                          Text.rich(
                            TextSpan(
                              children: [
                                TextSpan(
                                  text: 'Shaping\n',
                                  style: GoogleFonts.dmSerifDisplay(
                                    fontSize: 46,
                                    color: const Color(0xFFF9F7F4),
                                    height: 1.0,
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                                TextSpan(
                                  text: 'Tomorrow\'s\nTech Leaders.',
                                  style: GoogleFonts.dmSerifDisplay(
                                    fontSize: 46,
                                    color: _Ink.gold,
                                    height: 1.0,
                                    fontStyle: FontStyle.italic,
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 14),
                          Text(
                            'The CAS Learning Management System — built for students who move fast.',
                            style: TextStyle(
                              fontSize: 13,
                              color: Colors.white.withOpacity(0.50),
                              height: 1.6,
                              letterSpacing: 0.1,
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 26),

                    // ── CEO Featured Card ─────────────────────────────
                    CeoCardWidget(
                      animationController: _animationController,
                      anime: _ceoCardAnimation,
                      height: height,
                      width: width,
                    ),

                    const SizedBox(height: 28),
                  ],
                ),
              ),
            ),

            // ══════════════════════════════════════════════════════════
            // CREAM BODY SECTION — section rules + feature cards + CTA
            // ══════════════════════════════════════════════════════════
            Container(
              color: _Ink.pageBg,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // ── Double rule transition ────────────────────────
                  _DoubleRule(),

                  // ── Section label ─────────────────────────────────
                  Padding(
                    padding: const EdgeInsets.fromLTRB(24, 20, 24, 14),
                    child: Text(
                      'TODAY\'S SECTIONS',
                      style: TextStyle(
                        fontSize: 9.5,
                        letterSpacing: 1.8,
                        fontWeight: FontWeight.w600,
                        color: _Ink.inkSoft,
                      ),
                    ),
                  ),

                  // ── Feature grid ──────────────────────────────────
                  AnimatedBuilder(
                    animation: _coursesAnimation,
                    builder:
                        (context, child) => FadeTransition(
                          // ── LOGIC UNCHANGED ──
                          opacity: _animationController.drive(
                            CurveTween(curve: const Interval(0.33, 0.66)),
                          ),
                          child: SlideTransition(
                            position: _coursesAnimation,
                            child: child,
                          ),
                        ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: GridView.count(
                        crossAxisCount: 2,
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        crossAxisSpacing: 10,
                        mainAxisSpacing: 10,
                        childAspectRatio: 1.0,
                        children: [
                          // ── LOGIC UNCHANGED: same Navigator.push ──
                          FeatureCardWidget(
                            title: 'Course-',
                            titleItalic: 'Catalog',
                            subtitle: 'Browse all programs',
                            bgColor: _Ink.sand,
                            iconBed: _Ink.sandBed,
                            iconStroke: _Ink.sandStroke,
                            icon: Icons.menu_book_rounded,
                            ontap:
                                () => Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (_) => CourseCatalog(),
                                  ),
                                ),
                          ),
                          FeatureCardWidget(
                            title: 'About',
                            titleItalic: 'CAS',
                            subtitle: 'Our mission & story',
                            bgColor: _Ink.sage,
                            iconBed: _Ink.sageBed,
                            iconStroke: _Ink.sageStroke,
                            icon: Icons.info_outline_rounded,
                            ontap:
                                () => Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (_) => AboutCasPage(),
                                  ),
                                ),
                          ),
                          FeatureCardWidget(
                            title: 'Why',
                            titleItalic: 'Choose Us',
                            subtitle: 'Our advantages',
                            bgColor: _Ink.lavender,
                            iconBed: _Ink.lavBed,
                            iconStroke: _Ink.lavStroke,
                            icon: Icons.verified_rounded,
                            ontap:
                                () => Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (_) => WhyChooseUsPage(),
                                  ),
                                ),
                          ),
                          FeatureCardWidget(
                            title: 'Contact',
                            titleItalic: 'Us',
                            subtitle: 'Get in touch',
                            bgColor: _Ink.mist,
                            iconBed: _Ink.mistBed,
                            iconStroke: _Ink.mistStroke,
                            icon: Icons.phone_outlined,
                            ontap:
                                () => Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (_) => ContactUsPage(),
                                  ),
                                ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 28),

                  // ── Hairline before CTA ───────────────────────────
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: Divider(
                      height: 1,
                      thickness: 0.8,
                      color: _Ink.divider,
                    ),
                  ),

                  const SizedBox(height: 24),

                  // ── Login CTA ─────────────────────────────────────
                  LoginButton(
                    onTap:
                        () => Navigator.of(context).push(
                          // ── LOGIC UNCHANGED ──
                          MaterialPageRoute(
                            builder: (_) => RoleSelectionScreen(),
                          ),
                        ),
                    animationController: _animationController,
                    anime: _loginButtonAnimation,
                    width: width,
                  ),

                  // ── Footer colophon ───────────────────────────────
                  _FooterColophon(),
                ],
              ),
            ),
          ],
        ),
      ),
      // ── LOGIC UNCHANGED: same FAB onPressed ──────────────────────────────
      floatingActionButton: AIFloatingButton(
        onPressed:
            () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => ChatPage()),
            ),
      ),
    );
  }
}

// ══════════════════════════════════════════════════════════════════════════════
// MASTHEAD BANNER — editorial top strip
// ══════════════════════════════════════════════════════════════════════════════

class _MastheadBanner extends StatelessWidget {
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
      padding: const EdgeInsets.fromLTRB(24, 14, 24, 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Masthead logo pill
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 5),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.white.withOpacity(0.18)),
              borderRadius: BorderRadius.circular(4),
            ),
            child: Text(
              'CAS · LMS',
              style: TextStyle(
                fontSize: 10,
                letterSpacing: 2.0,
                fontWeight: FontWeight.w600,
                color: Colors.white.withOpacity(0.85),
              ),
            ),
          ),

          Text(
            _dateString,
            style: TextStyle(
              fontSize: 10.5,
              color: Colors.white.withOpacity(0.35),
              letterSpacing: 0.2,
            ),
          ),
        ],
      ),
    );
  }
}

// ══════════════════════════════════════════════════════════════════════════════
// CEO CARD — same AnimatedWidget contract, editorial dark-slab treatment
// ══════════════════════════════════════════════════════════════════════════════

class CeoCardWidget extends AnimatedWidget {
  final AnimationController animationController;
  final double width;
  final double height;

  const CeoCardWidget({
    super.key,
    required this.height,
    required this.width,
    required this.animationController,
    required Animation<Offset> anime,
  }) : super(listenable: anime);

  Animation<Offset> get _animation => listenable as Animation<Offset>;

  @override
  Widget build(BuildContext context) {
    final cardWidth = width - 32;
    final cardHeight = height * 0.22;

    return FadeTransition(
      // ── LOGIC UNCHANGED ──────────────────────────────────────────────────
      opacity: animationController.drive(
        CurveTween(curve: const Interval(0.0, 0.25)),
      ),
      child: SlideTransition(
        position: _animation,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Container(
            width: cardWidth,
            height: cardHeight.clamp(150.0, 200.0),
            decoration: BoxDecoration(
              color: const Color(0xFF252219), // warm dark — editorial
              borderRadius: BorderRadius.circular(22),
              border: Border.all(
                color: Colors.white.withOpacity(0.07),
                width: 0.8,
              ),
            ),
            clipBehavior: Clip.antiAlias,
            child: Stack(
              children: [
                // Decorative circle (matches home page hero card)
                Positioned(
                  right: -24,
                  top: -24,
                  child: Container(
                    width: 110,
                    height: 110,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white.withOpacity(0.03),
                    ),
                  ),
                ),

                // Gold accent bar — left edge
                Positioned(
                  left: 0,
                  top: 24,
                  bottom: 24,
                  child: Container(
                    width: 3,
                    decoration: BoxDecoration(
                      color: _Ink.gold,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),

                // Content
                Positioned(
                  left: 20,
                  top: 0,
                  bottom: 0,
                  right: cardWidth * 0.37,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Badge
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 7,
                          vertical: 3,
                        ),
                        decoration: BoxDecoration(
                          color: _Ink.gold.withOpacity(0.15),
                          borderRadius: BorderRadius.circular(4),
                          border: Border.all(
                            color: _Ink.gold.withOpacity(0.30),
                            width: 0.6,
                          ),
                        ),
                        child: Text(
                          'FOUNDER · CEO',
                          style: TextStyle(
                            fontSize: 8,
                            letterSpacing: 1.4,
                            fontWeight: FontWeight.w600,
                            color: _Ink.gold,
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),
                      // Name — serif masthead
                      Text(
                        'Noman\nAmeer Khan',
                        style: GoogleFonts.dmSerifDisplay(
                          fontSize: 24,
                          color: const Color(0xFFF9F7F4),
                          height: 1.1,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      const SizedBox(height: 8),
                      // Quote
                      Text(
                        '"Education is the\nmost powerful tool."',
                        style: TextStyle(
                          fontSize: 11,
                          color: Colors.white.withOpacity(0.45),
                          fontStyle: FontStyle.italic,
                          height: 1.5,
                        ),
                      ),
                    ],
                  ),
                ),

                // CEO photo — preserved asset path
                Positioned(
                  right: 0,
                  bottom: 0,
                  child: Image.asset(
                    'assets/images/sir.png',
                    width: cardWidth * 0.35,
                    height: cardHeight.clamp(150.0, 200.0),
                    fit: BoxFit.cover,
                    alignment: Alignment.topCenter,
                  ),
                ),

                // Bottom progress bar — edition indicator
                Positioned(
                  left: 20,
                  right: cardWidth * 0.37,
                  bottom: 14,
                  child: Row(
                    children: [
                      Expanded(
                        flex: 4,
                        child: Container(height: 2, color: _Ink.gold),
                      ),
                      const SizedBox(width: 3),
                      Expanded(
                        flex: 2,
                        child: Container(
                          height: 2,
                          color: Colors.white.withOpacity(0.08),
                        ),
                      ),
                    ],
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
// FEATURE CARD WIDGET — matches home page square chapter card pattern exactly
// ══════════════════════════════════════════════════════════════════════════════

class FeatureCardWidget extends StatefulWidget {
  final String title;
  final String titleItalic;
  final String subtitle;
  final Color bgColor;
  final Color iconBed;
  final Color iconStroke;
  final IconData icon;
  final GestureTapCallback ontap;

  // Unused size params kept for backward compat with any existing callers
  final double width;
  final double height;

  const FeatureCardWidget({
    super.key,
    required this.title,
    required this.titleItalic,
    required this.subtitle,
    required this.bgColor,
    required this.iconBed,
    required this.iconStroke,
    required this.icon,
    required this.ontap,
    this.width = 0,
    this.height = 0,
  });

  @override
  State<FeatureCardWidget> createState() => _FeatureCardWidgetState();
}

class _FeatureCardWidgetState extends State<FeatureCardWidget> {
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.ontap, // ── LOGIC UNCHANGED ──
      onTapDown: (_) => setState(() => _pressed = true),
      onTapUp: (_) => setState(() => _pressed = false),
      onTapCancel: () => setState(() => _pressed = false),
      child: AnimatedScale(
        scale: _pressed ? 0.96 : 1.0,
        duration: const Duration(milliseconds: 120),
        curve: Curves.easeInOut,
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: widget.bgColor,
            borderRadius: BorderRadius.circular(22),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Icon tile
              Container(
                width: 34,
                height: 34,
                decoration: BoxDecoration(
                  color: widget.iconBed,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(widget.icon, size: 16, color: widget.iconStroke),
              ),

              // Text
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text.rich(
                    TextSpan(
                      children: [
                        TextSpan(
                          text: widget.title,
                          style: GoogleFonts.dmSerifDisplay(
                            fontSize: 18,
                            fontWeight: FontWeight.w700,
                            color: _Ink.inkDeep,
                            height: 1.05,
                          ),
                        ),
                        TextSpan(
                          text: '\n${widget.titleItalic}',
                          style: GoogleFonts.dmSerifDisplay(
                            fontSize: 16,
                            fontWeight: FontWeight.w400,
                            fontStyle: FontStyle.italic,
                            color: _Ink.inkDeep,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    widget.subtitle,
                    style: TextStyle(fontSize: 10.5, color: _Ink.inkSoft),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ══════════════════════════════════════════════════════════════════════════════
// LOGIN BUTTON — same AnimatedWidget contract, editorial CTA
// ══════════════════════════════════════════════════════════════════════════════

class LoginButton extends AnimatedWidget {
  final VoidCallback onTap; // ── LOGIC UNCHANGED ──
  final AnimationController animationController;
  final double width;

  const LoginButton({
    super.key,
    required this.width,
    required this.onTap,
    required this.animationController,
    required Animation<Offset> anime,
  }) : super(listenable: anime);

  Animation<Offset> get _animation => listenable as Animation<Offset>;

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      // ── LOGIC UNCHANGED ──────────────────────────────────────────────────
      opacity: animationController.drive(
        CurveTween(curve: const Interval(0.75, 1.0)),
      ),
      child: SlideTransition(
        position: _animation,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: _DarkCTA(onTap: onTap),
        ),
      ),
    );
  }
}

class _DarkCTA extends StatefulWidget {
  final VoidCallback onTap;
  const _DarkCTA({required this.onTap});

  @override
  State<_DarkCTA> createState() => _DarkCTAState();
}

class _DarkCTAState extends State<_DarkCTA> {
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
        scale: _pressed ? 0.975 : 1.0,
        duration: const Duration(milliseconds: 110),
        child: Container(
          width: double.infinity,
          height: 58,
          decoration: BoxDecoration(
            color: _Ink.inkDeep,
            borderRadius: BorderRadius.circular(18),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Enter your edition',
                style: GoogleFonts.dmSerifDisplay(
                  fontSize: 20,
                  color: const Color(0xFFF9F7F4),
                  fontStyle: FontStyle.italic,
                  fontWeight: FontWeight.w400,
                ),
              ),
              const SizedBox(width: 12),
              Container(
                width: 28,
                height: 28,
                decoration: BoxDecoration(
                  color: _Ink.gold.withOpacity(0.18),
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: _Ink.gold.withOpacity(0.40),
                    width: 0.8,
                  ),
                ),
                child: const Icon(
                  Icons.arrow_forward_rounded,
                  size: 14,
                  color: _Ink.gold,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ══════════════════════════════════════════════════════════════════════════════
// DOUBLE RULE — editorial section divider (matches home page exactly)
// ══════════════════════════════════════════════════════════════════════════════

class _DoubleRule extends StatelessWidget {
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
// FOOTER COLOPHON — masthead-style bottom strip (matches home page _Footer)
// ══════════════════════════════════════════════════════════════════════════════

class _FooterColophon extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 24),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Divider(height: 1, thickness: 0.8, color: _Ink.divider),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(24, 12, 24, 32),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
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
                'Est. 2020 · Bahawalpur',
                style: TextStyle(fontSize: 10, color: _Ink.inkFaint),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

// ══════════════════════════════════════════════════════════════════════════════
// AI FLOATING ACTION BUTTON — same onPressed, editorial circle style
// ══════════════════════════════════════════════════════════════════════════════

class AIFloatingButton extends StatelessWidget {
  final VoidCallback onPressed; // ── LOGIC UNCHANGED ──

  const AIFloatingButton({super.key, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        width: 58,
        height: 58,
        decoration: BoxDecoration(
          color: _Ink.inkDeep,
          shape: BoxShape.circle,
          border: Border.all(color: _Ink.gold.withOpacity(0.35), width: 1.2),
        ),
        child: Stack(
          alignment: Alignment.center,
          children: [
            // Inner ring
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: Colors.white.withOpacity(0.06),
                  width: 1,
                ),
              ),
            ),
            const Icon(Icons.auto_awesome_rounded, color: _Ink.gold, size: 22),
          ],
        ),
      ),
    );
  }
}
