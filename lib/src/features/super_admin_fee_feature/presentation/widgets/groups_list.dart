import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_cas_app_main/src/features/super_admin_fee_feature/presentation/bloc/super_admin_fee_bloc.dart';
import 'package:flutter_cas_app_main/src/features/super_admin_fee_feature/presentation/bloc/super_admin_fee_event.dart';
import 'package:flutter_cas_app_main/src/features/super_admin_fee_feature/presentation/bloc/super_admin_fee_state.dart';
import 'package:flutter_cas_app_main/src/features/super_admin_fee_feature/presentation/pages/group_fee_history_page.dart';
import 'package:flutter_cas_app_main/src/features/super_admin_fee_feature/presentation/widgets/group_tile.dart';
import 'package:flutter_cas_app_main/src/features/super_admin_fee_feature/presentation/widgets/neomorphic_container.dart';
import 'package:flutter_cas_app_main/src/features/super_admin_fee_feature/presentation/pages/super_admin_groups_page.dart';

class GroupsList extends StatelessWidget {
  const GroupsList({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SuperAdminFeeBloc, SuperAdminFeeState>(
      buildWhen: (previous, current) {
        // Only rebuild when states are relevant to groups
        return current is LoadingGroupNames ||
            current is GroupNamesLoaded ||
            (current is SuperAdminFeeErrorState &&
                previous is LoadingGroupNames);
      },
      builder: (context, state) {
        if (state is LoadingGroupNames) {
          return Center(
            child: NeomorphicContainer(
              child: const CircularProgressIndicator(),
            ),
          );
        }

        if (state is GroupNamesLoaded) {
          final groups = state.listOfNames;

          if (groups.isEmpty) {
            return Center(
              child: NeomorphicContainer(
                child: Text(
                  'No groups found',
                  style: TextStyle(color: Colors.grey[600], fontSize: 16),
                ),
              ),
            );
          }

          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: ListView.builder(
              itemCount: groups.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: 16.0),
                  child: GroupTile(
                    groupName: groups[index],
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder:
                              (context) =>
                                  GroupFeeHistoryPage(groupName: groups[index]),
                        ),
                      );
                    },
                  ),
                );
              },
            ),
          );
        }

        if (state is SuperAdminFeeErrorState) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                NeomorphicContainer(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.error, color: Colors.grey[600], size: 40),
                      const SizedBox(height: 8),
                      Text(
                        'Error loading groups',
                        style: TextStyle(color: Colors.grey[600], fontSize: 16),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                NeomorphicContainer(
                  onTap: () {
                    context.read<SuperAdminFeeBloc>().add(GetGroupNamesEvent());
                  },
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24.0,
                      vertical: 12.0,
                    ),
                    child: Text(
                      'Retry',
                      style: TextStyle(
                        color: Colors.grey[700],
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        }

        // Initial state - show empty container or loading
        return const SizedBox.shrink();
      },
    );
  }
}
