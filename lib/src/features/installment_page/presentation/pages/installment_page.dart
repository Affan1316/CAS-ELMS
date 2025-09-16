// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:flutter_cas_app_main/src/features/installment_page/presentation/bloc/installment_page_bloc.dart';
// import 'package:flutter_cas_app_main/src/features/installment_page/presentation/pages/widgets/app_bar_tilte.dart';
// import 'package:flutter_cas_app_main/src/features/installment_page/presentation/pages/widgets/main_card.dart';
// import 'package:flutter_neumorphic_plus/flutter_neumorphic.dart';

// class CreateFeePlanPage extends StatefulWidget {
//   final String studentId;

//   const CreateFeePlanPage({super.key, required this.studentId});

//   @override
//   State<CreateFeePlanPage> createState() => _CreateFeePlanPageState();
// }

// class _CreateFeePlanPageState extends State<CreateFeePlanPage> {
//   final TextEditingController totalFeeController = TextEditingController(
//     text: "80000",
//   );
//   final TextEditingController installmentsController = TextEditingController(
//     text: "8",
//   );
//   final TextEditingController installmentAmountController =
//       TextEditingController();
//   double installmentAmount = 0;
//   late InstallmentPageBloc bloc;

//   @override
//   void initState() {
//     super.initState();
//     bloc = context.read<InstallmentPageBloc>();
//     totalFeeController.addListener(() {
//       bloc.add(
//         InstallmentPageCalculateInst(
//           installments: installmentsController.text,
//           totalFee: totalFeeController.text,
//         ),
//       );
//     });
//     installmentsController.addListener(() {
//       bloc.add(
//         InstallmentPageCalculateInst(
//           installments: installmentsController.text,
//           totalFee: totalFeeController.text,
//         ),
//       );
//     });
//   }

//   @override
//   void dispose() {
//     totalFeeController.dispose();
//     installmentsController.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: const Color(0xFFF2F4F8),
//       resizeToAvoidBottomInset: true,
//       appBar: AppBar(
//         backgroundColor: const Color(0xFF4A9DBF),
//         centerTitle: true,
//         leading: GestureDetector(
//           onTap: () => Navigator.pop(context),
//           child: const Icon(Icons.arrow_back_ios, color: Colors.white),
//         ),
//         title: AppBarTitle(),
//       ),
//       body: SafeArea(
//         child: BlocListener<InstallmentPageBloc, InstallmentPageState>(
//           listener: (context, state) {
//             if (state is InstallmentCreatedSuccessState) {
//               ScaffoldMessenger.of(context).showSnackBar(
//                 SnackBar(
//                   content: const Text('Installment plan created successfully!'),
//                   backgroundColor: const Color(0xFF10B981),
//                   behavior: SnackBarBehavior.floating,
//                   shape: RoundedRectangleBorder(
//                     borderRadius: BorderRadius.circular(12),
//                   ),
//                 ),
//               );
//               Navigator.of(context).pop();
//             } else if (state is InstallmentCreatedFailureState) {
//               ScaffoldMessenger.of(context).showSnackBar(
//                 SnackBar(
//                   content: Text(state.error),
//                   backgroundColor: const Color(0xFFEF4444),
//                   behavior: SnackBarBehavior.floating,
//                   shape: RoundedRectangleBorder(
//                     borderRadius: BorderRadius.circular(12),
//                   ),
//                 ),
//               );
//             }
//           },
//           child: Stack(
//             fit: StackFit.expand,
//             children: [
//               Align(
//                 alignment: Alignment.center,
//                 child: BlocBuilder<InstallmentPageBloc, InstallmentPageState>(
//                   bloc: context.read<InstallmentPageBloc>(),
//                   builder: (context, state) {
//                     return MainCard(
//                       studentId: widget.studentId,
//                       totalFeeController: totalFeeController,
//                       installmentsController: installmentsController,
//                       installmentAmountController: installmentAmountController,
//                       installmentAmount:
//                           state is InstallmentPageintallmentCalculatedState
//                               ? state.installment
//                               : 0,
//                       isLoading: state is InstallmentCreatingState,
//                     );
//                   },
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_cas_app_main/src/features/installment_page/presentation/bloc/installment_page_bloc.dart';
import 'package:flutter_cas_app_main/src/features/installment_page/presentation/bloc/installment_page_event.dart';
import 'package:flutter_cas_app_main/src/features/installment_page/presentation/bloc/installment_page_state.dart';
import 'package:flutter_cas_app_main/src/features/installment_page/presentation/pages/widgets/app_bar_tilte.dart';
import 'package:flutter_cas_app_main/src/features/installment_page/presentation/pages/widgets/main_card.dart';
import 'package:flutter_neumorphic_plus/flutter_neumorphic.dart';

class CreateFeePlanPage extends StatefulWidget {
  final String studentId;

  const CreateFeePlanPage({super.key, required this.studentId});

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
        child: BlocListener<InstallmentPageBloc, InstallmentPageState>(
          listener: (context, state) {
            if (state is InstallmentCreatedSuccessState) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: const Text('Installment plan created successfully!'),
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
          child: BlocBuilder<InstallmentPageBloc, InstallmentPageState>(
            bloc: bloc,
            builder: (context, state) {
              return MainCard(
                studentId: widget.studentId,
                nameController: nameController,
                groupIdController: groupIdController,
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
    );
  }
}
