import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class LocationInstructionsPage extends StatelessWidget {
  const LocationInstructionsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9F7F4),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 14),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Back Button
              GestureDetector(
                onTap: () => Navigator.pop(context),
                child: Container(
                  width: 34,
                  height: 34,
                  decoration: BoxDecoration(
                    color: const Color(0xFFEDE9E4),
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: const Color(0xFFDDD9D3),
                      width: 0.8,
                    ),
                  ),
                  child: const Icon(
                    Icons.arrow_back_ios_new_rounded,
                    size: 14,
                    color: Color(0xFF5A5550),
                  ),
                ),
              ),
              const SizedBox(height: 30),

              const Text(
                'GUIDE',
                style: TextStyle(
                  fontSize: 9,
                  letterSpacing: 2.0,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF8C8680),
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Location\nInstructions',
                style: GoogleFonts.dmSerifDisplay(
                  fontSize: 40,
                  fontWeight: FontWeight.w400,
                  color: const Color(0xFF1C1A17),
                  height: 1.05,
                  letterSpacing: -0.5,
                ),
              ),
              const SizedBox(height: 20),
              const _DoubleRule(),
              const SizedBox(height: 24),

              _buildSection(
                '1. Keep Location Services ON',
                'Your attendance is tracked automatically using your phone\'s GPS. For this to work, you must set location permission to "Allow all the time" in your device settings.',
              ),
              const SizedBox(height: 12),
              ClipRRect(
                borderRadius: BorderRadiusGeometry.circular(20),
                child: Image.asset("assets/img_bg_loc_acess.jpg"),
              ),
              const SizedBox(height: 12),
              _buildNotificationNotice(
                'Review app with background location access',
                'If you see a "Security & privacy" notification like "Review app with background location access", you MUST select "Allow all the time" or "Keep Always".\n\nAndroid periodically asks this to confirm you still want the app to track your location in the background. Without this, your attendance won\'t be recorded when the app is minimized.',
              ),

              const SizedBox(height: 12),
              _buildWarning(
                'If you turn off location or restrict permission while at the workshop, your attendance session will be paused. You may lose tracked time.',
              ),
              const SizedBox(height: 32),

              _buildSection(
                '2. Keep the Service Running',
                'The app runs a background service to track your location. Do not force-close the app from the recent apps screen.',
              ),
              const SizedBox(height: 16),
              _buildCheckItem(
                'You can minimize the app — it works in the background',
              ),
              _buildCheckItem(
                'You can lock your phone — the service keeps running',
              ),
              _buildCrossItem('Do NOT force-stop the app or service'),
              const SizedBox(height: 32),

              _buildSection(
                '3. Disable Battery Optimization',
                'Android may kill the attendance service to save battery. To prevent this:',
              ),
              _buildImportant(
                'This is the most important setting. Without this, Android will frequently kill the attendance service, causing missed attendance or incorrect time tracking.',
              ),
              const SizedBox(height: 32),

              const _DoubleRule(),
              const SizedBox(height: 24),

              Text(
                'MANUAL ATTENDANCE (FALLBACK)',
                style: const TextStyle(
                  fontSize: 10,
                  letterSpacing: 1.5,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1C1A17),
                ),
              ),
              const SizedBox(height: 12),
              const Text(
                'If automatic geofencing is not working on your device (due to aggressive battery optimization, custom ROMs, or other issues), you can manually mark your attendance:',
                style: TextStyle(
                  fontSize: 13,
                  color: Color(0xFF5A5550),
                  height: 1.55,
                ),
              ),
              const SizedBox(height: 16),
              _buildStepItem('Open the CAS-ELMS app'),
              _buildStepItem('Go to the Attendance Page'),
              _buildStepItem(
                'Tap the 📍 Location button in the top-right corner of the header',
              ),
              ClipRRect(
                borderRadius: BorderRadiusGeometry.circular(20),
                child: Image.asset("assets/img_loc_btn.jpg"),
              ),
              _buildStepItem(
                'The app will check your location and mark attendance if you are within the workshop area',
              ),

              const SizedBox(height: 24),
              _buildTip(
                'Use the manual button if:\n'
                '• Your phone has aggressive battery optimization\n'
                '• You notice your attendance was not automatically recorded\n'
                '• You are using a custom ROM\n'
                '• The background service notification disappeared',
              ),

              const SizedBox(height: 48),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSection(String title, String content) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title.toUpperCase(),
          style: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.bold,
            color: Color(0xFF1C1A17),
            letterSpacing: 0.5,
          ),
        ),
        const SizedBox(height: 10),
        Text(
          content,
          style: const TextStyle(
            fontSize: 13,
            color: Color(0xFF5A5550),
            height: 1.55,
          ),
        ),
      ],
    );
  }

  Widget _buildNotificationNotice(String title, String message) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFF2F2F2),
        border: Border.all(color: const Color(0xFFE0E0E0), width: 0.8),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(
                Icons.security_rounded,
                size: 18,
                color: Color(0xFF5A5550),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  title.toUpperCase(),
                  style: const TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF5A5550),
                    letterSpacing: 1.0,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            message,
            style: const TextStyle(
              fontSize: 12.5,
              color: Color(0xFF5A5550),
              height: 1.45,
              fontStyle: FontStyle.italic,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildWarning(String text) {
    return Container(
      margin: const EdgeInsets.only(top: 8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFFFF1F1),
        border: Border.all(color: const Color(0xFFFAD2D2), width: 0.8),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'WARNING',
            style: TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.bold,
              color: Color(0xFFA32D2D),
              letterSpacing: 1.2,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            text,
            style: const TextStyle(
              fontSize: 12.5,
              color: Color(0xFFA32D2D),
              height: 1.45,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildImportant(String text) {
    return Container(
      margin: const EdgeInsets.only(top: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFF1F7FF),
        border: Border.all(color: const Color(0xFFD2E3FA), width: 0.8),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'IMPORTANT',
            style: TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.bold,
              color: Color(0xFF1D4E89),
              letterSpacing: 1.2,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            text,
            style: const TextStyle(
              fontSize: 12.5,
              color: Color(0xFF1D4E89),
              height: 1.45,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTip(String text) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFEDE9E4).withOpacity(0.5),
        border: Border.all(color: const Color(0xFFDDD9D3), width: 0.8),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'TIP',
            style: TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.bold,
              color: Color(0xFF5A5550),
              letterSpacing: 1.2,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            text,
            style: const TextStyle(
              fontSize: 12.5,
              color: Color(0xFF5A5550),
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCheckItem(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('✅ ', style: TextStyle(fontSize: 14)),
          const SizedBox(width: 4),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(
                fontSize: 13,
                color: Color(0xFF5A5550),
                height: 1.4,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCrossItem(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('❌ ', style: TextStyle(fontSize: 14)),
          const SizedBox(width: 4),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(
                fontSize: 13,
                color: Color(0xFF5A5550),
                height: 1.4,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStepItem(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.only(top: 6),
            child: CircleAvatar(radius: 2, backgroundColor: Color(0xFF1C1A17)),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(
                fontSize: 13,
                color: Color(0xFF5A5550),
                height: 1.5,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _DoubleRule extends StatelessWidget {
  const _DoubleRule();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(height: 2.5, color: const Color(0xFF1C1A17)),
        const SizedBox(height: 3),
        Row(
          children: [
            Expanded(
              child: Container(height: 0.8, color: const Color(0xFFDDD9D3)),
            ),
            const SizedBox(width: 6),
            Expanded(
              child: Container(height: 0.8, color: const Color(0xFFDDD9D3)),
            ),
          ],
        ),
      ],
    );
  }
}
