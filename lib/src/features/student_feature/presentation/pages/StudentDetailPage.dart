import 'dart:io';
import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter_cas_app_main/src/features/student_feature/data/student_entity_class.dart';
import 'package:flutter_neumorphic_plus/flutter_neumorphic.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:clay_containers/clay_containers.dart';
import 'package:spring/spring.dart';
import 'package:bounce/bounce.dart';

class StudentDetailPage extends StatefulWidget {
  final StudentEntityClass student;
  const StudentDetailPage({super.key, required this.student});

  @override
  State<StudentDetailPage> createState() => _StudentDetailPageState();
}

class _StudentDetailPageState extends State<StudentDetailPage>
    with TickerProviderStateMixin {
  File? _pickedImage;
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
  }

  @override
  void dispose() {
    _bgController.dispose();
    _contentController.dispose();
    _shakeController.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final image = await picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      setState(() => _pickedImage = File(image.path));
      _shakeController.forward().then((_) => _shakeController.reset());
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
                                      imagePath:
                                          _pickedImage?.path ??
                                          "assets/images/person 1-Photoroom.png",
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
      height: 45,
      width: 45,
      decoration: BoxDecoration(
        color: widget.baseColor,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          // Inner shadows for inset effect
          BoxShadow(
            color: shadowColor,
            offset: const Offset(-depth, -depth),
            blurRadius: depth,
            spreadRadius: -depth,
          ),
          BoxShadow(
            color: lightColor,
            offset: const Offset(depth, depth),
            blurRadius: depth,
            spreadRadius: -depth,
          ),
        ],
      ),
      child: Icon(widget.icon, color: widget.accentColor, size: 22),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ScaleTransition(
      scale: CurvedAnimation(
        parent: widget.controller,
        curve: Interval(
          0.3 + (widget.index * 0.1),
          1.0,
          curve: Curves.elasticOut,
        ),
      ),
      child: FadeTransition(
        opacity: CurvedAnimation(
          parent: widget.controller,
          curve: Interval(
            0.2 + (widget.index * 0.1),
            1.0,
            curve: Curves.easeOut,
          ),
        ),
        child: Bounce(
              onTap: () {
                setState(() => _isPressed = !_isPressed);
                _hoverController.forward().then((_) {
                  _hoverController.reverse();
                });
              },
              child: AnimatedBuilder(
                animation: _hoverController,
                builder: (context, child) {
                  return ClayContainer(
                    height: 160,
                    width: double.infinity,
                    borderRadius: 20,
                    depth: _isPressed ? -8 : 12,
                    spread: _isPressed ? 2 : 6,
                    color: widget.baseColor,
                    curveType:
                        _isPressed ? CurveType.concave : CurveType.convex,
                    child: Container(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Icon in soft container
                          _buildIconContainer(),

                          const SizedBox(height: 12),

                          Text(
                            widget.title,
                            style: const TextStyle(
                              fontSize: 11,
                              color: Color(0xFF888888),
                              fontWeight: FontWeight.w500,
                              letterSpacing: 0.2,
                            ),
                          ),

                          const SizedBox(height: 6),

                          Expanded(
                            child: Text(
                              widget.value,
                              style: const TextStyle(
                                fontSize: 13,
                                color: Color(0xFF4A4A4A),
                                fontWeight: FontWeight.w600,
                                height: 1.2,
                              ),
                              maxLines: 3,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            )
            .animate(onPlay: (controller) => controller.repeat(reverse: true))
            .shimmer(
              delay: Duration(milliseconds: widget.index * 300),
              duration: const Duration(seconds: 3),
              color: widget.accentColor.withOpacity(0.1),
            ),
      ),
    );
  }
}

// Neomorphic Avatar
class NeomorphicAvatar extends StatefulWidget {
  final String imagePath;
  final double size;
  final Color baseColor;

  const NeomorphicAvatar({
    super.key,
    required this.imagePath,
    this.size = 100,
    required this.baseColor,
  });

  @override
  State<NeomorphicAvatar> createState() => _NeomorphicAvatarState();
}

class _NeomorphicAvatarState extends State<NeomorphicAvatar>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 4),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isFile = widget.imagePath.startsWith('/');

    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return ClayContainer(
          height: widget.size,
          width: widget.size,
          borderRadius: widget.size / 2,
          depth: 8 + (4 * _controller.value).toInt(),
          spread: 2,
          color: widget.baseColor,
          curveType: CurveType.convex,
          child: Container(
            padding: const EdgeInsets.all(8),
            child: ClipOval(
              child: Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFF6C7CE7).withOpacity(0.3),
                      blurRadius: 20 * _controller.value,
                      spreadRadius: 2,
                    ),
                  ],
                ),
                child: ClipOval(
                  child:
                      isFile
                          ? Image.file(
                            File(widget.imagePath),
                            fit: BoxFit.cover,
                          )
                          : Image.asset(widget.imagePath, fit: BoxFit.cover),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

// Soft Back Button
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
      child: // Replace the MorpheusContainer in SoftBackButton
          ClayContainer(
        height: 50,
        width: 50,
        borderRadius: 25,
        color: baseColor,
        depth: 8, // Positive depth for raised effect
        spread: 2,
        curveType: CurveType.convex,
        child: const Icon(
          Icons.arrow_back_rounded,
          color: Color(0xFF4A4A4A),
          size: 24,
        ),
      ),
    );
  }
}

// Soft Particle Painter
class SoftParticlePainter extends CustomPainter {
  final AnimationController controller;
  final Color baseColor;

  SoftParticlePainter({required this.controller, required this.baseColor})
    : super(repaint: controller);

  @override
  void paint(Canvas canvas, Size size) {
    final paint =
        Paint()
          ..color = baseColor.withOpacity(0.3)
          ..style = PaintingStyle.fill;

    final shadowPaint =
        Paint()
          ..color = const Color(0xFFBEBEBE).withOpacity(0.1)
          ..style = PaintingStyle.fill
          ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 4);

    final time = controller.value * 2 * math.pi;

    for (int i = 0; i < 15; i++) {
      final x = size.width * (0.1 + 0.8 * math.sin(time + i * 0.8));
      final y = size.height * (0.1 + 0.8 * math.cos(time + i * 1.2));
      final radius = 3 + 2 * math.sin(time + i);

      // Draw shadow
      canvas.drawCircle(Offset(x + 2, y + 2), radius, shadowPaint);
      // Draw particle
      canvas.drawCircle(Offset(x, y), radius, paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
