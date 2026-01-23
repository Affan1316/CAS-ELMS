import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_cas_app_main/src/features/fee_feature/presentation/bloc/fee_admin_bloc.dart';
import 'package:flutter_cas_app_main/src/features/fee_feature/presentation/bloc/fee_admin_event.dart';
import 'package:flutter_cas_app_main/src/features/fee_feature/presentation/bloc/fee_admin_state.dart';

import 'package:flutter_cas_app_main/src/features/fee_feature/presentation/widgets/app_bar_tilte.dart';
import 'package:flutter_cas_app_main/src/features/fee_feature/presentation/widgets/main_card.dart';
import 'package:flutter_neumorphic_plus/flutter_neumorphic.dart';
import 'package:flutter/material.dart';

class CreateFeePlanPage extends StatefulWidget {
  final String studentId;
  final String name;
  final String groupId;

  const CreateFeePlanPage({
    super.key,
    required this.studentId,
    required this.groupId,
    required this.name,
  });

  @override
  State<CreateFeePlanPage> createState() => _CreateFeePlanPageState();
}

class _CreateFeePlanPageState extends State<CreateFeePlanPage> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController groupIdController = TextEditingController();
  final TextEditingController totalFeeController = TextEditingController(
    text: "80000",
  );
  final TextEditingController installmentsController = TextEditingController(
    text: "8",
  );
  final TextEditingController installmentAmountController =
      TextEditingController();

  late FeeAdminBloc bloc;

  @override
  void initState() {
    super.initState();
    bloc = context.read<FeeAdminBloc>();

    // totalFeeController.addListener(_recalculate);
    // installmentsController.addListener(_recalculate);
  }

  void _recalculate() {
    bloc.add(
      InstallmentPageCalculateInst(
        installments: installmentsController.text,
        totalFee: totalFeeController.text,
      ),
    );
  }

  @override
  void dispose() {
    nameController.dispose();
    groupIdController.dispose();
    totalFeeController.dispose();
    installmentsController.dispose();
    installmentAmountController.dispose();
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
        title: const AppBarTitle(),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(12),
          child: BlocListener<FeeAdminBloc, FeeAdminState>(
            listener: (context, state) {
              if (state is InstallmentCreatedSuccessState) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: const Text(
                      'Installment plan created successfully!',
                    ),
                    backgroundColor: const Color(0xFF10B981),
                    behavior: SnackBarBehavior.floating,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                );
                Navigator.of(context).pop();
              } else if (state is InstallmentCreatedFailureState) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(state.error),
                    backgroundColor: const Color(0xFFEF4444),
                    behavior: SnackBarBehavior.floating,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                );
              }
            },
            child: BlocBuilder<FeeAdminBloc, FeeAdminState>(
              bloc: bloc,
              builder: (context, state) {
                return MainCard(
                  studentId: widget.studentId,
                  groupId: widget.groupId,
                  name: widget.name,
                  totalFeeController: totalFeeController,
                  installmentsController: installmentsController,
                  installmentAmountController: installmentAmountController,
                  installmentAmount:
                      state is InstallmentPageInstallmentCalculatedState
                          ? state.installment
                          : 0,
                  isLoading: state is InstallmentCreatingState,
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
