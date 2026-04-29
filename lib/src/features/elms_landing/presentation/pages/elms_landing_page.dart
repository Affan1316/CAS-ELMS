// import 'package:flutter/material.dart';
// import 'package:flutter_cas_app_main/src/features/Chat_Page/presentation/pages/chat_page.dart';
// import 'package:flutter_cas_app_main/src/features/categories_and_login_screen/presentation/pages/OnboardingScreen.dart';
// import 'package:flutter_cas_app_main/src/features/courses_detail_page/presentation/pages/course_catalog.dart';
// import 'package:flutter_cas_app_main/src/features/elms_landing/presentation/pages/about_cas_page.dart';
// import 'package:flutter_cas_app_main/src/features/elms_landing/presentation/pages/contact_us_page.dart';
// import 'package:flutter_cas_app_main/src/features/elms_landing/presentation/pages/why_choose_cas_page.dart';
// import 'package:flutter_cas_app_main/src/features/elms_landing/presentation/widgets/ai_floating_action_button.dart';
// import 'package:flutter_cas_app_main/src/features/elms_landing/presentation/widgets/ceo_card_widget.dart';
// import 'package:flutter_cas_app_main/src/features/elms_landing/presentation/widgets/feature_card_widget.dart';
// import 'package:flutter_cas_app_main/src/features/elms_landing/presentation/widgets/login_button_widget.dart';

// class ElmsLandingPage extends StatefulWidget {
//   const ElmsLandingPage({super.key});

//   @override
//   State<ElmsLandingPage> createState() => _ElmsLandingPageState();
// }

// class _ElmsLandingPageState extends State<ElmsLandingPage>
//     with SingleTickerProviderStateMixin {
//   late AnimationController _animationController;
//   late Animation<Offset> _ceoCardAnimation;
//   late Animation<Offset> _coursesAnimation;
//   late Animation<Offset> _testimonialsAnimation;
//   late Animation<Offset> _loginButtonAnimation;

//   @override
//   void initState() {
//     super.initState();
//     _animationController = AnimationController(
//       vsync: this,
//       duration: Duration(milliseconds: 1400),
//     );

//     _ceoCardAnimation = Tween<Offset>(
//       begin: Offset(-1, 0),
//       end: Offset(0, 0),
//     ).animate(
//       CurvedAnimation(parent: _animationController, curve: Interval(0.0, 0.33)),
//     );
//     _coursesAnimation = Tween<Offset>(
//       begin: Offset(1, 0),
//       end: Offset(0, 0),
//     ).animate(
//       CurvedAnimation(
//         parent: _animationController,
//         curve: Interval(0.33, 0.66),
//       ),
//     );
//     // _testimonialsAnimation = Tween<Offset>(
//     //   begin: Offset(-1, 0),
//     //   end: Offset(0, 0),
//     // ).animate(
//     //   CurvedAnimation(parent: _animationController, curve: Interval(0.5, 0.75)),
//     // );
//     _loginButtonAnimation = Tween<Offset>(
//       begin: Offset(1, 0),
//       end: Offset(0, 0),
//     ).animate(
//       CurvedAnimation(parent: _animationController, curve: Interval(0.66, 1.0)),
//     );
//   }

//   @override
//   void dispose() {
//     _animationController.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     _animationController.forward(from: 0);
//     var size = MediaQuery.sizeOf(context);
//     final Size(:width, :height) = size;
//     return SafeArea(
//       child: Scaffold(
//         backgroundColor: Colors.white,
//         body: Center(
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.start,
//             children: [
//               SizedBox(height: height * 0.05),
//               CeoCardWidget(
//                 animationController: _animationController,
//                 anime: _ceoCardAnimation,
//                 height: height,
//                 width: width,
//               ),

//               SizedBox(height: height * 0.05),
//               AnimatedBuilder(
//                 animation: _coursesAnimation,
//                 builder:
//                     (context, child) => FadeTransition(
//                       opacity: _animationController.drive(
//                         CurveTween(curve: Interval(0.33, 0.66)),
//                       ),
//                       child: SlideTransition(
//                         position: _coursesAnimation,
//                         child: child,
//                       ),
//                     ),
//                 child: SizedBox(
//                   width: width * 0.9,
//                   height: height * 0.4,
//                   child: Column(
//                     mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                     children: [
//                       Row(
//                         mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                         children: [
//                           FeatureCardWidget(
//                             title: 'Courses',
//                             icon: Icons.menu_book,
//                             height: height,
//                             width: width,
//                             ontap: () {
//                               Navigator.of(context).push(
//                                 MaterialPageRoute(
//                                   builder: (context) => CourseCatalog(),
//                                 ),
//                               );
//                             },
//                           ),
//                           FeatureCardWidget(
//                             title: 'About CAS',
//                             icon: Icons.info,
//                             height: height,
//                             width: width,
//                             ontap: () {
//                               Navigator.of(context).push(
//                                 MaterialPageRoute(
//                                   builder: (context) => AboutCasPage(),
//                                 ),
//                               );
//                             },
//                           ),
//                         ],
//                       ),
//                       Row(
//                         mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                         children: [
//                           FeatureCardWidget(
//                             title: 'Why Choose Us?',
//                             icon: Icons.star_rate,
//                             height: height,
//                             width: width,
//                             ontap: () {
//                               Navigator.of(context).push(
//                                 MaterialPageRoute(
//                                   builder: (context) => WhyChooseUsPage(),
//                                 ),
//                               );
//                             },
//                           ),
//                           FeatureCardWidget(
//                             title: 'Contact Us',
//                             icon: Icons.call,
//                             height: height,
//                             width: width,
//                             ontap: () {
//                               Navigator.of(context).push(
//                                 MaterialPageRoute(
//                                   builder: (context) => ContactUsPage(),
//                                 ),
//                               );
//                             },
//                           ),
//                         ],
//                       ),
//                     ],
//                   ),
//                 ),
//               ),
//               SizedBox(height: 25),
//               LoginButton(
//                 onTap: () {
//                   Navigator.of(context).push(
//                     MaterialPageRoute(
//                       builder: (context) => RoleSelectionScreen(),
//                     ),
//                   );
//                 },
//                 animationController: _animationController,
//                 anime: _loginButtonAnimation,
//                 width: width,
//               ),
//               SizedBox(height: 25),
//             ],
//           ),
//         ),
//         floatingActionButton: AIFloatingButton(
//           onPressed: () {
//             Navigator.push(
//               context,
//               MaterialPageRoute(builder: (context) => ChatPage()),
//             );
//           },
//         ),
//       ),
//     );
//   }
// }

// ══════════════════════════════════════════════════════════════════════════════
// REDESIGNED: ElmsLandingPage + all child widgets
// Constraint: Zero logic changes. Pure UI layer facelift.
// Philosophy: "Deep ocean editorial" — rich teal gradients, confident type,
//             premium spatial rhythm. Feels like a fintech / edtech unicorn.
// ══════════════════════════════════════════════════════════════════════════════

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_cas_app_main/src/features/Chat_Page/presentation/pages/chat_page.dart';
import 'package:flutter_cas_app_main/src/features/categories_and_login_screen/presentation/pages/OnboardingScreen.dart';
import 'package:flutter_cas_app_main/src/features/courses_detail_page/presentation/pages/course_catalog.dart';
import 'package:flutter_cas_app_main/src/features/elms_landing/presentation/pages/about_cas_page.dart';
import 'package:flutter_cas_app_main/src/features/elms_landing/presentation/pages/contact_us_page.dart';
import 'package:flutter_cas_app_main/src/features/elms_landing/presentation/pages/why_choose_cas_page.dart';

// ── Design Tokens ─────────────────────────────────────────────────────────────

class _LD {
  // Core palette — preserved teal family, deepened for premium feel
  static const tealDeep = Color(0xFF0A7FA8); // anchor for hero gradient
  static const tealMid = Color(0xFF1AA8CC); // existing 0xFF39B3D7 → richer
  static const tealLight = Color(0xFF6DD4E8); // existing 0xFF82D8E8
  static const tealFaint = Color(0xFFE4F7FB); // surface tint
  static const tealGlow = Color(0xFF0E96C5); // existing primary

  // Neutrals
  static const ink = Color(0xFF0B2027); // near-black with teal undertone
  static const inkMid = Color(0xFF3D6472); // secondary text
  static const inkFaint = Color(0xFF7FA8B3); // hint
  static const pageBg = Color(0xFFF4FAFB); // slightly warmer than white
  static const surface = Color(0xFFFFFFFF);
  static const divider = Color(0xFFD4EFF5);

  // Hero gradient
  static const heroGrad = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFF086E96), Color(0xFF1AA8CC), Color(0xFF6DD4E8)],
    stops: [0.0, 0.55, 1.0],
  );

  // Shadows
  static List<BoxShadow> cardShadow = [
    BoxShadow(
      color: const Color(0xFF0E96C5).withValues(alpha: 0.10),
      blurRadius: 20,
      offset: const Offset(0, 8),
    ),
    BoxShadow(
      color: Colors.black.withValues(alpha: 0.04),
      blurRadius: 6,
      offset: const Offset(0, 2),
    ),
  ];

  static List<BoxShadow> heroCardShadow = [
    BoxShadow(
      color: const Color(0xFF086E96).withValues(alpha: 0.30),
      blurRadius: 32,
      offset: const Offset(0, 14),
    ),
  ];

  static List<BoxShadow> fabShadow = [
    BoxShadow(
      color: const Color(0xFF0E96C5).withValues(alpha: 0.45),
      blurRadius: 20,
      spreadRadius: 1,
      offset: const Offset(0, 6),
    ),
  ];
}

// ══════════════════════════════════════════════════════════════════════════════
// MAIN PAGE — identical AnimationController + Animation setup, new layout
// ══════════════════════════════════════════════════════════════════════════════

class ElmsLandingPage extends StatefulWidget {
  const ElmsLandingPage({super.key});

  @override
  State<ElmsLandingPage> createState() => _ElmsLandingPageState();
}

class _ElmsLandingPageState extends State<ElmsLandingPage>
    with SingleTickerProviderStateMixin {
  // ── Preserved: exact same animation declarations ──────────────────────────
  late AnimationController _animationController;
  late Animation<Offset> _ceoCardAnimation;
  late Animation<Offset> _coursesAnimation;
  late Animation<Offset> _loginButtonAnimation;

  @override
  void initState() {
    super.initState();
    // ── Preserved: exact same initState logic ─────────────────────────────
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
  }

  @override
  void dispose() {
    _animationController.dispose(); // ── Preserved ──
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // ── Preserved: same forward() call ────────────────────────────────────
    _animationController.forward(from: 0);

    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark,
      ),
    );

    final size = MediaQuery.sizeOf(context);
    final width = size.width;
    final height = size.height;

    return Scaffold(
      backgroundColor: _LD.pageBg,
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(height: height * 0.03),

              // ── Redesigned CEO hero card ───────────────────────────────
              CeoCardWidget(
                animationController: _animationController,
                anime: _ceoCardAnimation,
                height: height,
                width: width,
              ),

              SizedBox(height: height * 0.038),

              // ── Section label ─────────────────────────────────────────
              Padding(
                padding: EdgeInsets.symmetric(horizontal: width * 0.055),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'EXPLORE',
                    style: TextStyle(
                      fontSize: 10.5,
                      letterSpacing: 2.0,
                      fontWeight: FontWeight.w600,
                      color: _LD.inkFaint,
                    ),
                  ),
                ),
              ),

              SizedBox(height: height * 0.016),

              // ── Feature grid ─────────────────────────────────────────
              AnimatedBuilder(
                animation: _coursesAnimation,
                builder:
                    (context, child) => FadeTransition(
                      opacity: _animationController.drive(
                        CurveTween(curve: const Interval(0.33, 0.66)),
                      ),
                      child: SlideTransition(
                        position: _coursesAnimation,
                        child: child,
                      ),
                    ),
                // ── Preserved: same Navigator.push calls ──────────────
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: width * 0.045),
                  child: GridView.count(
                    crossAxisCount: 2,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 12,
                    childAspectRatio: 1.25,
                    children: [
                      FeatureCardWidget(
                        title: 'Courses',
                        subtitle: 'Browse catalog',
                        icon: Icons.menu_book_rounded,
                        height: height,
                        width: width,
                        ontap:
                            () => Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (_) => CourseCatalog(),
                              ),
                            ),
                      ),
                      FeatureCardWidget(
                        title: 'About CAS',
                        subtitle: 'Our story',
                        icon: Icons.info_outline_rounded,
                        height: height,
                        width: width,
                        ontap:
                            () => Navigator.of(context).push(
                              MaterialPageRoute(builder: (_) => AboutCasPage()),
                            ),
                      ),
                      FeatureCardWidget(
                        title: 'Why Choose Us',
                        subtitle: 'Our advantages',
                        icon: Icons.verified_rounded,
                        height: height,
                        width: width,
                        ontap:
                            () => Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (_) => WhyChooseUsPage(),
                              ),
                            ),
                      ),
                      FeatureCardWidget(
                        title: 'Contact Us',
                        subtitle: 'Get in touch',
                        icon: Icons.phone_outlined,
                        height: height,
                        width: width,
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

              SizedBox(height: height * 0.038),

              // ── Login button ──────────────────────────────────────────
              LoginButton(
                // ── Preserved: same onTap ─────────────────────────────
                onTap:
                    () => Navigator.of(context).push(
                      MaterialPageRoute(builder: (_) => RoleSelectionScreen()),
                    ),
                animationController: _animationController,
                anime: _loginButtonAnimation,
                width: width,
              ),

              SizedBox(height: height * 0.05),
            ],
          ),
        ),
      ),
      // ── Preserved: same FAB onPressed ─────────────────────────────────
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
// CEO CARD WIDGET — same AnimatedWidget contract, full visual overhaul
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
    final cardWidth = width * 0.90;
    // Taller card — more breathing room for text + image
    final cardHeight = (height * 0.22).clamp(160.0, 220.0);

    return FadeTransition(
      // ── Preserved: same FadeTransition ───────────────────────────────
      opacity: animationController.drive(
        CurveTween(curve: const Interval(0.0, 0.25)),
      ),
      child: SlideTransition(
        position: _animation,
        child: Container(
          width: cardWidth,
          height: cardHeight,
          decoration: BoxDecoration(
            gradient: _LD.heroGrad,
            borderRadius: BorderRadius.circular(28),
            boxShadow: _LD.heroCardShadow,
          ),
          clipBehavior: Clip.antiAlias,
          child: Stack(
            children: [
              // ── Decorative arc overlay — depth without clutter ────────
              Positioned(
                right: -40,
                top: -40,
                child: Container(
                  width: 200,
                  height: 200,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white.withValues(alpha: 0.06),
                  ),
                ),
              ),
              Positioned(
                right: 10,
                bottom: -50,
                child: Container(
                  width: 140,
                  height: 140,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white.withValues(alpha: 0.04),
                  ),
                ),
              ),

              // ── Text content ──────────────────────────────────────────
              Positioned(
                left: cardWidth * 0.055,
                top: 0,
                bottom: 0,
                right: cardWidth * 0.38,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Badge
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 3,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.18),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: const Text(
                        'CEO · CAS',
                        style: TextStyle(
                          fontSize: 9.5,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                          letterSpacing: 1.2,
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    // Name
                    const Text(
                      'Noman\nAmeer Khan',
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.w800,
                        color: Colors.white,
                        height: 1.15,
                        letterSpacing: -0.3,
                      ),
                    ),
                    const SizedBox(height: 8),
                    // Tagline
                    Text(
                      'Empowering tech learners\nthrough innovation.',
                      style: TextStyle(
                        fontSize: 11.5,
                        color: Colors.white.withValues(alpha: 0.80),
                        height: 1.55,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ],
                ),
              ),

              // ── CEO image — preserved same asset path ─────────────────
              Positioned(
                right: 0,
                bottom: 0,
                child: Image.asset(
                  'assets/images/sir.png',
                  width: cardWidth * 0.36,
                  height: cardHeight * 1.05,
                  fit: BoxFit.cover,
                  alignment: Alignment.topCenter,
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
// FEATURE CARD WIDGET — same ontap/data, premium card treatment
// ══════════════════════════════════════════════════════════════════════════════

class FeatureCardWidget extends StatefulWidget {
  final double width;
  final double height;
  final String title;
  final String subtitle; // new — improves hierarchy, no logic
  final IconData icon;
  final GestureTapCallback ontap;

  const FeatureCardWidget({
    super.key,
    required this.height,
    required this.width,
    required this.icon,
    required this.title,
    required this.ontap,
    this.subtitle = '',
  });

  @override
  State<FeatureCardWidget> createState() => _FeatureCardWidgetState();
}

class _FeatureCardWidgetState extends State<FeatureCardWidget> {
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.ontap, // ── Preserved ────────────────────────────────
      onTapDown: (_) => setState(() => _pressed = true),
      onTapUp: (_) => setState(() => _pressed = false),
      onTapCancel: () => setState(() => _pressed = false),
      child: AnimatedScale(
        scale: _pressed ? 0.96 : 1.0,
        duration: const Duration(milliseconds: 120),
        curve: Curves.easeInOut,
        child: Container(
          padding: const EdgeInsets.fromLTRB(16, 14, 12, 14),
          decoration: BoxDecoration(
            color: _LD.surface,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: _LD.divider),
            boxShadow: _LD.cardShadow,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Icon tile
              Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: _LD.tealFaint,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(widget.icon, size: 18, color: _LD.tealGlow),
              ),

              // Text stack
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.title,
                    style: const TextStyle(
                      fontSize: 13.5,
                      fontWeight: FontWeight.w700,
                      color: _LD.ink,
                      letterSpacing: -0.1,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  if (widget.subtitle.isNotEmpty) ...[
                    const SizedBox(height: 2),
                    Text(
                      widget.subtitle,
                      style: const TextStyle(
                        fontSize: 10.5,
                        color: _LD.inkFaint,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ],
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
// LOGIN BUTTON — same AnimatedWidget contract, premium CTA treatment
// ══════════════════════════════════════════════════════════════════════════════

class LoginButton extends AnimatedWidget {
  final VoidCallback onTap;
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
      // ── Preserved: same FadeTransition ───────────────────────────────
      opacity: animationController.drive(
        CurveTween(curve: const Interval(0.75, 1.0)),
      ),
      child: SlideTransition(
        position: _animation,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: width * 0.06),
          child: GestureDetector(
            onTap: onTap, // ── Preserved ──────────────────────────────
            child: Container(
              width: double.infinity,
              height: 58,
              decoration: BoxDecoration(
                gradient: _LD.heroGrad,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: _LD.tealDeep.withValues(alpha: 0.38),
                    blurRadius: 22,
                    offset: const Offset(0, 9),
                  ),
                ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    'Get Started',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16.5,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 0.2,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Container(
                    width: 28,
                    height: 28,
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.20),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.arrow_forward_rounded,
                      size: 16,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// ══════════════════════════════════════════════════════════════════════════════
// AI FLOATING ACTION BUTTON — same onPressed, premium glassmorphic FAB
// ══════════════════════════════════════════════════════════════════════════════

class AIFloatingButton extends StatelessWidget {
  final VoidCallback onPressed;

  const AIFloatingButton({super.key, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      onPressed: onPressed, // ── Preserved ────────────────────────────
      elevation: 0,
      backgroundColor: Colors.transparent,
      shape: const CircleBorder(),
      child: Container(
        width: 60,
        height: 60,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          gradient: _LD.heroGrad,
          boxShadow: _LD.fabShadow,
        ),
        child: Stack(
          alignment: Alignment.center,
          children: [
            // Subtle inner glow ring
            Container(
              width: 46,
              height: 46,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: Colors.white.withValues(alpha: 0.22),
                  width: 1.2,
                ),
              ),
            ),
            const Icon(
              Icons.auto_awesome_rounded,
              color: Colors.white,
              size: 24,
            ),
          ],
        ),
      ),
    );
  }
}
