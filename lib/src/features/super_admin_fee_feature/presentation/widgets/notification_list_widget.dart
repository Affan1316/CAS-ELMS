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
  // ─── Cache & tracking fields ───────────────────────────────────────────────
  Map<String, List<Map>> _cachedGrouped = {};
  String _lastFilterStatus = '';
  int _lastVersion = -1;

  // ─── UI-only state (never cleared by bloc rebuilds) ────────────────────────
  final Set<String> _expandedGroups = {};
  final Map<String, Set<String>> _selectedItemsByGroup = {};

  // ─── Selection mode (long-press to activate) ──────────────────────────────
  bool _isSelectionMode = false;

  // ───────────────────────────────────────────────────────────────────────────
  // Rebuild cache ONLY when bloc data actually changes (version or filter)
  // ───────────────────────────────────────────────────────────────────────────
  void _rebuildCache(List<Map<String, dynamic>> notifications, int version) {
    _lastFilterStatus = widget.filterStatus;
    _lastVersion = version;

    final allInstallments =
        notifications.expand((n) {
          final List installments = n["installments"] ?? [];
          return installments.map(
            (installment) => {
              ...installment as Map,
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

    // Clear selections and exit selection mode when data changes
    _selectedItemsByGroup.clear();
    _isSelectionMode = false;
  }

  // ───────────────────────────────────────────────────────────────────────────
  // Called when user long-presses a card — enters selection mode
  // ───────────────────────────────────────────────────────────────────────────
  void _onLongPress(String itemId, String groupName) {
    setState(() {
      _isSelectionMode = true;
      _selectedItemsByGroup.putIfAbsent(groupName, () => {});
      _selectedItemsByGroup[groupName]!.add(itemId);
    });
  }

  // ───────────────────────────────────────────────────────────────────────────
  // Called when user taps a card in selection mode — toggles selection
  // ───────────────────────────────────────────────────────────────────────────
  void _onItemSelected(String itemId, bool selected, String groupName) {
    setState(() {
      _selectedItemsByGroup.putIfAbsent(groupName, () => {});
      final groupSet = _selectedItemsByGroup[groupName]!;

      selected ? groupSet.add(itemId) : groupSet.remove(itemId);

      // Auto-exit selection mode when nothing is selected
      final totalSelected = _selectedItemsByGroup.values.fold(
        0,
        (sum, s) => sum + s.length,
      );
      if (totalSelected == 0) _isSelectionMode = false;
    });
  }

  // ───────────────────────────────────────────────────────────────────────────
  // Show snackbar safely after frame is rendered
  // ───────────────────────────────────────────────────────────────────────────
  void _showSnackbar(
    BuildContext context,
    String message,
    Color color,
    IconData icon,
  ) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              Icon(icon, color: Colors.white, size: 20),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  message,
                  style: const TextStyle(color: Colors.white),
                  overflow: TextOverflow.ellipsis,
                  maxLines: 2,
                ),
              ),
            ],
          ),
          backgroundColor: color,
          duration: const Duration(seconds: 3),
          behavior: SnackBarBehavior.floating,
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SuperAdminFeeBloc, SuperAdminFeeState>(
      buildWhen: (previous, current) {
        if (previous.runtimeType != current.runtimeType) return true;

        if (current is SuperAdminFeeLoadedState &&
            previous is SuperAdminFeeLoadedState) {
          return previous.version != current.version ||
              _lastFilterStatus != widget.filterStatus;
        }

        if (current is BulkPaymentFailed) return true;

        return false;
      },
      listenWhen: (previous, current) {
        if (current is SuperAdminFeeLoadedState && current.isJustCompleted) {
          return true;
        }
        return current is BulkPaymentFailed;
      },
      listener: (context, state) {
        if (state is SuperAdminFeeLoadedState && state.isJustCompleted) {
          _showSnackbar(
            context,
            'All fees successfully approved!',
            Colors.green,
            Icons.check_circle,
          );
        } else if (state is BulkPaymentFailed) {
          _showSnackbar(
            context,
            'Approval failed: ${state.message}. Please try again.',
            Colors.red,
            Icons.error,
          );
        }
      },
      builder: (context, state) {
        // ── Loading ──────────────────────────────────────────────────────────
        if (state is SuperAdminFeeLoadingState) {
          return Center(
            child: CircularProgressIndicator(strokeWidth: 2)
                .animate()
                .fadeIn(duration: 250.ms)
                .scale(begin: const Offset(0.92, 0.92)),
          );
        }

        // ── Error ────────────────────────────────────────────────────────────
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

        // ── Loaded ───────────────────────────────────────────────────────────
        if (state is SuperAdminFeeLoadedState) {
          final versionChanged = state.version != _lastVersion;
          final filterChanged = _lastFilterStatus != widget.filterStatus;

          if (versionChanged || filterChanged) {
            _rebuildCache(state.notifications, state.version);
          }

          return _buildGroupList(context);
        }

        // ── Failed ───────────────────────────────────────────────────────────
        if (state is BulkPaymentFailed) {
          _rebuildCache(state.restoredNotifications, state.version);
          return _buildGroupList(context);
        }

        // ── BulkPaymentCompleted ─────────────────────────────────────────────
        if (state is BulkPaymentCompleted) {
          return _buildGroupList(context);
        }

        return const SizedBox.shrink();
      },
    );
  }

  // ───────────────────────────────────────────────────────────────────────────
  // Builds the group list from _cachedGrouped
  // ───────────────────────────────────────────────────────────────────────────
  Widget _buildGroupList(BuildContext context) {
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

        // ── Selection mode hint banner ─────────────────────────────────────
        AnimatedSize(
          duration: const Duration(milliseconds: 250),
          curve: Curves.easeInOut,
          child:
              _isSelectionMode
                  ? Container(
                    width: double.infinity,
                    margin: const EdgeInsets.fromLTRB(16, 8, 16, 0),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 10,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.blue.shade50,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.blue.shade200),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          Icons.touch_app_rounded,
                          size: 18,
                          color: Colors.blue.shade700,
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            'Tap cards to select • Long press to select more',
                            style: TextStyle(
                              fontSize: 13,
                              color: Colors.blue.shade700,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              _selectedItemsByGroup.clear();
                              _isSelectionMode = false;
                            });
                          },
                          child: Icon(
                            Icons.close_rounded,
                            size: 18,
                            color: Colors.blue.shade700,
                          ),
                        ),
                      ],
                    ),
                  ).animate().fadeIn(duration: 200.ms).slideY(begin: -0.2)
                  : const SizedBox.shrink(),
        ),

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
                    isSelectionMode: _isSelectionMode,
                    selectedItems: Set.from(selectedItems),
                    onToggle: () {
                      setState(() {
                        isExpanded
                            ? _expandedGroups.remove(groupName)
                            : _expandedGroups.add(groupName);
                      });
                    },
                    onLongPress: (itemId) => _onLongPress(itemId, groupName),
                    onItemSelected:
                        (itemId, selected) =>
                            _onItemSelected(itemId, selected, groupName),
                    onSelectAll: () {
                      setState(() {
                        _selectedItemsByGroup.putIfAbsent(groupName, () => {});
                        final groupSet = _selectedItemsByGroup[groupName]!;

                        if (groupSet.length == groupItems.length) {
                          // Deselect all in this group
                          groupSet.clear();

                          // Check if any other group still has selections
                          final totalSelected = _selectedItemsByGroup.values
                              .fold(0, (sum, s) => sum + s.length);
                          if (totalSelected == 0) _isSelectionMode = false;
                        } else {
                          groupSet.addAll(
                            groupItems.map((item) => item["id"] as String),
                          );
                        }
                      });
                    },
                    onConfirmSelected: () {
                      if (selectedItems.isEmpty) return;

                      final paymentsToConfirm =
                          groupItems
                              .where(
                                (item) => selectedItems.contains(item["id"]),
                              )
                              .map(
                                (item) => {
                                  'id': item["id"] as String,
                                  'studentId': item["studentId"] as String,
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

                                    // Clear selections and exit selection mode
                                    setState(() {
                                      _selectedItemsByGroup[groupName]?.clear();
                                      final totalSelected =
                                          _selectedItemsByGroup.values.fold(
                                            0,
                                            (sum, s) => sum + s.length,
                                          );
                                      if (totalSelected == 0) {
                                        _isSelectionMode = false;
                                      }
                                    });

                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        content: Row(
                                          children: [
                                            Icon(
                                              Icons.hourglass_top,
                                              color: Colors.white,
                                              size: 20,
                                            ),
                                            SizedBox(width: 10),
                                            Expanded(
                                              child: Text(
                                                'Fees Approved! Processing in background...',
                                                style: TextStyle(
                                                  color: Colors.white,
                                                ),
                                                overflow: TextOverflow.ellipsis,
                                                maxLines: 2,
                                              ),
                                            ),
                                          ],
                                        ),
                                        backgroundColor: Colors.blueGrey,
                                        duration: Duration(seconds: 2),
                                        behavior: SnackBarBehavior.floating,
                                      ),
                                    );
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
}

// ─────────────────────────────────────────────────────────────────────────────
// _GroupCard — pure StatelessWidget, receives everything via callbacks
// ─────────────────────────────────────────────────────────────────────────────
class _GroupCard extends StatelessWidget {
  final String groupName;
  final List<Map> groupItems;
  final String filterStatus;
  final bool isExpanded;
  final bool isSelectionMode;
  final Set<String> selectedItems;
  final VoidCallback onToggle;
  final Function(String) onLongPress;
  final Function(String, bool) onItemSelected;
  final VoidCallback onSelectAll;
  final VoidCallback onConfirmSelected;

  const _GroupCard({
    super.key,
    required this.groupName,
    required this.groupItems,
    required this.filterStatus,
    required this.isExpanded,
    required this.isSelectionMode,
    required this.selectedItems,
    required this.onToggle,
    required this.onLongPress,
    required this.onItemSelected,
    required this.onSelectAll,
    required this.onConfirmSelected,
  });

  @override
  Widget build(BuildContext context) {
    final allSelected =
        groupItems.isNotEmpty && selectedItems.length == groupItems.length;
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
          // ── Group header row ──────────────────────────────────────────────
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

          // ── Select all + confirm row (only in selection mode when expanded) ─
          if (isExpanded && isSelectionMode)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Row(
                children: [
                  // Custom circular checkbox instead of Material Checkbox
                  GestureDetector(
                    onTap: onSelectAll,
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 180),
                      width: 24,
                      height: 24,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color:
                            allSelected
                                ? Theme.of(context).primaryColor
                                : someSelected
                                ? Theme.of(
                                  context,
                                ).primaryColor.withOpacity(0.4)
                                : Colors.grey.shade300,
                        border: Border.all(
                          color:
                              allSelected || someSelected
                                  ? Theme.of(context).primaryColor
                                  : Colors.grey.shade400,
                          width: 2,
                        ),
                      ),
                      child: Center(
                        child: Icon(
                          allSelected
                              ? Icons.check
                              : someSelected
                              ? Icons.remove
                              : null,
                          size: 14,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
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

          // ── Animated cards list ───────────────────────────────────────────
          AnimatedSize(
            duration: const Duration(milliseconds: 280),
            curve: Curves.easeInOut,
            child:
                isExpanded
                    ? Column(
                      children:
                          groupItems.map((item) {
                            final itemId = item["id"] as String;
                            final isSelected = selectedItems.contains(itemId);

                            return _SelectableCardWrapper(
                              key: ValueKey(itemId),
                              isSelectionMode: isSelectionMode,
                              isSelected: isSelected,
                              onLongPress: () => onLongPress(itemId),
                              onTap:
                                  isSelectionMode
                                      ? () =>
                                          onItemSelected(itemId, !isSelected)
                                      : null,
                              child: NotificationCard(
                                key: ValueKey('card_$itemId'),
                                n: item,
                                // Pass selection state to card so it can style itself
                                isSelected: isSelectionMode && isSelected,
                              ),
                            );
                          }).toList(),
                    )
                    : const SizedBox.shrink(),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// _SelectableCardWrapper
// Wraps any card with long-press selection UX:
//   • Long press  → enter selection mode (triggers onLongPress)
//   • Tap         → toggle when in selection mode (triggers onTap)
//   • Visual cue  → animated border + circular check badge
// ─────────────────────────────────────────────────────────────────────────────
class _SelectableCardWrapper extends StatelessWidget {
  final bool isSelectionMode;
  final bool isSelected;
  final VoidCallback onLongPress;
  final VoidCallback? onTap;
  final Widget child;

  const _SelectableCardWrapper({
    super.key,
    required this.isSelectionMode,
    required this.isSelected,
    required this.onLongPress,
    required this.onTap,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    final primaryColor = Theme.of(context).primaryColor;

    return GestureDetector(
      onLongPress: onLongPress,
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeInOut,
        margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color:
                isSelected
                    ? primaryColor
                    : isSelectionMode
                    ? Colors.grey.shade300
                    : Colors.transparent,
            width: isSelected ? 2 : 1,
          ),
          color:
              isSelected ? primaryColor.withOpacity(0.04) : Colors.transparent,
        ),
        child: Stack(
          children: [
            // The actual card content
            child,

            // ── Selection badge (top-right corner) ─────────────────────────
            if (isSelectionMode)
              Positioned(
                top: 10,
                right: 10,
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  curve: Curves.easeInOut,
                  width: 24,
                  height: 24,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: isSelected ? primaryColor : Colors.white,
                    border: Border.all(
                      color: isSelected ? primaryColor : Colors.grey.shade400,
                      width: 2,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.12),
                        blurRadius: 4,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child:
                      isSelected
                          ? const Icon(
                            Icons.check_rounded,
                            size: 14,
                            color: Colors.white,
                          )
                          : null,
                ),
              ),
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// _StatusPill
// ─────────────────────────────────────────────────────────────────────────────
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
