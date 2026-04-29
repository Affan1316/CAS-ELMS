import 'package:flutter/material.dart';

class ContactUsPage extends StatelessWidget {
  const ContactUsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: const Color(0xFFF0F9FD),
        appBar: AppBar(
          title: const Text(
            'Contact us',
            style: TextStyle(
              color: Colors.black87,
              fontWeight: FontWeight.w500,
            ),
          ),
          backgroundColor: Colors.white,
          iconTheme: const IconThemeData(color: Colors.black87),
          elevation: 0,
          bottom: PreferredSize(
            preferredSize: const Size.fromHeight(1),
            child: Container(height: 1, color: const Color(0xFFE0EFF5)),
          ),
        ),
        body: LayoutBuilder(
          builder: (context, constraints) {
            final screenWidth = constraints.maxWidth;
            final isSmallScreen = screenWidth < 700;
            final horizontalPadding = isSmallScreen ? 16.0 : 32.0;
            final spacing = isSmallScreen ? 12.0 : 16.0;
            final titleSize = isSmallScreen ? 22.0 : 26.0;
            final subtitleSize = isSmallScreen ? 13.0 : 15.0;
            final textFieldFontSize = isSmallScreen ? 14.0 : 15.0;
            final buttonFontSize = isSmallScreen ? 14.0 : 15.0;

            return SingleChildScrollView(
              padding: EdgeInsets.symmetric(
                horizontal: horizontalPadding,
                vertical: 24,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  _buildHeader(titleSize, subtitleSize),
                  SizedBox(height: spacing + 8),
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
                  SizedBox(height: spacing + 8),
                  _buildFooter(subtitleSize),
                  const SizedBox(height: 16),
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
        Container(
          width: 68,
          height: 68,
          decoration: BoxDecoration(
            color: const Color(0xFFE8F5FB),
            shape: BoxShape.circle,
            border: Border.all(color: const Color(0xFFB8DFF0), width: 1.5),
          ),
          child: const Icon(
            Icons.chat_bubble_outline_rounded,
            color: Color(0xFF0E96C5),
            size: 30,
          ),
        ),
        const SizedBox(height: 14),
        Text(
          "Get in Touch",
          style: TextStyle(
            fontSize: titleSize,
            fontWeight: FontWeight.bold,
            color: const Color(0xFF0E96C5),
            letterSpacing: 0.2,
          ),
        ),
        const SizedBox(height: 6),
        Text(
          "We'd love to hear from you!",
          style: TextStyle(fontSize: subtitleSize, color: Colors.black45),
        ),
        const SizedBox(height: 12),
        Container(
          width: 40,
          height: 3,
          decoration: BoxDecoration(
            color: const Color(0xFF0E96C5).withOpacity(0.45),
            borderRadius: BorderRadius.circular(4),
          ),
        ),
      ],
    );
  }

  Widget _buildColumnForm(
    double spacing,
    double fontSize,
    double buttonFontSize,
  ) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFF7FCFE),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFD4EDF6)),
      ),
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          _CustomTextField(
            hint: "Full Name",
            fontSize: fontSize,
            icon: Icons.person_outline_rounded,
          ),
          SizedBox(height: spacing),
          _CustomTextField(
            hint: "Email Address",
            fontSize: fontSize,
            icon: Icons.email_outlined,
          ),
          SizedBox(height: spacing),
          _CustomTextField(
            hint: "Write your message here...",
            fontSize: fontSize,
            maxLines: 4,
            icon: Icons.chat_outlined,
          ),
          SizedBox(height: spacing + 4),
          _SubmitButton(fontSize: buttonFontSize),
        ],
      ),
    );
  }

  Widget _buildRowForm(double spacing, double fontSize, double buttonFontSize) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFF7FCFE),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFD4EDF6)),
      ),
      padding: const EdgeInsets.all(24),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              children: [
                _CustomTextField(
                  hint: "Full Name",
                  fontSize: fontSize,
                  icon: Icons.person_outline_rounded,
                ),
                SizedBox(height: spacing),
                _CustomTextField(
                  hint: "Email Address",
                  fontSize: fontSize,
                  icon: Icons.email_outlined,
                ),
              ],
            ),
          ),
          SizedBox(width: spacing),
          Expanded(
            child: Column(
              children: [
                _CustomTextField(
                  hint: "Write your message here...",
                  fontSize: fontSize,
                  maxLines: 5,
                  icon: Icons.chat_outlined,
                ),
                SizedBox(height: spacing),
                _SubmitButton(fontSize: buttonFontSize),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFooter(double fontSize) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFD4EDF6)),
      ),
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "CONTACT DETAILS",
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w600,
              color: const Color(0xFF0E96C5),
              letterSpacing: 0.8,
            ),
          ),
          const SizedBox(height: 14),
          _ContactInfoRow(
            icon: Icons.email_outlined,
            label: "nomanameerkhan@gmail.com",
            fontSize: fontSize,
          ),
          const SizedBox(height: 12),
          _ContactInfoRow(
            icon: Icons.phone_outlined,
            label: "+92 321 6823134",
            fontSize: fontSize,
          ),
          const SizedBox(height: 12),
          _ContactInfoRow(
            icon: Icons.location_on_outlined,
            label:
                "706-c Stellite Town Block C, Near HBL Bank, Hussani Chowk, Bahawalpur, Punjab, Pakistan",
            fontSize: fontSize,
          ),
        ],
      ),
    );
  }
}

class _ContactInfoRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final double fontSize;

  const _ContactInfoRow({
    required this.icon,
    required this.label,
    required this.fontSize,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 34,
          height: 34,
          decoration: const BoxDecoration(
            color: Color(0xFFE8F5FB),
            shape: BoxShape.circle,
          ),
          child: Icon(icon, color: const Color(0xFF0E96C5), size: 16),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.only(top: 7),
            child: Text(
              label,
              style: TextStyle(
                fontSize: fontSize,
                color: Colors.black87,
                height: 1.4,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _CustomTextField extends StatelessWidget {
  final String hint;
  final int maxLines;
  final double fontSize;
  final IconData? icon;

  const _CustomTextField({
    required this.hint,
    this.maxLines = 1,
    this.fontSize = 14,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      maxLines: maxLines,
      style: TextStyle(fontSize: fontSize, color: Colors.black87),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: TextStyle(fontSize: fontSize, color: Colors.black38),
        prefixIcon:
            icon != null
                ? Padding(
                  padding: const EdgeInsets.only(left: 12, right: 8),
                  child: Icon(icon, color: const Color(0xFF0E96C5), size: 18),
                )
                : null,
        prefixIconConstraints: const BoxConstraints(minWidth: 0, minHeight: 0),
        filled: true,
        fillColor: Colors.white,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 14,
          vertical: 13,
        ),
        border: OutlineInputBorder(
          borderSide: const BorderSide(color: Color(0xFFB8DFF0)),
          borderRadius: BorderRadius.circular(12),
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: Color(0xFFB8DFF0)),
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
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton.icon(
        onPressed: () {},
        icon: const Icon(Icons.send_rounded, size: 17, color: Colors.white),
        label: Text(
          "Send Message",
          style: TextStyle(
            fontSize: fontSize,
            color: Colors.white,
            letterSpacing: 0.2,
          ),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF0E96C5),
          padding: const EdgeInsets.symmetric(vertical: 14),
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
    );
  }
}
