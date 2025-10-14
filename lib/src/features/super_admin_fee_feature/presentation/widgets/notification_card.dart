import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_cas_app_main/src/features/super_admin_fee_feature/presentation/bloc/super_admin_fee_bloc.dart';
import 'package:flutter_cas_app_main/src/features/super_admin_fee_feature/presentation/bloc/super_admin_fee_event.dart';
import 'package:intl/intl.dart';

class NotificationCard extends StatefulWidget {
  final Map<dynamic, dynamic> n;

  const NotificationCard({super.key, required this.n});

  @override
  State<NotificationCard> createState() => _NotificationCardState();
}

class _NotificationCardState extends State<NotificationCard>
    with SingleTickerProviderStateMixin {
  // Only the parts that need to react to expand/collapse listen to this.
  final ValueNotifier<bool> _isExpanded = ValueNotifier<bool>(false);

  late final String paidDate;
  late final String dueDate;
  late final bool isPending;
  late final Color statusColor;

  @override
  void initState() {
    super.initState();

    // compute once to avoid repeated parsing/formatting in build
    final paid = DateTime.tryParse(widget.n["paidDate"]?.toString() ?? '');
    final due = DateTime.tryParse(widget.n["dueDate"]?.toString() ?? '');

    paidDate =
        paid != null
            ? DateFormat("dd MMM yyyy, hh:mm a").format(paid)
            : (widget.n["paidDate"]?.toString() ?? '-');

    dueDate =
        due != null
            ? DateFormat("dd MMM yyyy").format(due)
            : (widget.n["dueDate"]?.toString() ?? '-');

    isPending =
        (widget.n["status"]?.toString().toLowerCase() ?? '') == 'pending';
    statusColor = isPending ? Colors.orange : Colors.green;
  }

  @override
  void dispose() {
    _isExpanded.dispose();
    super.dispose();
  }

  void _toggleExpanded() => _isExpanded.value = !_isExpanded.value;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return AnimatedContainer(
      duration: const Duration(milliseconds: 260),
      margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 4),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.white, Colors.grey[100]!],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(22),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(3, 4),
          ),
          BoxShadow(
            color: Colors.white.withOpacity(0.8),
            blurRadius: 8,
            offset: const Offset(-3, -3),
          ),
        ],
      ),
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header Row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  widget.n["name"]?.toString() ?? '-',
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              const SizedBox(width: 8),
              Text(
                widget.n["groupId"]?.toString() ?? '-',
                style: theme.textTheme.bodySmall?.copyWith(
                  color: Colors.grey[600],
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),

          // Amount Badge (kept simple and stateless)
          Center(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.grey[100]!, Colors.grey[200]!],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(14),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.15),
                    offset: const Offset(3, 3),
                    blurRadius: 6,
                  ),
                  const BoxShadow(
                    color: Colors.white,
                    offset: Offset(-3, -3),
                    blurRadius: 6,
                  ),
                ],
              ),
              child: Text(
                "${widget.n["paidAmount"] ?? '-'} PKR",
                style: theme.textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
            ),
          ),
          const SizedBox(height: 16),

          // Status + Buttons Row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Status chip (stateless)
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 14,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: statusColor.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  widget.n["status"]?.toString() ?? '-',
                  style: TextStyle(
                    color: statusColor,
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
              ),

              // Action buttons (only the details button toggles notifier)
              Row(
                children: [
                  // Details button: toggles expansion. Icon rotation listens to _isExpanded
                  ValueListenableBuilder<bool>(
                    valueListenable: _isExpanded,
                    builder: (context, expanded, _) {
                      return _ActionButton(
                        icon: Icons.info_outline_rounded,
                        tooltip: "Details",
                        onPressed: _toggleExpanded,
                        // optional visual cue when expanded
                        active: expanded,
                      );
                    },
                  ),

                  const SizedBox(width: 10),
                  _ActionButton(
                    icon: Icons.check_rounded,
                    color: Colors.green,
                    tooltip: "Confirm Payment",
                    onPressed: () {
                      context.read<SuperAdminFeeBloc>().add(
                        ConfirmSuperAdminFeePayment(
                          studentId: widget.n["studentId"],
                          id: widget.n["id"],
                        ),
                      );
                    },
                  ),
                ],
              ),
            ],
          ),

          // Expanded Info
          // AnimatedSize animates the size change. Put expanded content inside ClipRect
          // and only rebuild that part when _isExpanded changes.
          ClipRect(
            child: AnimatedSize(
              duration: const Duration(milliseconds: 260),
              curve: Curves.easeInOut,
              alignment: Alignment.topCenter,
              child: ValueListenableBuilder<bool>(
                valueListenable: _isExpanded,
                builder: (context, expanded, _) {
                  if (!expanded) return const SizedBox.shrink();
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 14),
                      Divider(color: Colors.grey.shade300),
                      const SizedBox(height: 8),
                      _InfoLine(
                        "Payment Method",
                        widget.n["paymentMethod"]?.toString() ?? '-',
                      ),
                      _InfoLine("Paid Date", paidDate),
                      _InfoLine("Due Date", dueDate),
                      _InfoLine(
                        "Installment ID",
                        widget.n["id"]?.toString() ?? '-',
                      ),
                    ],
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _InfoLine extends StatelessWidget {
  final String title;
  final String value;

  const _InfoLine(this.title, this.value);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 3),
      child: Row(
        children: [
          Expanded(
            flex: 3,
            child: Text(
              "$title:",
              style: theme.textTheme.bodyMedium?.copyWith(
                color: Colors.grey[700],
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          Expanded(
            flex: 5,
            child: Text(
              value,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: Colors.black87,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ActionButton extends StatefulWidget {
  final IconData icon;
  final Color? color;
  final VoidCallback onPressed;
  final String tooltip;
  final bool active;

  const _ActionButton({
    required this.icon,
    this.color,
    required this.onPressed,
    required this.tooltip,
    this.active = false,
  });

  @override
  State<_ActionButton> createState() => _ActionButtonState();
}

class _ActionButtonState extends State<_ActionButton> {
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    final Color baseColor = widget.color ?? const Color(0xFFE6E8F0);
    final iconColor =
        widget.color != null ? Colors.white : Colors.grey.shade800;

    // When used as "active" (e.g. details toggled), we slightly change elevation/scale
    final double scale = _isPressed ? 0.97 : (widget.active ? 0.98 : 1.0);

    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTapDown: (_) => setState(() => _isPressed = true),
      onTapUp: (_) {
        setState(() => _isPressed = false);
        widget.onPressed();
      },
      onTapCancel: () => setState(() => _isPressed = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 140),
        transform: Matrix4.identity()..scale(scale, scale),
        width: 44,
        height: 44,
        decoration: BoxDecoration(
          color: baseColor,
          shape: BoxShape.circle,
          boxShadow:
              _isPressed
                  ? [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.15),
                      offset: const Offset(2, 2),
                      blurRadius: 4,
                    ),
                    const BoxShadow(
                      color: Colors.white,
                      offset: Offset(-2, -2),
                      blurRadius: 4,
                    ),
                  ]
                  : [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.15),
                      offset: const Offset(4, 4),
                      blurRadius: 8,
                    ),
                    const BoxShadow(
                      color: Colors.white,
                      offset: Offset(-4, -4),
                      blurRadius: 8,
                    ),
                  ],
        ),
        child: Icon(widget.icon, size: 22, color: iconColor),
      ),
    );
  }
}
