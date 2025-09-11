import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_cas_app_main/src/features/installment_page/presentation/bloc/installment_page_bloc.dart';
import 'package:flutter_cas_app_main/src/features/installment_page/presentation/pages/widgets/input_field.dart';
import 'package:flutter_neumorphic_plus/flutter_neumorphic.dart';
import 'package:responsive_ui_kit/responsive_ui_kit.dart';

class MainCard extends StatelessWidget {
  const MainCard({
    super.key,
    required this.studentId,
    required this.totalFeeController,
    required this.installmentsController,
    required this.installmentAmountController,
    required this.installmentAmount,
    required this.isLoading,
  });

  final String studentId;
  final TextEditingController totalFeeController;
  final TextEditingController installmentsController;
  final TextEditingController installmentAmountController;
  final double installmentAmount;
  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: context.height * 0.6,
      child: ResponsiveCenteredBody(
        maxWidth: 500,
        constraints: BoxConstraints(maxHeight: 470),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Neumorphic(
            style: NeumorphicStyle(
              depth: 6,
              boxShape: NeumorphicBoxShape.roundRect(BorderRadius.circular(16)),
              color: const Color(0xFFF2F4F8),
            ),
            padding: const EdgeInsets.all(24),
            child: Column(
              children: [
                const Text(
                  "Total Fee",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
                const SizedBox(height: 10),
                InputField(
                  controller: totalFeeController,
                  hint: "Enter total fee",
                ),

                const SizedBox(height: 20),
                const Text(
                  "Installments",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
                const SizedBox(height: 10),
                InputField(
                  controller: installmentsController,
                  hint: "Enter installment count",
                ),

                const SizedBox(height: 20),
                const Text(
                  "Installment Amount",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
                const SizedBox(height: 10),
                Neumorphic(
                  style: NeumorphicStyle(
                    depth: -4,
                    boxShape: NeumorphicBoxShape.roundRect(
                      BorderRadius.circular(10),
                    ),
                  ),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 14,
                  ),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      installmentAmount.toStringAsFixed(2),
                      style: const TextStyle(fontSize: 16),
                    ),
                  ),
                ),

                const SizedBox(height: 30),
                NeumorphicButton(
                  onPressed:
                      isLoading
                          ? null
                          : () {
                            // Validate inputs
                            if (totalFeeController.text.trim().isEmpty) {
                              _showErrorSnackBar(
                                context,
                                'Please enter total fee',
                              );
                              return;
                            }

                            if (installmentsController.text.trim().isEmpty) {
                              _showErrorSnackBar(
                                context,
                                'Please enter number of installments',
                              );
                              return;
                            }

                            final totalFee = double.tryParse(
                              totalFeeController.text.trim(),
                            );
                            final installments = int.tryParse(
                              installmentsController.text.trim(),
                            );

                            if (totalFee == null || totalFee <= 0) {
                              _showErrorSnackBar(
                                context,
                                'Please enter a valid total fee',
                              );
                              return;
                            }

                            if (installments == null || installments <= 0) {
                              _showErrorSnackBar(
                                context,
                                'Please enter valid number of installments',
                              );
                              return;
                            }

                            // Trigger the create installment event
                            context.read<InstallmentPageBloc>().add(
                              CreateInstallmentEvent(
                                studentId: studentId,
                                totalFee: totalFee,
                                numberOfInstallments: installments,
                                amountPerMonth: installmentAmount,
                              ),
                            );
                          },
                  style: NeumorphicStyle(
                    color: const Color(0xFF4A9DBF),
                    shape: NeumorphicShape.flat,
                    boxShape: NeumorphicBoxShape.roundRect(
                      BorderRadius.circular(30),
                    ),
                    depth: 3,
                  ),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 40,
                    vertical: 12,
                  ),
                  child:
                      isLoading
                          ? const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: Colors.white,
                            ),
                          )
                          : const Text(
                            "Generate",
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showErrorSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: const Color(0xFFEF4444),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }
}
