import 'package:flutter/material.dart';
import 'package:flutter_cas_app_main/src/features/Chat_Page/presentation/pages/chat_page.dart';
import 'package:flutter_cas_app_main/src/features/categories_and_login_screen/presentation/pages/OnboardingScreen.dart';
import 'package:flutter_cas_app_main/src/features/courses_detail_page/presentation/pages/course_catalog.dart';
import 'package:flutter_cas_app_main/src/features/elms_landing/presentation/pages/about_cas_page.dart';
import 'package:flutter_cas_app_main/src/features/elms_landing/presentation/pages/contact_us_page.dart';
import 'package:flutter_cas_app_main/src/features/elms_landing/presentation/pages/why_choose_cas_page.dart';
import 'package:flutter_cas_app_main/src/features/elms_landing/presentation/widgets/ai_floating_action_button.dart';
import 'package:flutter_cas_app_main/src/features/elms_landing/presentation/widgets/ceo_card_widget.dart';
import 'package:flutter_cas_app_main/src/features/elms_landing/presentation/widgets/feature_card_widget.dart';
import 'package:flutter_cas_app_main/src/features/elms_landing/presentation/widgets/login_button_widget.dart';

class ElmsLandingPage extends StatefulWidget {
  const ElmsLandingPage({super.key});

  @override
  State<ElmsLandingPage> createState() => _ElmsLandingPageState();
}

class _ElmsLandingPageState extends State<ElmsLandingPage>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<Offset> _ceoCardAnimation;
  late Animation<Offset> _coursesAnimation;
  late Animation<Offset> _testimonialsAnimation;
  late Animation<Offset> _loginButtonAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 1400),
    );

    _ceoCardAnimation = Tween<Offset>(
      begin: Offset(-1, 0),
      end: Offset(0, 0),
    ).animate(
      CurvedAnimation(parent: _animationController, curve: Interval(0.0, 0.33)),
    );
    _coursesAnimation = Tween<Offset>(
      begin: Offset(1, 0),
      end: Offset(0, 0),
    ).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Interval(0.33, 0.66),
      ),
    );
    // _testimonialsAnimation = Tween<Offset>(
    //   begin: Offset(-1, 0),
    //   end: Offset(0, 0),
    // ).animate(
    //   CurvedAnimation(parent: _animationController, curve: Interval(0.5, 0.75)),
    // );
    _loginButtonAnimation = Tween<Offset>(
      begin: Offset(1, 0),
      end: Offset(0, 0),
    ).animate(
      CurvedAnimation(parent: _animationController, curve: Interval(0.66, 1.0)),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _animationController.forward(from: 0);
    var size = MediaQuery.sizeOf(context);
    final Size(:width, :height) = size;
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 16.0),
                child: Text(
                  "Wanna Know About CAS? Let Start From Here!",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
              ),
              CeoCardWidget(
                animationController: _animationController,
                anime: _ceoCardAnimation,
                height: height,
                width: width,
              ),
              Container(
                width: width * 0.9,
                padding: EdgeInsets.all(10),
                child: Center(
                  child: Column(
                    children: [
                      Text(
                        'Consistency, hardwork and dedication is the key to success.',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Text('Noman ameer khan', style: TextStyle()),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              AnimatedBuilder(
                animation: _coursesAnimation,
                builder:
                    (context, child) => FadeTransition(
                      opacity: _animationController.drive(
                        CurveTween(curve: Interval(0.33, 0.66)),
                      ),
                      child: SlideTransition(
                        position: _coursesAnimation,
                        child: child,
                      ),
                    ),
                child: SizedBox(
                  width: width * 0.9,
                  height: height * 0.4,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          FeatureCardWidget(
                            title: 'Courses',
                            icon: Icons.menu_book,
                            height: height,
                            width: width,
                            ontap: () {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (context) => CourseCatalog(),
                                ),
                              );
                            },
                          ),
                          FeatureCardWidget(
                            title: 'About CAS',
                            icon: Icons.info,
                            height: height,
                            width: width,
                            ontap: () {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (context) => AboutCasPage(),
                                ),
                              );
                            },
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          FeatureCardWidget(
                            title: 'Why Choose Us?',
                            icon: Icons.star_rate,
                            height: height,
                            width: width,
                            ontap: () {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (context) => WhyChooseUsPage(),
                                ),
                              );
                            },
                          ),
                          FeatureCardWidget(
                            title: 'Contact Us',
                            icon: Icons.call,
                            height: height,
                            width: width,
                            ontap: () {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (context) => ContactUsPage(),
                                ),
                              );
                            },
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              LoginButton(
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => RoleSelectionScreen(),
                    ),
                  );
                },
                animationController: _animationController,
                anime: _loginButtonAnimation,
                width: width,
              ),
              SizedBox(height: 25),
            ],
          ),
        ),
        floatingActionButton: AIFloatingButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => ChatPage()),
            );
          },
        ),
      ),
    );
  }
}
