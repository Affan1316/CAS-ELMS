import 'package:flutter/material.dart';

class OtpStep extends StatelessWidget {
  final TextEditingController otpController;
  final bool isLoading;
  final bool canResendOtp;
  final int otpCountdown;
  final VoidCallback onSubmit;
  final VoidCallback onResend;
  final String? Function(String?) validateOtp;

  const OtpStep({
    Key? key,
    required this.otpController,
    required this.isLoading,
    required this.canResendOtp,
    required this.otpCountdown,
    required this.onSubmit,
    required this.onResend,
    required this.validateOtp,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        TextFormField(
          controller: otpController,
          keyboardType: TextInputType.number,
          validator: validateOtp,
          textAlign: TextAlign.center,
          style: const TextStyle(
            fontSize: 24,
            letterSpacing: 8,
            fontWeight: FontWeight.bold,
          ),
          decoration: InputDecoration(
            labelText: 'OTP Code',
            hintText: '000000',
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.grey.shade300),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.blue.shade600),
            ),
          ),
        ),
        const SizedBox(height: 24),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Didn't receive the code? ",
              style: TextStyle(color: Colors.grey.shade600),
            ),
            GestureDetector(
              onTap: canResendOtp && !isLoading ? onResend : null,
              child: Text(
                canResendOtp ? 'Resend OTP' : 'Resend in ${otpCountdown}s',
                style: TextStyle(
                  color:
                      canResendOtp
                          ? Colors.blue.shade600
                          : Colors.grey.shade500,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 32),
        SizedBox(
          height: 48,
          child: ElevatedButton(
            onPressed: isLoading ? null : onSubmit,
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue.shade600,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              elevation: 2,
            ),
            child:
                isLoading
                    ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                      ),
                    )
                    : const Text(
                      'Next',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
          ),
        ),
      ],
    );
  }
}
