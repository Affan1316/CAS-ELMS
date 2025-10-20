import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cas_app_main/main.dart';
import 'package:flutter_cas_app_main/src/features/elms_landing/presentation/pages/elms_landing_page.dart';
import 'package:flutter_cas_app_main/src/features/geofencing/data/datasource/geofence_firebase_datasource.dart';
import 'package:flutter_cas_app_main/src/features/geofencing/data/datasource/geofence_service_impl.dart';
import 'package:flutter_cas_app_main/src/features/geofencing/data/repositories/geofence_repository_impl.dart';
import 'package:flutter_cas_app_main/src/features/geofencing/domain/usecases/start_geofencing_usecase.dart';
import 'package:flutter_cas_app_main/src/features/geofencing/domain/usecases/stop_geofencing_usecase.dart';
import 'package:flutter_cas_app_main/src/features/geofencing/presentation/listener/geofence_listener.dart';
import 'package:flutter_cas_app_main/src/features/onboarding/presentation/pages/OnboardingPageModel.dart';
import 'package:flutter_cas_app_main/src/features/onboarding/presentation/widgets/onboarding_screen_widget.dart';
import 'package:flutter_cas_app_main/src/features/student_attendance/presentation/pages/student_attendance_page.dart';
import 'package:geolocator/geolocator.dart';
import 'package:location/location.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen>
    with WidgetsBindingObserver {
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
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  void _previousPage() {
    if (_currentPage > 0) {
      _pageController.previousPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  void _skipOnboarding() => Navigator.of(
    context,
  ).push(MaterialPageRoute(builder: (context) => ElmsLandingPage()));
  void _completeOnboarding() => Navigator.of(context).push(
    MaterialPageRoute(builder: (context) => StudentAttendanceScreen()),
  ); //ElmsLandingPage()

  // void _navigateToHome() {
  //   // Navigator.pushReplacementNamed(context, '/home');
  // }

  bool _geofencingStarted = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this); // 👈 register observer
    _checkAndStartGeofencing();
  }

  @override
  void dispose() {
    _pageController.dispose();
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed && !_geofencingStarted) {
      // 👈 runs after returning from location settings
      _checkAndStartGeofencing();
    }
  }

  Future<void> _intiallizeGeofencing() async {
    final geofenceRepository = GeofenceRepositoryImpl(
      firebaseDataSource: GeofenceFirebaseDataSource(
        FirebaseFirestore.instance,
      ),
      geofenceService: GeofenceServiceImpl(),
    );

    final startGeofencingUseCase = StartGeofencingUseCase(geofenceRepository);
    final stopGeofencingUseCase = StopGeofencingUseCase(geofenceRepository);

    final geofenceListener = GeofenceListener(
      startGeofencing: startGeofencingUseCase,
      stopGeofencing: stopGeofencingUseCase,
    );

    try {
      geofenceListener.start(
        studentId: 'f17-02',
        latitude: 29.394702,
        longitude: 71.652824,
      );
      _geofencingStarted = true;
      debugPrint("✅ Geofencing started");
    } catch (e) {
      debugPrint("❌ Error starting geofencing: $e");
    }
  }

  Future<void> _checkAndStartGeofencing() async {
    final hasPermission = await requestPermission();

    if (!hasPermission) {
      debugPrint("🚫 Location permission denied");
      return;
    }

    var serviceEnabled = await Geolocator.isLocationServiceEnabled();
    Location location = Location();
    while (!serviceEnabled) {
      debugPrint("⚠️ Location service is OFF, opening settings...");
      serviceEnabled = await location.requestService();

      // Wait a bit before checking again
      await Future.delayed(const Duration(seconds: 2));
      // await Geolocator.openLocationSettings();
      // ⏸ Wait until app is resumed
      return;
    }

    // ✅ Safe to start
    await _intiallizeGeofencing();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            // Skip Button
            Align(
              alignment: Alignment.topRight,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: TextButton(
                  onPressed: _skipOnboarding,
                  child: const Text(
                    'Skip',
                    style: TextStyle(color: Colors.grey, fontSize: 16),
                  ),
                ),
              ),
            ),

            // Page Content
            Expanded(
              child: PageView.builder(
                controller: _pageController,
                onPageChanged: (index) {
                  setState(() => _currentPage = index);
                },
                itemCount: _pages.length,
                itemBuilder: (context, index) {
                  return OnboardingPageWidget(page: _pages[index]);
                },
              ),
            ),

            // Page Indicators
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                _pages.length,
                (index) => Container(
                  margin: const EdgeInsets.symmetric(horizontal: 4),
                  width: _currentPage == index ? 24 : 8,
                  height: 8,
                  decoration: BoxDecoration(
                    color:
                        _currentPage == index
                            ? _pages[_currentPage].color
                            : Colors.grey.shade300,
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 40),

            // Navigation Buttons
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  if (_currentPage > 0)
                    TextButton(
                      onPressed: _previousPage,
                      child: const Text(
                        'Previous',
                        style: TextStyle(color: Colors.grey, fontSize: 16),
                      ),
                    )
                  else
                    const SizedBox(width: 80),

                  ElevatedButton(
                    onPressed:
                        _currentPage == _pages.length - 1
                            ? _completeOnboarding
                            : _nextPage,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: _pages[_currentPage].color,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 32,
                        vertical: 16,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(25),
                      ),
                      elevation: 3,
                    ),
                    child: Text(
                      _currentPage == _pages.length - 1
                          ? 'Get Started'
                          : 'Next',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }
}
