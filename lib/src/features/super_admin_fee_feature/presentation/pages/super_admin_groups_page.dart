import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_cas_app_main/src/features/super_admin_fee_feature/presentation/bloc/super_admin_fee_bloc.dart';
import 'package:flutter_cas_app_main/src/features/super_admin_fee_feature/presentation/bloc/super_admin_fee_event.dart';
import 'package:flutter_cas_app_main/src/features/super_admin_fee_feature/presentation/bloc/super_admin_fee_state.dart';
import 'package:flutter_cas_app_main/src/features/super_admin_fee_feature/presentation/pages/group_fee_history_page.dart';
import 'package:flutter_cas_app_main/src/features/super_admin_fee_feature/presentation/widgets/groups_list.dart';
import 'package:flutter_cas_app_main/src/features/super_admin_fee_feature/presentation/widgets/neomorphic_container.dart';

class SuperAdminGroupsPage extends StatefulWidget {
  const SuperAdminGroupsPage({super.key});

  @override
  State<SuperAdminGroupsPage> createState() => _SuperAdminGroupsPageState();
}

class _SuperAdminGroupsPageState extends State<SuperAdminGroupsPage> {
  @override
  void initState() {
    super.initState();
    // Trigger the event after widget is built
    context.read<SuperAdminFeeBloc>().add(GetGroupNamesEvent());
  }

  // @override
  // void didChangeDependencies() {
  //   super.didChangeDependencies();
  //   // This will be called every time the page becomes visible
  //   WidgetsBinding.instance.addPostFrameCallback((_) {
  //     if (mounted) {
  //       context.read<SuperAdminFeeBloc>().add(GetGroupNamesEvent());
  //     }
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFE6E7EE),
      appBar: AppBar(
        backgroundColor: const Color(0xFFE6E7EE),
        elevation: 0,
        title: Text(
          'Groups',
          style: TextStyle(
            color: Colors.grey[700],
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.grey[700]),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: const GroupsList(),
    );
  }
}
