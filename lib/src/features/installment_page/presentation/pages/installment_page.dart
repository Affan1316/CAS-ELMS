import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_cas_app_main/src/features/installment_page/presentation/bloc/installment_page_bloc.dart';
import 'package:flutter_cas_app_main/src/features/installment_page/presentation/pages/widgets/app_bar_tilte.dart';
import 'package:flutter_cas_app_main/src/features/installment_page/presentation/pages/widgets/main_card.dart';
import 'package:flutter_neumorphic_plus/flutter_neumorphic.dart';


class CreateFeePlanPage extends StatefulWidget {
  const CreateFeePlanPage({super.key});

  @override
  State<CreateFeePlanPage> createState() => _CreateFeePlanPageState();
}

class _CreateFeePlanPageState extends State<CreateFeePlanPage> {
  final TextEditingController totalFeeController = TextEditingController(
    text: "80000",
  );
  final TextEditingController installmentsController = TextEditingController(
    text: "8",
  );
  final TextEditingController installmentAmountController =
      TextEditingController();
  double installmentAmount = 0;
  late InstallmentPageBloc bloc;

  @override
  void initState() {
    super.initState();
    bloc = context.read<InstallmentPageBloc>();
    totalFeeController.addListener(() {
      bloc.add(
        InstallmentPageCalculateInst(
          installments: installmentsController.text,
          totalFee: totalFeeController.text,
        ),
      );
    });
    installmentsController.addListener(() {
      bloc.add(
        InstallmentPageCalculateInst(
          installments: installmentsController.text,
          totalFee: totalFeeController.text,
        ),
      );
    });
    // _calculateInstallment();
  }

  // void _calculateInstallment() {
  //   final total = double.tryParse(totalFeeController.text) ?? 0;
  //   final count = int.tryParse(installmentsController.text) ?? 1;
  //   setState(() {
  //     installmentAmount = count > 0 ? total / count : 0;
  //   });
  // }

  @override
  void dispose() {
    totalFeeController.dispose();
    installmentsController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF2F4F8),
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        backgroundColor: const Color(0xFF4A9DBF),
        centerTitle: true,
        leading: GestureDetector(
          onTap: () => Navigator.pop(context),
          child: const Icon(Icons.arrow_back_ios, color: Colors.white),
        ),
        title: AppBarTitle(),
      ),
      body: SafeArea(
        child: Stack(
          fit: StackFit.expand,
          children: [
            // Main Card
            Align(
              alignment: Alignment.center,
              child: BlocBuilder<InstallmentPageBloc, InstallmentPageState>(
                bloc: context.read<InstallmentPageBloc>(),
                builder: (context, state) {
                  return MainCard(
                    totalFeeController: totalFeeController,
                    installmentsController: installmentsController,
                    installmentAmountController: installmentAmountController,
                    installmentAmount:
                        state is InstallmentPageintallmentCalculatedState
                        ? state.installment
                        : 0,
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
