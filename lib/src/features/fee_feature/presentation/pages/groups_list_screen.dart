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
  const GroupsListScreen({super.key, required this.isNavigateToAttendence});
  final bool isNavigateToAttendence;

  @override
  State<GroupsListScreen> createState() => _GroupsListScreenState();
}

class _GroupsListScreenState extends State<GroupsListScreen> {
  final TextEditingController _searchController = TextEditingController();
  Timer? _debounceTimer;

  @override
  void initState() {
    super.initState();
    // Fetch groups when screen initializes
    context.read<FeeAdminBloc>().add(FeeAdminFetchGroupsEvent());
    _searchController.addListener(_onSearchChanged);
  }

  /// Debounced listener for the search TextField.
  ///
  /// Behavior:
  /// 1. This method is attached as a listener to [_searchController].
  /// 2. It implements a debounce to avoid firing a filter event on every keystroke
  ///    — instead it waits until the user stops typing for 500ms.
  /// 3. If a previous debounce timer is still active, it is cancelled and a new
  ///    timer is started (this restarts the 500ms window).
  /// 4. When the timer fires we read the latest text from the controller and
  ///    dispatch `FeeAdminGroupDataFilteringEvent` to the `FeeAdminBloc`.
  ///
  /// Notes / rationale:
  /// - Using a debounce reduces unnecessary state changes and expensive filtering
  ///   operations while the user is actively typing.
  /// - We read `_searchController.text` inside the timer callback so the dispatched
  ///   query is always the latest value (in case the controller changed after
  ///   the timer was scheduled).
  /// - `_debounceTimer` is cancelled in `dispose()` to avoid callbacks after the
  ///   widget is removed from the tree.
  void _onSearchChanged() {
    // If there is an active debounce timer, cancel it so we restart the debounce window.
    if (_debounceTimer?.isActive ?? false) _debounceTimer!.cancel();

    // Start a new debounce timer. The callback will run only after 500ms of inactivity.
    _debounceTimer = Timer(const Duration(milliseconds: 500), () {
      // Capture the latest query text from the controller.
      final String query = _searchController.text;

      // Dispatch the filtering event to the FeeAdminBloc with the current query.
      // The Bloc should respond by updating state (e.g., producing a filtered list).
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
        backgroundColor: Colors.white,
        resizeToAvoidBottomInset: false,
        body: SafeArea(
          child: ResponsivePadding(
            child: Column(
              children: [
                ScreenHeader(
                  title: "Groups",

                  trailing: IconButton(
                    icon: const Icon(Icons.refresh, color: Color(0xFF3E206D)),
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
                  // onChanged: (value) {},
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
                            color: Colors.grey,
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

// Extracted Group Item Widget to optimize rebuilds
class _GroupItem extends StatelessWidget {
  final GroupEntity group;
  final bool isNavigateToAttendence;

  const _GroupItem({required this.group, required this.isNavigateToAttendence});

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
                ),
          ),
        );
      },
      child: NeuCard(
        child: Row(
          children: [
            CircleAvatar(
              radius: isTablet ? 30 : 24,
              backgroundColor: const Color(0xFF009688),
              child: Text(
                groupCode,
                style: const TextStyle(color: Colors.white),
              ),
            ),
            SizedBox(width: isTablet ? 24 : 16),
            Expanded(
              child: ResponsiveText(
                text: group.groupName,
                phoneSize: 16,
                tabletSize: 20,
                weight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
