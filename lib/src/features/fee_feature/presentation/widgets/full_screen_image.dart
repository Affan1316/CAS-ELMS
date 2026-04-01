import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:responsive_ui_kit/responsive_ui_kit.dart';

class FullScreenImage extends StatefulWidget {
  final String imageBase64String;

  const FullScreenImage({super.key, required this.imageBase64String});

  @override
  State<FullScreenImage> createState() => _FullScreenImageState();
}

class _FullScreenImageState extends State<FullScreenImage>
    with SingleTickerProviderStateMixin {
  final TransformationController _controller = TransformationController();
  late AnimationController _animController;
  Animation<Matrix4>? _animation;
  double _currentScale = 1.0;

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 250),
    )..addListener(() {
      _controller.value = _animation?.value ?? Matrix4.identity();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    _animController.dispose();
    super.dispose();
  }

  void _handleDoubleTap(Offset position) {
    final double currentScale = _controller.value.getMaxScaleOnAxis();
    final double targetScale = (currentScale == 1.0) ? 2.5 : 1.0;

    final x = position.dx;
    final y = position.dy;

    // Analytic geometry: translate(-p) → scale(s) → translate(p)
    final Matrix4 zoomed =
        Matrix4.identity()
          ..translate(x, y)
          ..scale(targetScale)
          ..translate(-x, -y);

    _animation = Matrix4Tween(
      begin: _controller.value,
      end: zoomed,
    ).animate(CurvedAnimation(parent: _animController, curve: Curves.easeOut));

    _animController.forward(from: 0);
    setState(() => _currentScale = targetScale);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          GestureDetector(
            onTap: () => Navigator.pop(context),
            onDoubleTapDown:
                (details) => _handleDoubleTap(details.localPosition),
            child: Center(
              child: Hero(
                tag: widget.imageBase64String,
                child: InteractiveViewer(
                  transformationController: _controller,
                  minScale: 1.0,
                  maxScale: 4.0,
                  clipBehavior: Clip.none,
                  child: SizedBox(
                    width: context.width * 0.8,
                    height: context.height * 0.6,
                    child:
                        widget.imageBase64String.isEmpty ||
                                widget.imageBase64String == '' ||
                                widget.imageBase64String == '—'
                            ? Image.asset(
                              "assets/images/student-male.png",
                              fit: BoxFit.contain,
                            )
                            : Image.memory(
                              base64Decode(widget.imageBase64String),
                              fit: BoxFit.contain,
                            ),
                  ),
                  onInteractionUpdate: (_) {
                    setState(() {
                      _currentScale = _controller.value
                          .getMaxScaleOnAxis()
                          .clamp(1.0, 4.0);
                    });
                  },
                ),
              ),
            ),
          ),

          // Scale indicator
          Positioned(
            right: 12,
            top: 40,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              decoration: BoxDecoration(
                color: Colors.black45,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                '${(_currentScale * 100).toStringAsFixed(0)}%',
                style: const TextStyle(color: Colors.white, fontSize: 14),
              ),
            ),
          ),

          // Close button
          Positioned(
            left: 12,
            top: 40,
            child: Material(
              color: Colors.black45,
              shape: const CircleBorder(),
              child: IconButton(
                icon: const Icon(Icons.close, color: Colors.white),
                onPressed: () => Navigator.pop(context),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
