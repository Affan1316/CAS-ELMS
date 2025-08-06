import 'package:flutter_neumorphic_plus/flutter_neumorphic.dart';
import 'package:installment_page/installment_page/presentation/widgets/input_field.dart';
import 'package:responsive_ui_kit/responsive_ui_kit.dart';

class MainCard extends StatelessWidget {
  const MainCard({
    super.key,
    required this.totalFeeController,
    required this.installmentsController,
    required this.installmentAmountController,
    required this.installmentAmount,
  });
  final TextEditingController totalFeeController;
  final TextEditingController installmentsController;
  final TextEditingController installmentAmountController;
  final double installmentAmount;

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
                  onPressed: () {
                    //TODO :  handle generate btn
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
                  child: const Text(
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
}
