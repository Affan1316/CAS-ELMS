import 'dart:io';
import 'package:flutter/material.dart';

class ShaderAvatar extends StatefulWidget {
  final String imagePath;
  final double size;

  const ShaderAvatar({super.key, required this.imagePath, this.size = 100});

  @override
  State<ShaderAvatar> createState() => _ShaderAvatarState();
}

class _ShaderAvatarState extends State<ShaderAvatar>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isFile = widget.imagePath.startsWith('/'); // Detects local file path

    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Container(
          width: widget.size,
          height: widget.size,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: Colors.purple.withOpacity(0.3),
                blurRadius: 30,
                spreadRadius: 5,
              ),
            ],
          ),
          child: ClipOval(
            child:
                isFile
                    ? Image.file(File(widget.imagePath), fit: BoxFit.cover)
                    : Image.asset(widget.imagePath, fit: BoxFit.cover),
          ),
        );
      },
    );
  }
}
