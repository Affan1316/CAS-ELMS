import 'package:flutter/material.dart';

// ── Tokens ────────────────────────────────────────────────────────────────────

class _T {
  static const cardBg = Color(0xFFFFFFFF);
  static const surfaceBg = Color(0xFFEAEAEA);
  static const heroBg = Color(0xFF111111);
  static const inkDeep = Color(0xFF111111);
  static const inkMid = Color(0xFF555555);
  static const inkSoft = Color(0xFFAAAAAA);
  static const divider = Color(0xFFEBEBEB);
  static const errorColor = Color(0xFFE24B4A);
  static const errorBg = Color(0xFFFCEBEB);
}

// ── Widget ────────────────────────────────────────────────────────────────────

class SignUpConfirmPasswordField extends StatefulWidget {
  // ── LOGIC UNCHANGED: same constructor signature ───────────────────────────
  final TextEditingController controller;
  final String? Function(String?) validator;
  final bool isPasswordVisible;
  final VoidCallback onToggleVisibility;

  const SignUpConfirmPasswordField({
    super.key,
    required this.controller,
    required this.validator,
    required this.isPasswordVisible,
    required this.onToggleVisibility,
  });

  @override
  State<SignUpConfirmPasswordField> createState() =>
      _SignUpConfirmPasswordFieldState();
}

class _SignUpConfirmPasswordFieldState
    extends State<SignUpConfirmPasswordField> {
  final _focusNode = FocusNode();
  bool _isFocused = false;
  String? _errorText;

  @override
  void initState() {
    super.initState();
    _focusNode.addListener(
      () => setState(() => _isFocused = _focusNode.hasFocus),
    );
  }

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final hasError = _errorText != null;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AnimatedContainer(
          duration: const Duration(milliseconds: 150),
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          decoration: BoxDecoration(
            color: hasError ? _T.errorBg : _T.cardBg,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color:
                  hasError
                      ? _T.errorColor
                      : _isFocused
                      ? _T.heroBg
                      : _T.divider,
              width: (_isFocused || hasError) ? 1.5 : 1.0,
            ),
          ),
          child: Row(
            children: [
              // Icon bed
              AnimatedContainer(
                duration: const Duration(milliseconds: 150),
                width: 34,
                height: 34,
                decoration: BoxDecoration(
                  color:
                      hasError
                          ? _T.errorColor
                          : _isFocused
                          ? _T.heroBg
                          : _T.surfaceBg,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Center(
                  child: Icon(
                    Icons.lock_outline_rounded,
                    size: 15,
                    color: (_isFocused || hasError) ? Colors.white : _T.inkMid,
                  ),
                ),
              ),
              const SizedBox(width: 12),

              // Label + input
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'CONFIRM PASSWORD',
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.w600,
                        letterSpacing: 0.7,
                        color: hasError ? _T.errorColor : _T.inkSoft,
                      ),
                    ),
                    const SizedBox(height: 3),
                    // ── LOGIC UNCHANGED: validator, obscureText ───────────
                    TextFormField(
                      controller: widget.controller,
                      focusNode: _focusNode,
                      obscureText: !widget.isPasswordVisible,
                      validator: (v) {
                        final err = widget.validator(v);
                        WidgetsBinding.instance.addPostFrameCallback(
                          (_) => setState(() => _errorText = err),
                        );
                        return err;
                      },
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        color: _T.inkDeep,
                        letterSpacing: -0.1,
                      ),
                      decoration: const InputDecoration(
                        hintText: 'Re-enter your password',
                        hintStyle: TextStyle(
                          fontSize: 13,
                          color: _T.inkSoft,
                          fontWeight: FontWeight.w400,
                        ),
                        border: InputBorder.none,
                        isDense: true,
                        contentPadding: EdgeInsets.zero,
                        errorStyle: TextStyle(height: 0, fontSize: 0),
                      ),
                    ),
                  ],
                ),
              ),

              // Visibility toggle — LOGIC UNCHANGED
              GestureDetector(
                onTap: widget.onToggleVisibility,
                child: Padding(
                  padding: const EdgeInsets.only(left: 8),
                  child: Icon(
                    widget.isPasswordVisible
                        ? Icons.visibility_outlined
                        : Icons.visibility_off_outlined,
                    size: 18,
                    color: _T.inkSoft,
                  ),
                ),
              ),
            ],
          ),
        ),

        if (hasError)
          Padding(
            padding: const EdgeInsets.only(top: 5, left: 4),
            child: Text(
              _errorText!,
              style: const TextStyle(
                fontSize: 11,
                color: _T.errorColor,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
      ],
    );
  }
}
