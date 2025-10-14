import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_cas_app_main/src/features/super_admin_fee_feature/presentation/widgets/notification_card.dart';
import 'package:flutter_cas_app_main/src/features/super_admin_fee_feature/presentation/bloc/super_admin_fee_bloc.dart';
import 'package:flutter_cas_app_main/src/features/super_admin_fee_feature/presentation/bloc/super_admin_fee_state.dart';
import 'package:collection/collection.dart';
import 'package:flutter_animate/flutter_animate.dart';

class NotificationListWidget extends StatefulWidget {
  final String filterStatus;
  final Widget? header;

  const NotificationListWidget({
    super.key,
    required this.filterStatus,
    this.header,
  });

  @override
  State<NotificationListWidget> createState() => _NotificationListWidgetState();
}

class _NotificationListWidgetState extends State<NotificationListWidget> {
  Map<String, List<Map>> _cachedGrouped = {};
  String _lastFilterStatus = '';
  final Set<String> _expandedGroups = {};

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SuperAdminFeeBloc, SuperAdminFeeState>(
      buildWhen: (previous, current) {
        return previous.runtimeType != current.runtimeType ||
            _lastFilterStatus != widget.filterStatus;
      },
      builder: (context, state) {
        if (state is SuperAdminFeeLoadingState) {
          return Center(
            child: CircularProgressIndicator()
                .animate()
                .fadeIn(duration: 300.ms)
                .scale(begin: const Offset(0.8, 0.8)),
          );
        }

        if (state is SuperAdminFeeErrorState) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.error_outline, size: 64, color: Colors.red[300]),
                const SizedBox(height: 16),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 32),
                  child: Text(
                    state.message,
                    style: TextStyle(color: Colors.red[700], fontSize: 16),
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
            ).animate().fadeIn(duration: 400.ms).slideY(begin: 0.2, end: 0),
          );
        }

        if (state is SuperAdminFeeLoadedState) {
          // Only recompute if filter status changed
          if (_lastFilterStatus != widget.filterStatus) {
            _lastFilterStatus = widget.filterStatus;

            final allInstallments =
                state.notifications.expand((n) {
                  final List installments = n["installments"] ?? [];
                  return installments.map(
                    (installment) => {
                      ...installment,
                      "name": n["name"],
                      "groupId": n["groupId"],
                      "expanded": installment["expanded"] ?? false,
                      "studentId": n["id"],
                    },
                  );
                }).toList();

            final filtered =
                allInstallments
                    .where(
                      (i) =>
                          (i["status"] ?? '').toString().toLowerCase() ==
                          widget.filterStatus.toLowerCase(),
                    )
                    .toList();

            _cachedGrouped = groupBy(filtered, (i) => i["groupId"] as String);
          }

          if (_cachedGrouped.isEmpty) {
            return Center(
              child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.notifications_none_rounded,
                        size: 80,
                        color: Colors.grey[300],
                      ),
                      const SizedBox(height: 16),
                      Text(
                        "No ${widget.filterStatus} notifications",
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.grey[600],
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  )
                  .animate()
                  .fadeIn(duration: 500.ms, delay: 100.ms)
                  .scale(begin: const Offset(0.9, 0.9)),
            );
          }

          final groupKeys = _cachedGrouped.keys.toList();

          return Column(
            children: [
              if (widget.header != null)
                widget.header!
                    .animate()
                    .fadeIn(duration: 300.ms)
                    .slideY(begin: -0.2, end: 0),
              Expanded(
                child: ListView.builder(
                  physics: const BouncingScrollPhysics(),
                  padding: const EdgeInsets.all(16),
                  itemCount: groupKeys.length,
                  itemBuilder: (context, index) {
                    final groupName = groupKeys[index];
                    final groupItems = _cachedGrouped[groupName]!;
                    final isExpanded = _expandedGroups.contains(groupName);

                    return _GroupCard(
                          key: ValueKey(groupName),
                          groupName: groupName,
                          groupItems: groupItems,
                          filterStatus: widget.filterStatus,
                          isExpanded: isExpanded,
                          onToggle: () {
                            setState(() {
                              if (isExpanded) {
                                _expandedGroups.remove(groupName);
                              } else {
                                _expandedGroups.add(groupName);
                              }
                            });
                          },
                        )
                        .animate()
                        .fadeIn(duration: 350.ms, delay: (50 * index).ms)
                        .slideX(
                          begin: 0.05,
                          end: 0,
                          curve: Curves.easeOutCubic,
                        );
                  },
                ),
              ),
            ],
          );
        }

        return const SizedBox.shrink();
      },
    );
  }
}

class _GroupCard extends StatelessWidget {
  final String groupName;
  final List<Map> groupItems;
  final String filterStatus;
  final bool isExpanded;
  final VoidCallback onToggle;

  const _GroupCard({
    super.key,
    required this.groupName,
    required this.groupItems,
    required this.filterStatus,
    required this.isExpanded,
    required this.onToggle,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Material(
            color: Colors.transparent,
            child: InkWell(
              borderRadius: BorderRadius.circular(16),
              onTap: onToggle,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    AnimatedRotation(
                      turns: isExpanded ? 0.25 : 0,
                      duration: const Duration(milliseconds: 200),
                      child: Icon(Icons.chevron_right, color: Colors.grey[700]),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            groupName,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 17,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            '${groupItems.length} $filterStatus installment${groupItems.length != 1 ? 's' : ''}',
                            style: TextStyle(
                              fontSize: 13,
                              color: Colors.grey[600],
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: _getStatusColor(filterStatus).withOpacity(0.1),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        '${groupItems.length}',
                        style: TextStyle(
                          color: _getStatusColor(filterStatus),
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          AnimatedSize(
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeInOut,
            child:
                isExpanded
                    ? Column(
                      children:
                          groupItems
                              .map(
                                (item) => NotificationCard(
                                  key: ValueKey(item["id"]),
                                  n: item,
                                ),
                              )
                              .toList(),
                    )
                    : const SizedBox.shrink(),
          ),
        ],
      ),
    );
  }

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'pending':
        return Colors.orange;
      case 'paid':
        return Colors.green;
      case 'overdue':
        return Colors.red;
      default:
        return Colors.blue;
    }
  }
}
