import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_cas_app_main/src/features/super_admin_fee_feature/presentation/widgets/notification_list_widget.dart';
import 'package:flutter_cas_app_main/src/features/super_admin_fee_feature/presentation/bloc/super_admin_fee_bloc.dart';
import 'package:flutter_cas_app_main/src/features/super_admin_fee_feature/presentation/bloc/super_admin_fee_event.dart';
import 'package:flutter_cas_app_main/src/features/super_admin_fee_feature/presentation/bloc/super_admin_fee_state.dart';
import 'package:flutter_neumorphic_plus/flutter_neumorphic.dart';

class SuperAdminFeeNotificationsScreen extends StatefulWidget {
  const SuperAdminFeeNotificationsScreen({super.key});

  @override
  State<SuperAdminFeeNotificationsScreen> createState() =>
      _SuperAdminFeeNotificationsScreenState();
}

class _SuperAdminFeeNotificationsScreenState
    extends State<SuperAdminFeeNotificationsScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      context.read<SuperAdminFeeBloc>().add(LoadSuperAdminFeeNotifications());
    });
  }

  Future<void> _refreshNotifications() async {
    context.read<SuperAdminFeeBloc>().add(LoadSuperAdminFeeNotifications());
  }

  @override
  Widget build(BuildContext context) {
    return NeumorphicTheme(
      theme: const NeumorphicThemeData(
        baseColor: Color(0xFFE6E8F0),
        lightSource: LightSource.topLeft,
        depth: 4,
      ),
      child: Scaffold(
        backgroundColor: const Color(0xFFE6E8F0),
        appBar: NeumorphicAppBar(
          title: const Text(
            "Pending Notifications",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          centerTitle: true,
          actions: [
            NeumorphicButton(
              tooltip: "Refresh",
              style: const NeumorphicStyle(
                boxShape: NeumorphicBoxShape.circle(),
                depth: 3,
              ),
              padding: const EdgeInsets.all(8),
              onPressed: _refreshNotifications,
              child: const Icon(Icons.refresh, size: 22),
            ),
            const SizedBox(width: 8),
          ],
        ),
        body: BlocBuilder<SuperAdminFeeBloc, SuperAdminFeeState>(
          builder: (context, state) {
            return RefreshIndicator(
              onRefresh: _refreshNotifications,
              color: Colors.blueGrey,
              backgroundColor: const Color(0xFFE6E8F0),
              displacement: 50,
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 400),
                child: _buildListBody(state),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildListBody(SuperAdminFeeState state) {
    if (state is SuperAdminFeeLoadingState || state is ConfirmingPayment) {
      return _buildShimmerList();
    }

    if (state is SuperAdminFeeErrorState) {
      return Center(
        key: const ValueKey("error"),
        child: Text(
          "Error: ${state.message}",
          style: const TextStyle(color: Colors.redAccent),
        ),
      );
    }

    if (state is SuperAdminFeeLoadedState) {
      return const NotificationListWidget(
        key: ValueKey("data"),
        filterStatus: "Pending",
      );
    }
    // if (state is DeletingNotification) {
    //   return _buildShimmerList();
    // }

    // if (state is DeletedNotification) {
    //   return const NotificationListWidget(
    //     key: ValueKey("data"),
    //     filterStatus: "Pending",
    //   );
    // }

    return const SizedBox.shrink();
  }

  /// --- Loading shimmer-style skeleton ---
  Widget _buildShimmerList() {
    return ListView.separated(
      key: const ValueKey("loading"),
      physics: const AlwaysScrollableScrollPhysics(),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
      itemBuilder:
          (_, __) => Neumorphic(
            style: NeumorphicStyle(
              depth: 3,
              color: const Color(0xFFE6E8F0),
              boxShape: NeumorphicBoxShape.roundRect(BorderRadius.circular(20)),
            ),
            child: Container(
              height: 110, // 🔥 Taller = feels more “real”
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: Colors.grey.shade300,
              ),
            ),
          ),
      separatorBuilder: (_, __) => const SizedBox(height: 18),
      itemCount: 5,
    );
  }
}
