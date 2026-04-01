import 'dart:convert';
import 'dart:developer';
import 'dart:math' as math;

import 'package:bounce/bounce.dart';
import 'package:clay_containers/clay_containers.dart';
import 'package:flutter_cas_app_main/src/auth/data/service/profile_image_service.dart';
import 'package:flutter_cas_app_main/src/features/student_feature/data/student_entity_class.dart';
import 'package:flutter_neumorphic_plus/flutter_neumorphic.dart';
import 'package:spring/spring.dart';

class StudentDetailPage extends StatefulWidget {
  final StudentEntityClass student;
  const StudentDetailPage({super.key, required this.student});

  @override
  State<StudentDetailPage> createState() => _StudentDetailPageState();
}

class _StudentDetailPageState extends State<StudentDetailPage>
    with TickerProviderStateMixin {
  String? _pickedImage;
  late AnimationController _bgController;
  late AnimationController _contentController;
  late AnimationController _shakeController;

  final Color baseColor = const Color(0xFFE6E6E6);
  final Color shadowColor = const Color(0xFFBEBEBE);
  final Color lightColor = const Color(0xFFFFFFFF);
  final Color accentColor = const Color(0xFF6C7CE7);

  @override
  void initState() {
    super.initState();
    _bgController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 8),
    )..repeat(reverse: true);

    _contentController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    )..forward();

    _shakeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );

    _loadImage();
  }

  @override
  void dispose() {
    _bgController.dispose();
    _contentController.dispose();
    _shakeController.dispose();
    super.dispose();
  }

  Future<void> _loadImage() async {
    ProfileImageService imageService = ProfileImageService();
    final image = await imageService.getSavedImageBase64(
      studentId: widget.student.id,
    );
    if (mounted) {
      setState(() {
        _pickedImage = image;
      });
    }
    log("Base64 Image loaded: ${_pickedImage != null}");
  }

  Future<void> _pickImage() async {
    ProfileImageService imageService = ProfileImageService();
    final image = await imageService.pickAndSaveImage(
      studentId: widget.student.id,
      groupName: widget.student.group,
    );
    if (image != null && mounted) {
      setState(() {
        _pickedImage = image;
      });
      log("Base64 Image updated after pickup");
    }
  }

  // Custom Soft UI Container Widget
  Widget _buildSoftContainer({
    required Widget child,
    double? height,
    double? width,
    EdgeInsets? margin,
    EdgeInsets? padding,
    double radius = 8,
    double depth = 8,
  }) {
    return Container(
      height: height,
      width: width,
      margin: margin,
      padding: padding,
      decoration: BoxDecoration(
        color: baseColor,
        borderRadius: BorderRadius.circular(radius),
        boxShadow: [
          // Dark shadow (bottom-right)
          BoxShadow(
            color: shadowColor,
            offset: Offset(depth, depth),
            blurRadius: depth,
            spreadRadius: 0,
          ),
          // Light shadow (top-left)
          BoxShadow(
            color: lightColor,
            offset: Offset(-depth, -depth),
            blurRadius: depth,
            spreadRadius: 0,
          ),
        ],
      ),
      child: child,
    );
  }

  // Inset Soft UI Container
  Widget _buildInsetContainer({
    required Widget child,
    double? height,
    double? width,
    EdgeInsets? margin,
    EdgeInsets? padding,
    double radius = 8,
    double depth = 8,
  }) {
    return Container(
      height: height,
      width: width,
      margin: margin,
      decoration: BoxDecoration(
        color: baseColor,
        borderRadius: BorderRadius.circular(radius),
        boxShadow: [
          // Inner shadows for inset effect
          BoxShadow(
            color: shadowColor,
            offset: Offset(-depth, -depth),
            blurRadius: depth,
            spreadRadius: -depth,
          ),
          BoxShadow(
            color: lightColor,
            offset: Offset(depth, depth),
            blurRadius: depth,
            spreadRadius: -depth,
          ),
        ],
      ),
      child: Container(
        padding: padding,
        decoration: BoxDecoration(
          color: baseColor,
          borderRadius: BorderRadius.circular(radius),
        ),
        child: child,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final student = widget.student;
    final cards = [
      ["ID", student.id, Icons.badge],
      ["Email", student.email, Icons.email],
      ["Phone", student.phone, Icons.phone],
      ["CNIC", student.cnic, Icons.credit_card],
      ["Gender", student.gender, Icons.person],
      ["Address", student.address, Icons.home],
      ["Father Name", student.fatherName, Icons.family_restroom],
      ["Father Occupation", student.fatherOccupation, Icons.work],
    ];

    return NeumorphicTheme(
      theme: NeumorphicThemeData(
        baseColor: baseColor,
        lightSource: LightSource.topLeft,
        depth: 8,
        intensity: 0.65,
      ),
      child: Scaffold(
        backgroundColor: baseColor,
        body: Stack(
          children: [
            // Animated Soft Background
            Positioned.fill(
              child: AnimatedBuilder(
                animation: _bgController,
                builder: (context, child) {
                  return Container(
                    decoration: BoxDecoration(
                      gradient: RadialGradient(
                        center: Alignment(
                          0.3 +
                              0.4 * math.sin(_bgController.value * 2 * math.pi),
                          0.3 +
                              0.4 * math.cos(_bgController.value * 2 * math.pi),
                        ),
                        radius: 1.2,
                        colors: [
                          baseColor.withOpacity(0.8),
                          baseColor,
                          const Color(0xFFD4D4D4),
                        ],
                        stops: const [0.0, 0.6, 1.0],
                      ),
                    ),
                  );
                },
              ),
            ),

            // Floating Soft Particles
            Positioned.fill(
              child: CustomPaint(
                painter: SoftParticlePainter(
                  controller: _bgController,
                  baseColor: baseColor,
                ),
              ),
            ),

            // Content
            ListView(
              padding: const EdgeInsets.all(0),
              children: [
                const SizedBox(height: 80),

                // Avatar Container with Spring Animation
                Spring.slide(
                  slideType: SlideType.slide_in_top,
                  animDuration: const Duration(milliseconds: 800),
                  curve: Curves.elasticOut,
                  child: ScaleTransition(
                    scale: CurvedAnimation(
                      parent: _contentController,
                      curve: Curves.elasticOut,
                    ),
                    child: Center(
                      child: AnimatedBuilder(
                        animation: _shakeController,
                        builder: (context, child) {
                          return Transform.translate(
                            offset: Offset(
                              math.sin(_shakeController.value * math.pi * 10) *
                                  5,
                              0,
                            ),
                            child: Bounce(
                              onTap: _pickImage,
                              child: ClayContainer(
                                height: 180,
                                width: 180,
                                borderRadius: 90,
                                depth: 20,
                                spread: 8,
                                color: baseColor,
                                curveType: CurveType.concave,
                                child: Center(
                                  child: Hero(
                                    tag: student.id,
                                    child: NeomorphicAvatar(
                                      imagePath: _pickedImage,
                                      size: 140,
                                      baseColor: baseColor,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 32),

                // Soft UI Name Container
                FadeTransition(
                  opacity: _contentController,
                  child: SlideTransition(
                    position: Tween<Offset>(
                      begin: const Offset(0, 0.5),
                      end: Offset.zero,
                    ).animate(
                      CurvedAnimation(
                        parent: _contentController,
                        curve: Curves.easeOutCubic,
                      ),
                    ),
                    child: Center(
                      child: _buildInsetContainer(
                        margin: const EdgeInsets.symmetric(horizontal: 40),
                        padding: const EdgeInsets.symmetric(
                          vertical: 16,
                          horizontal: 24,
                        ),
                        radius: 25,
                        depth: 8,
                        child: Text(
                          student.name,
                          style: const TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.w600,
                            color: Color(0xFF4A4A4A),
                            letterSpacing: 0.5,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 16),

                // Group in Morpheus Container
                FadeTransition(
                  opacity: _contentController,
                  child: Center(
                    child: // Replace the MorpheusContainer for the group widget
                        ClayContainer(
                      height: 40,
                      width: 200,
                      borderRadius: 20,
                      color: baseColor,
                      depth: -4, // Negative depth for inset effect
                      spread: 2,
                      curveType: CurveType.concave,
                      child: Center(
                        child: Text(
                          student.group,
                          style: TextStyle(
                            fontSize: 16,
                            color: accentColor,
                            fontWeight: FontWeight.w500,
                            letterSpacing: 0.3,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 40),

                // Neomorphic Cards Grid
                GridView.builder(
                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 16,
                    mainAxisSpacing: 16,
                    childAspectRatio: 1.1,
                  ),
                  itemCount: cards.length,
                  itemBuilder: (context, index) {
                    final data = cards[index];
                    final title = data[0] as String;
                    final value = data[1] as String;
                    final icon = data[2] as IconData;

                    return NeomorphicCard(
                      key: ValueKey("$title-$index"),
                      title: title,
                      value: value,
                      icon: icon,
                      index: index,
                      controller: _contentController,
                      baseColor: baseColor,
                      accentColor: accentColor,
                    );
                  },
                ),

                const SizedBox(height: 60),
              ],
            ),

            // Neomorphic Back Button
            Positioned(
              top: 60,
              left: 20,
              child: SoftBackButton(
                onPressed: () => Navigator.pop(context),
                baseColor: baseColor,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Enhanced Neomorphic Card
class NeomorphicCard extends StatefulWidget {
  final String title, value;
  final IconData icon;
  final int index;
  final AnimationController controller;
  final Color baseColor;
  final Color accentColor;

  const NeomorphicCard({
    super.key,
    required this.title,
    required this.value,
    required this.icon,
    required this.index,
    required this.controller,
    required this.baseColor,
    required this.accentColor,
  });

  @override
  State<NeomorphicCard> createState() => _NeomorphicCardState();
}

class _NeomorphicCardState extends State<NeomorphicCard>
    with SingleTickerProviderStateMixin {
  bool _isPressed = false;
  late AnimationController _hoverController;

  @override
  void initState() {
    super.initState();
    _hoverController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 200),
    );
  }

  @override
  void dispose() {
    _hoverController.dispose();
    super.dispose();
  }

  // Custom Soft UI Container for icon
  Widget _buildIconContainer() {
    final Color shadowColor = const Color(0xFFBEBEBE);
    final Color lightColor = const Color(0xFFFFFFFF);
    const double depth = 6;

    return Container(
      height: 40,
      width: 40,
      decoration: BoxDecoration(
        color: widget.baseColor,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: shadowColor,
            offset: const Offset(4, 4),
            blurRadius: 4,
          ),
          BoxShadow(
            color: lightColor,
            offset: const Offset(-4, -4),
            blurRadius: 4,
          ),
        ],
      ),
      child: Icon(widget.icon, color: widget.accentColor, size: 20),
    );
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: widget.controller,
      child: SlideTransition(
        position: Tween<Offset>(
          begin: const Offset(0, 0.2),
          end: Offset.zero,
        ).animate(
          CurvedAnimation(
            parent: widget.controller,
            curve: Interval(
              0.4 + (widget.index * 0.05).clamp(0, 0.5),
              1.0,
              curve: Curves.easeOutCubic,
            ),
          ),
        ),
        child: GestureDetector(
          onTapDown: (_) => setState(() => _isPressed = true),
          onTapUp: (_) => setState(() => _isPressed = false),
          onTapCancel: () => setState(() => _isPressed = false),
          child: ClayContainer(
            height: 140,
            width: double.infinity,
            borderRadius: 20,
            color: widget.baseColor,
            depth: _isPressed ? -10 : 20,
            spread: 5,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _buildIconContainer(),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.title,
                        style: const TextStyle(
                          fontSize: 12,
                          color: Color(0xFF8E8E8E),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        widget.value,
                        style: const TextStyle(
                          fontSize: 14,
                          color: Color(0xFF4A4A4A),
                          fontWeight: FontWeight.bold,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
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

// Placeholder for SoftBackButton, NeomorphicAvatar and SoftParticlePainter
// You should replace these with your actual implementations
class SoftBackButton extends StatelessWidget {
  final VoidCallback onPressed;
  final Color baseColor;
  const SoftBackButton({
    super.key,
    required this.onPressed,
    required this.baseColor,
  });

  @override
  Widget build(BuildContext context) {
    return Bounce(
      onTap: onPressed,
      child: ClayContainer(
        height: 50,
        width: 50,
        borderRadius: 25,
        color: baseColor,
        depth: 15,
        child: const Icon(Icons.arrow_back, color: Color(0xFF4A4A4A)),
      ),
    );
  }
}

class NeomorphicAvatar extends StatelessWidget {
  final String? imagePath;
  final double size;
  final Color baseColor;
  const NeomorphicAvatar({
    super.key,
    this.imagePath,
    required this.size,
    required this.baseColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: size,
      width: size,
      decoration: BoxDecoration(shape: BoxShape.circle, color: baseColor),
      child: ClipOval(
        child:
            imagePath != null
                ? Image.memory(base64Decode(imagePath!), fit: BoxFit.cover)
                : const Icon(Icons.person, size: 80, color: Color(0xFFBEBEBE)),
      ),
    );
  }
}

class SoftParticlePainter extends CustomPainter {
  final Animation<double> controller;
  final Color baseColor;
  SoftParticlePainter({required this.controller, required this.baseColor});

  @override
  void paint(Canvas canvas, Size size) {
    // Implementation for particles
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
