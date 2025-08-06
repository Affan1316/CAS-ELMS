import 'package:flutter/material.dart';

class ContactUsPage extends StatelessWidget {
  const ContactUsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isSmall = size.width < 700;

    return SafeArea(
      child: Scaffold(
        body: Container(
          width: double.infinity,
          height: size.height,
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildHeader(),
              isSmall ? _buildColumnForm() : _buildRowForm(),
              _buildFooter(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return const Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          "Get in Touch",
          style: TextStyle(
            fontSize: 26,
            fontWeight: FontWeight.bold,
            color: Color(0xFF0E96C5),
          ),
        ),
        SizedBox(height: 6),
        Text(
          "We'd love to hear from you!",
          style: TextStyle(
            fontSize: 16,
            color: Colors.black54,
          ),
        ),
      ],
    );
  }

  Widget _buildColumnForm() {
    return Column(
      children: [
        _CustomTextField(hint: "Full Name"),
        const SizedBox(height: 12),
        _CustomTextField(hint: "Email Address"),
        const SizedBox(height: 12),
        _CustomTextField(hint: "Message", maxLines: 4),
        const SizedBox(height: 16),
        _SubmitButton(),
      ],
    );
  }

  Widget _buildRowForm() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Column(
            children: [
              _CustomTextField(hint: "Full Name"),
              const SizedBox(height: 12),
              _CustomTextField(hint: "Email Address"),
            ],
          ),
        ),
        const SizedBox(width: 20),
        Expanded(
          child: Column(
            children: [
              _CustomTextField(hint: "Message", maxLines: 5),
              const SizedBox(height: 16),
              _SubmitButton(),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildFooter() {
    return const Column(
      children: [
        Text(
          "Email: contact@cas.tech",
          style: TextStyle(fontSize: 14),
        ),
        Text(
          "Phone: +92 300 1234567",
          style: TextStyle(fontSize: 14),
        ),
        Text(
          "Location: Lahore, Pakistan",
          style: TextStyle(fontSize: 14),
        ),
      ],
    );
  }
}

class _CustomTextField extends StatelessWidget {
  final String hint;
  final int maxLines;

  const _CustomTextField({
    required this.hint,
    this.maxLines = 1,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      maxLines: maxLines,
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: const TextStyle(fontSize: 14),
        filled: true,
        fillColor: Color(0xFFE8F5FB),
        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        border: OutlineInputBorder(
          borderSide: const BorderSide(color: Color(0xFF0E96C5)),
          borderRadius: BorderRadius.circular(12),
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: Color(0xFF0E96C5)),
          borderRadius: BorderRadius.circular(12),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: Color(0xFF0E96C5), width: 2),
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    );
  }
}

class _SubmitButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        // You can add form logic or backend integration here
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(0xFF0E96C5),
        padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 14),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
      child: const Text(
        "Send Message",
        style: TextStyle(fontSize: 14, color: Colors.white),
      ),
    );
  }
}
