import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_cas_app_main/src/features/super_admin_fee_feature/presentation/widgets/notification_card.dart';
import 'package:flutter_cas_app_main/src/features/super_admin_fee_feature/presentation/bloc/super_admin_fee_bloc.dart';
import 'package:flutter_cas_app_main/src/features/super_admin_fee_feature/presentation/bloc/super_admin_fee_event.dart';
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
  final Map<String, Set<String>> _selectedItemsByGroup = {};

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SuperAdminFeeBloc, SuperAdminFeeState>(
      buildWhen:
          (previous, current) =>
              previous.runtimeType != current.runtimeType ||
              _lastFilterStatus != widget.filterStatus,
      builder: (context, state) {
        if (state is SuperAdminFeeLoadingState) {
          return Center(
            child: CircularProgressIndicator(strokeWidth: 2)
                .animate()
                .fadeIn(duration: 250.ms)
                .scale(begin: const Offset(0.92, 0.92)),
          );
        }

        if (state is SuperAdminFeeErrorState) {
          return Center(
            child: Padding(
              padding: const EdgeInsets.all(32),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.error_outline_rounded,
                    size: 64,
                    color: Colors.red.shade300,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    state.message,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.red.shade700,
                      fontSize: 15,
                      height: 1.4,
                    ),
                  ),
                ],
              ),
            ),
          ).animate().fadeIn(duration: 350.ms).slideY(begin: 0.15);
        }

        if (state is SuperAdminFeeLoadedState) {
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
            _selectedItemsByGroup.clear();
          }

          if (_cachedGrouped.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.notifications_none_rounded,
                    size: 72,
                    color: Colors.grey.shade300,
                  ),
                  const SizedBox(height: 12),
                  Text(
                    "No ${widget.filterStatus} notifications",
                    style: TextStyle(
                      fontSize: 15,
                      color: Colors.grey.shade600,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ).animate().fadeIn(duration: 400.ms);
          }

          final groupKeys = _cachedGrouped.keys.toList();

          return Column(
            children: [
              if (widget.header != null)
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 12, 16, 4),
                  child: widget.header!,
                ).animate().fadeIn(duration: 250.ms).slideY(begin: -0.1),
              Expanded(
                child: ListView.builder(
                  physics: const BouncingScrollPhysics(),
                  padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
                  itemCount: groupKeys.length,
                  itemBuilder: (context, index) {
                    final groupName = groupKeys[index];
                    final groupItems = _cachedGrouped[groupName]!;
                    final isExpanded = _expandedGroups.contains(groupName);

                    _selectedItemsByGroup.putIfAbsent(groupName, () => {});
                    final selectedItems = _selectedItemsByGroup[groupName]!;

                    return _GroupCard(
                          key: ValueKey(groupName),
                          groupName: groupName,
                          groupItems: groupItems,
                          filterStatus: widget.filterStatus,
                          isExpanded: isExpanded,
                          selectedItems: selectedItems,
                          onToggle: () {
                            setState(() {
                              isExpanded
                                  ? _expandedGroups.remove(groupName)
                                  : _expandedGroups.add(groupName);
                            });
                          },
                          onItemSelected: (id, selected) {
                            setState(() {
                              selected
                                  ? selectedItems.add(id)
                                  : selectedItems.remove(id);
                            });
                          },
                          onSelectAll: () {
                            setState(() {
                              selectedItems.length == groupItems.length
                                  ? selectedItems.clear()
                                  : selectedItems.addAll(
                                    groupItems.map(
                                      (item) => item["id"] as String,
                                    ),
                                  );
                            });
                          },
                          onConfirmSelected: () {
                            if (selectedItems.isEmpty) return;

                            final paymentsToConfirm =
                                groupItems
                                    .where(
                                      (item) =>
                                          selectedItems.contains(item["id"]),
                                    )
                                    .map(
                                      (item) => {
                                        'id': item["id"] as String,
                                        'studentId':
                                            item["studentId"] as String,
                                      },
                                    )
                                    .toList();

                            showDialog(
                              context: context,
                              builder:
                                  (ctx) => AlertDialog(
                                    title: const Text('Confirm Payments'),
                                    content: Text(
                                      'Confirm ${paymentsToConfirm.length} payment(s) for group "$groupName"?',
                                    ),
                                    actions: [
                                      TextButton(
                                        onPressed: () => Navigator.pop(ctx),
                                        child: const Text('Cancel'),
                                      ),
                                      ElevatedButton(
                                        onPressed: () {
                                          Navigator.pop(ctx);
                                          context.read<SuperAdminFeeBloc>().add(
                                            ConfirmBulkSuperAdminFeePayments(
                                              payments: paymentsToConfirm,
                                            ),
                                          );
                                          setState(selectedItems.clear);
                                        },
                                        child: const Text('Confirm'),
                                      ),
                                    ],
                                  ),
                            );
                          },
                        )
                        .animate()
                        .fadeIn(duration: 300.ms, delay: (40 * index).ms)
                        .slideX(begin: 0.04);
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
  final Set<String> selectedItems;
  final VoidCallback onToggle;
  final Function(String, bool) onItemSelected;
  final VoidCallback onSelectAll;
  final VoidCallback onConfirmSelected;

  const _GroupCard({
    super.key,
    required this.groupName,
    required this.groupItems,
    required this.filterStatus,
    required this.isExpanded,
    required this.selectedItems,
    required this.onToggle,
    required this.onItemSelected,
    required this.onSelectAll,
    required this.onConfirmSelected,
  });

  @override
  Widget build(BuildContext context) {
    final allSelected = selectedItems.length == groupItems.length;
    final someSelected = selectedItems.isNotEmpty;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 14,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        children: [
          InkWell(
            borderRadius: BorderRadius.circular(18),
            onTap: onToggle,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  AnimatedRotation(
                    turns: isExpanded ? 0.25 : 0,
                    duration: const Duration(milliseconds: 200),
                    child: const Icon(Icons.chevron_right_rounded),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          groupName,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '${groupItems.length} $filterStatus installment${groupItems.length != 1 ? 's' : ''}',
                          style: TextStyle(
                            fontSize: 13,
                            color: Colors.grey.shade600,
                          ),
                        ),
                      ],
                    ),
                  ),
                  _StatusPill(count: groupItems.length, status: filterStatus),
                ],
              ),
            ),
          ),
          if (isExpanded)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Row(
                children: [
                  Checkbox(
                    value: allSelected,
                    tristate: true,
                    onChanged: (_) => onSelectAll(),
                  ),
                  Text(
                    allSelected
                        ? 'Deselect All'
                        : someSelected
                        ? 'Select All (${selectedItems.length})'
                        : 'Select All',
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      color: Colors.grey.shade700,
                    ),
                  ),
                  const Spacer(),
                  if (someSelected)
                    ElevatedButton.icon(
                      onPressed: onConfirmSelected,
                      icon: const Icon(Icons.check_circle, size: 18),
                      label: Text('Confirm (${selectedItems.length})'),
                    ),
                ],
              ),
            ),
          AnimatedSize(
            duration: const Duration(milliseconds: 280),
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
                                  isSelectable: true,
                                  isSelected: selectedItems.contains(
                                    item["id"],
                                  ),
                                  onSelectionChanged:
                                      (selected) =>
                                          onItemSelected(item["id"], selected),
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
}

class _StatusPill extends StatelessWidget {
  final int count;
  final String status;

  const _StatusPill({required this.count, required this.status});

  @override
  Widget build(BuildContext context) {
    final color = _getStatusColor(status);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: color.withOpacity(0.12),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        '$count',
        style: TextStyle(
          color: color,
          fontWeight: FontWeight.bold,
          fontSize: 14,
        ),
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
