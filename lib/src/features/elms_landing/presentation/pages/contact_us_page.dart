import 'package:flutter/material.dart';

class ContactUsPage extends StatelessWidget {
  const ContactUsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: const Text(
            'Contact us',
            style: TextStyle(color: Colors.black),
          ),
          backgroundColor: Colors.white,
          iconTheme: const IconThemeData(color: Colors.black),
          elevation: 0,
        ),
        body: LayoutBuilder(
          builder: (context, constraints) {
            final screenWidth = constraints.maxWidth;
            final isSmallScreen = screenWidth < 700;

            final horizontalPadding = isSmallScreen ? 16.0 : 24.0;
            final spacing = isSmallScreen ? 10.0 : 14.0;
            final titleSize = isSmallScreen ? 22.0 : 26.0;
            final subtitleSize = isSmallScreen ? 14.0 : 16.0;
            final textFieldFontSize = isSmallScreen ? 14.0 : 15.0;
            final buttonFontSize = isSmallScreen ? 14.0 : 15.0;

            return SingleChildScrollView(
              padding: EdgeInsets.symmetric(
                horizontal: horizontalPadding,
                vertical: 20,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  _buildHeader(titleSize, subtitleSize),
                  SizedBox(height: spacing + 4),
                  isSmallScreen
                      ? _buildColumnForm(
                        spacing,
                        textFieldFontSize,
                        buttonFontSize,
                      )
                      : _buildRowForm(
                        spacing,
                        textFieldFontSize,
                        buttonFontSize,
                      ),
                  SizedBox(height: spacing + 6),
                  _buildFooter(subtitleSize),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildHeader(double titleSize, double subtitleSize) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          "Get in Touch",
          style: TextStyle(
            fontSize: titleSize,
            fontWeight: FontWeight.bold,
            color: const Color(0xFF0E96C5),
          ),
        ),
        const SizedBox(height: 4),
        Text(
          "We'd love to hear from you!",
          style: TextStyle(fontSize: subtitleSize, color: Colors.black54),
        ),
      ],
    );
  }

  Widget _buildColumnForm(
    double spacing,
    double fontSize,
    double buttonFontSize,
  ) {
    return Column(
      children: [
        _CustomTextField(hint: "Full Name", fontSize: fontSize),
        SizedBox(height: spacing),
        _CustomTextField(hint: "Email Address", fontSize: fontSize),
        SizedBox(height: spacing),
        _CustomTextField(hint: "Message", fontSize: fontSize, maxLines: 4),
        SizedBox(height: spacing),
        _SubmitButton(fontSize: buttonFontSize),
      ],
    );
  }

  Widget _buildRowForm(double spacing, double fontSize, double buttonFontSize) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Column(
            children: [
              _CustomTextField(hint: "Full Name", fontSize: fontSize),
              SizedBox(height: spacing),
              _CustomTextField(hint: "Email Address", fontSize: fontSize),
            ],
          ),
        ),
        SizedBox(width: spacing),
        Expanded(
          child: Column(
            children: [
              _CustomTextField(
                hint: "Message",
                fontSize: fontSize,
                maxLines: 5,
              ),
              SizedBox(height: spacing),
              _SubmitButton(fontSize: buttonFontSize),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildFooter(double fontSize) {
    return Column(
      children: [
        Text(
          "Email: contact@cas.tech",
          style: TextStyle(fontSize: fontSize, color: Colors.black87),
        ),
        Text(
          "Phone: +92 300 1234567",
          style: TextStyle(fontSize: fontSize, color: Colors.black87),
        ),
        Text(
          "Location: Lahore, Pakistan",
          style: TextStyle(fontSize: fontSize, color: Colors.black87),
        ),
      ],
    );
  }
}

class _CustomTextField extends StatelessWidget {
  final String hint;
  final int maxLines;
  final double fontSize;

  const _CustomTextField({
    required this.hint,
    this.maxLines = 1,
    this.fontSize = 14,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      maxLines: maxLines,
      style: TextStyle(fontSize: fontSize, color: Colors.black),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: TextStyle(fontSize: fontSize),
        filled: true,
        fillColor: const Color(0xFFE8F5FB),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 12,
          vertical: 10,
        ),
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
  final double fontSize;

  const _SubmitButton({this.fontSize = 14});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () {},
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(0xFF0E96C5),
        padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 12),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
      child: Text(
        "Send Message",
        style: TextStyle(fontSize: fontSize, color: Colors.white),
      ),
    );
  }
}
