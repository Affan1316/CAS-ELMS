import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_cas_app_main/src/features/fee_feature/presentation/bloc/fee_admin_bloc.dart';
import 'package:flutter_cas_app_main/src/features/fee_feature/presentation/bloc/fee_admin_event.dart';
import 'package:flutter_cas_app_main/src/features/fee_feature/presentation/bloc/fee_admin_state.dart';
import 'package:flutter_cas_app_main/src/features/fee_feature/presentation/pages/group_members_screen.dart';
import 'package:flutter_cas_app_main/src/features/fee_feature/presentation/widgets/gradient_background.dart';
import 'package:flutter_cas_app_main/src/features/fee_feature/presentation/widgets/neu_card.dart';
import 'package:flutter_cas_app_main/src/features/fee_feature/presentation/widgets/responsive_padding.dart';
import 'package:flutter_cas_app_main/src/features/fee_feature/presentation/widgets/responsive_text.dart';
import 'package:flutter_cas_app_main/src/features/fee_feature/presentation/widgets/screen_header.dart';
import 'package:flutter_cas_app_main/src/features/fee_feature/presentation/widgets/search_field.dart';
import 'package:flutter_cas_app_main/src/features/group/domain/entities/group_entity.dart';

class GroupsListScreen extends StatefulWidget {
  const GroupsListScreen({
    super.key,
    required this.isNavigateToAttendence,
    required this.isNavigateToWorkShopGraphPage,
  });
  final bool isNavigateToAttendence;
  final bool isNavigateToWorkShopGraphPage;

  @override
  State<GroupsListScreen> createState() => _GroupsListScreenState();
}

class _GroupsListScreenState extends State<GroupsListScreen> {
  final TextEditingController _searchController = TextEditingController();
  Timer? _debounceTimer;

  @override
  void initState() {
    super.initState();
    context.read<FeeAdminBloc>().add(FeeAdminFetchGroupsEvent());
    _searchController.addListener(_onSearchChanged);
  }

  void _onSearchChanged() {
    if (_debounceTimer?.isActive ?? false) _debounceTimer!.cancel();

    _debounceTimer = Timer(const Duration(milliseconds: 500), () {
      final String query = _searchController.text;
      context.read<FeeAdminBloc>().add(
        FeeAdminGroupDataFilteringEvent(query: query),
      );
    });
  }

  @override
  void dispose() {
    _debounceTimer?.cancel();
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GradientBackground(
      child: Scaffold(
        backgroundColor: const Color(0xFFF8F9FD),
        resizeToAvoidBottomInset: false,
        body: SafeArea(
          child: ResponsivePadding(
            child: Column(
              children: [
                ScreenHeader(
                  title: "Groups",
                  trailing: IconButton(
                    icon: const Icon(
                      Icons.refresh,
                      color: Color(0xFF6B7280), // Input Icon Color
                    ),
                    onPressed: () {
                      context.read<FeeAdminBloc>().add(
                        FeeAdminFetchGroupsEvent(),
                      );
                    },
                  ),
                ),
                const SizedBox(height: 16),
                SearchField(
                  controller: _searchController,
                  hintText: "Search groups by code or name...",
                ),
                const SizedBox(height: 20),
                BlocBuilder<FeeAdminBloc, FeeAdminState>(
                  buildWhen:
                      (previous, current) =>
                          current is FeeAdminGroupsLoadedState ||
                          current is FeeAdminGroupDataFilteringCompleteState,
                  builder: (context, state) {
                    final isTablet = MediaQuery.of(context).size.width > 600;
                    List<GroupEntity> groups = [];

                    if (state is FeeAdminGroupsLoadedState) {
                      groups = state.groups;
                    } else if (state
                        is FeeAdminGroupDataFilteringCompleteState) {
                      groups = state.filteredDataList;
                    }

                    if (groups.isEmpty) {
                      return const Expanded(
                        child: Center(
                          child: ResponsiveText(
                            text: "No groups found",
                            phoneSize: 16,
                            tabletSize: 20,
                            color: Color(0xFF374151), // Secondary Text
                          ),
                        ),
                      );
                    }

                    return Expanded(
                      child:
                          isTablet
                              ? GridView.builder(
                                gridDelegate:
                                    const SliverGridDelegateWithFixedCrossAxisCount(
                                      crossAxisCount: 2,
                                      crossAxisSpacing: 20,
                                      mainAxisSpacing: 20,
                                      childAspectRatio: 3.5,
                                    ),
                                itemCount: groups.length,
                                itemBuilder:
                                    (context, i) => _GroupItem(
                                      group: groups[i],
                                      isNavigateToAttendence:
                                          widget.isNavigateToAttendence,
                                      isNavigateToWorkShopGraphPage:
                                          widget.isNavigateToWorkShopGraphPage,
                                    ),
                              )
                              : ListView.separated(
                                itemCount: groups.length,
                                separatorBuilder:
                                    (_, __) => const SizedBox(height: 16),
                                itemBuilder:
                                    (context, i) => _GroupItem(
                                      group: groups[i],
                                      isNavigateToAttendence:
                                          widget.isNavigateToAttendence,
                                      isNavigateToWorkShopGraphPage:
                                          widget.isNavigateToWorkShopGraphPage,
                                    ),
                              ),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _GroupItem extends StatelessWidget {
  final GroupEntity group;
  final bool isNavigateToAttendence;
  final bool isNavigateToWorkShopGraphPage;

  const _GroupItem({
    required this.group,
    required this.isNavigateToAttendence,
    required this.isNavigateToWorkShopGraphPage,
  });

  @override
  Widget build(BuildContext context) {
    final isTablet = MediaQuery.of(context).size.width > 600;
    final groupCode =
        group.groupName.isNotEmpty ? group.groupName.substring(0, 1) : "?";

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder:
                (_) => GroupMembersScreen(
                  groupId: group.groupName,
                  isNavigateToAttendence: isNavigateToAttendence,
                  isNavigateToStudentFeeDetails: false,
                  isNavigateToWorkShopGraphPage: isNavigateToWorkShopGraphPage,
                ),
          ),
        );
      },
      child: NeuCard(
        child: Row(
          children: [
            CircleAvatar(
              radius: isTablet ? 30 : 24,
              backgroundColor: const Color(
                0xFF3B82F6,
              ), // Primary Gradient Start
              child: Text(
                groupCode,
                style: const TextStyle(color: Color(0xFFFFFFFF)),
              ),
            ),
            SizedBox(width: isTablet ? 24 : 16),
            Expanded(
              child: ResponsiveText(
                text: group.groupName,
                phoneSize: 16,
                tabletSize: 20,
                weight: FontWeight.w600,
                color: const Color(0xFF111827), // Primary Text
              ),
            ),
          ],
        ),
      ),
    );
  }
}
