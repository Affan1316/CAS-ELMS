import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_cas_app_main/src/features/fee_feature/presentation/bloc/fee_admin_bloc.dart';
import 'package:flutter_cas_app_main/src/features/super_admin_fee_feature/presentation/bloc/super_admin_fee_bloc.dart';
import 'package:flutter_cas_app_main/src/features/super_admin_fee_feature/presentation/bloc/super_admin_fee_event.dart';
import 'package:flutter_cas_app_main/src/features/super_admin_fee_feature/presentation/bloc/super_admin_fee_state.dart';

class GroupFeeHistoryPage extends StatefulWidget {
  final String groupName;

  const GroupFeeHistoryPage({Key? key, required this.groupName})
    : super(key: key);

  @override
  State<GroupFeeHistoryPage> createState() => _GroupFeeHistoryPageState();
}

class _GroupFeeHistoryPageState extends State<GroupFeeHistoryPage> {
  // Vibrant & playful color palette
  final Color _baseColor = const Color(0xFFE8EDF5);
  final Color _primaryColor = const Color(0xFF6C5CE7);
  final Color _accentColor = const Color(0xFFFF6B9D);
  final Color _successColor = const Color(0xFF00D9A3);
  final Color _warningColor = const Color(0xFFFFA502);
  final Color _dangerColor = const Color(0xFFFF6348);
  final Color _textPrimary = const Color(0xFF2D3436);
  final Color _textSecondary = const Color(0xFF636E72);

  @override
  void initState() {
    super.initState();
    context.read<SuperAdminFeeBloc>().add(
      FetchGroupFeeHistoryEvent(groupName: widget.groupName),
    );
  }

  @override
  Widget build(BuildContext context) {
    final topPadding = MediaQuery.of(context).padding.top;

    return Scaffold(
      backgroundColor: _baseColor,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(kToolbarHeight + topPadding),
        child: Container(
          padding: EdgeInsets.only(top: topPadding, left: 12, right: 12),
          decoration: BoxDecoration(
            color: _baseColor,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                offset: const Offset(4, 4),
                blurRadius: 15,
              ),
              BoxShadow(
                color: Colors.white.withOpacity(0.9),
                offset: const Offset(-4, -4),
                blurRadius: 15,
              ),
            ],
          ),
          child: SafeArea(
            bottom: false,
            child: Row(
              children: [
                GestureDetector(
                  onTap: () => Navigator.of(context).maybePop(),
                  child: _neomorphicIconCircle(
                    Icons.arrow_back_ios_new,
                    iconColor: _primaryColor,
                    size: 42,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Center(
                    child: Text(
                      'Fee History - ${widget.groupName}',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w800,
                        color: _textPrimary,
                        letterSpacing: -0.5,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ),
                const SizedBox(width: 48),
              ],
            ),
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: BlocBuilder<SuperAdminFeeBloc, SuperAdminFeeState>(
          builder: (context, state) {
            if (state is GroupFeeHistoryInitial) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _neomorphicContainer(
                      width: 80,
                      height: 80,
                      isInner: true,
                      child: CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(
                          _primaryColor,
                        ),
                        strokeWidth: 4,
                      ),
                    ),
                    const SizedBox(height: 24),
                    Text(
                      'Loading fee history... 🔄',
                      style: TextStyle(
                        fontSize: 16,
                        color: _textSecondary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              );
            } else if (state is GroupFeeHistoryLoaded) {
              if (state.total == 0 && state.received == 0) {
                return _buildNoFeeHistoryUI();
              }

              final progress =
                  state.total > 0 ? (state.received / state.total) : 0.0;

              return SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Group Info Card - Neomorphic
                    _neomorphicCard(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              _neomorphicIconCircle(
                                Icons.groups_rounded,
                                iconColor: _primaryColor,
                                size: 56,
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      '👥 GROUP',
                                      style: TextStyle(
                                        fontSize: 11,
                                        color: _accentColor,
                                        fontWeight: FontWeight.w900,
                                        letterSpacing: 1.5,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      widget.groupName,
                                      style: TextStyle(
                                        fontSize: 22,
                                        fontWeight: FontWeight.w900,
                                        color: _textPrimary,
                                        letterSpacing: -0.5,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 24),
                          _buildStatItem(
                            'Total Fee',
                            state.total,
                            Icons.payments_rounded,
                            '💰',
                          ),
                          _buildStatItem(
                            'Received',
                            state.received,
                            Icons.check_circle,
                            '✅',
                          ),
                          _buildStatItem(
                            'Remaining',
                            state.remaining,
                            Icons.hourglass_bottom_rounded,
                            '⏳',
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),

                    // Status Card - Neomorphic with color
                    _neomorphicCard(
                      color: _getStatusColor(state.remaining),
                      isColored: true,
                      child: Row(
                        children: [
                          _neomorphicIconCircle(
                            state.remaining == 0
                                ? Icons.verified_rounded
                                : Icons.schedule_rounded,
                            iconColor: Colors.white,
                            size: 64,
                            isInner: true,
                            bgColor: _getStatusColor(state.remaining),
                          ),
                          const SizedBox(width: 20),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  state.remaining == 0
                                      ? '🎊 All Done!'
                                      : '💸 Payment Pending',
                                  style: const TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.w900,
                                    color: Colors.white,
                                    letterSpacing: -0.5,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  state.remaining == 0
                                      ? 'Complete payment received!'
                                      : '${state.remaining.toStringAsFixed(2)} still needed',
                                  style: TextStyle(
                                    color: Colors.white.withOpacity(0.95),
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),

                    // Progress Section
                    Row(
                      children: [
                        const Text('📊', style: TextStyle(fontSize: 20)),
                        const SizedBox(width: 8),
                        Text(
                          'Collection Progress',
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w900,
                            color: _textPrimary,
                            letterSpacing: 0.3,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 14),
                    Stack(
                      children: [
                        _neomorphicProgressBar(progress, state.remaining == 0),
                        if (progress > 0.15)
                          Positioned.fill(
                            child: Align(
                              alignment: Alignment.centerLeft,
                              child: Padding(
                                padding: EdgeInsets.only(
                                  left:
                                      (MediaQuery.of(context).size.width - 32) *
                                          progress -
                                      12,
                                ),
                                child: Text(
                                  state.remaining == 0 ? '🎯' : '🚀',
                                  style: const TextStyle(fontSize: 18),
                                ),
                              ),
                            ),
                          ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          '${(progress * 100).toStringAsFixed(1)}% Complete',
                          style: TextStyle(
                            fontSize: 14,
                            color: _textSecondary,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        Text(
                          '${state.received.toStringAsFixed(2)} / ${state.total.toStringAsFixed(2)}',
                          style: TextStyle(
                            fontSize: 14,
                            color: _textPrimary,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 32),

                    // Refresh button
                    Center(
                      child: _neomorphicButton(
                        onTap: () {
                          context.read<SuperAdminFeeBloc>().add(
                            FetchGroupFeeHistoryEvent(
                              groupName: widget.groupName,
                            ),
                          );
                        },
                        icon: Icons.refresh_rounded,
                        label: "Refresh Data 🔄",
                      ),
                    ),
                  ],
                ),
              );
            } else if (state is SuperAdminFeeErrorState) {
              return _buildErrorUI(state.message ?? 'An error occurred');
            } else {
              return Center(
                child: Text(
                  'Unexpected state',
                  style: TextStyle(color: _textSecondary),
                ),
              );
            }
          },
        ),
      ),
    );
  }

  /// --- 🧩 Helper Widgets ---

  Widget _neomorphicCard({
    required Widget child,
    Color? color,
    bool isColored = false,
    EdgeInsetsGeometry padding = const EdgeInsets.all(24),
  }) {
    final bgColor = color ?? _baseColor;
    return Container(
      padding: padding,
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(24),
        boxShadow:
            isColored
                ? [
                  BoxShadow(
                    color: bgColor.withOpacity(0.5),
                    offset: const Offset(6, 6),
                    blurRadius: 20,
                  ),
                  BoxShadow(
                    color: Colors.white.withOpacity(0.1),
                    offset: const Offset(-2, -2),
                    blurRadius: 8,
                  ),
                ]
                : [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.12),
                    offset: const Offset(8, 8),
                    blurRadius: 20,
                  ),
                  BoxShadow(
                    color: Colors.white.withOpacity(0.9),
                    offset: const Offset(-8, -8),
                    blurRadius: 20,
                  ),
                ],
      ),
      child: child,
    );
  }

  Widget _neomorphicContainer({
    required Widget child,
    double? width,
    double? height,
    bool isInner = false,
  }) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: _baseColor,
        borderRadius: BorderRadius.circular(20),
        boxShadow:
            isInner
                ? [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.15),
                    offset: const Offset(4, 4),
                    blurRadius: 8,
                    // inset: true,
                  ),
                  BoxShadow(
                    color: Colors.white.withOpacity(0.7),
                    offset: const Offset(-4, -4),
                    blurRadius: 8,
                    // inset: true,
                  ),
                ]
                : [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.12),
                    offset: const Offset(6, 6),
                    blurRadius: 15,
                  ),
                  BoxShadow(
                    color: Colors.white.withOpacity(0.9),
                    offset: const Offset(-6, -6),
                    blurRadius: 15,
                  ),
                ],
      ),
      child: Center(child: child),
    );
  }

  Widget _neomorphicButton({
    required VoidCallback onTap,
    required IconData icon,
    required String label,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 36, vertical: 18),
        decoration: BoxDecoration(
          color: _baseColor,
          borderRadius: BorderRadius.circular(30),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.12),
              offset: const Offset(8, 8),
              blurRadius: 20,
            ),
            BoxShadow(
              color: Colors.white.withOpacity(0.9),
              offset: const Offset(-8, -8),
              blurRadius: 20,
            ),
          ],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: _primaryColor, size: 24),
            const SizedBox(width: 12),
            Text(
              label,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w900,
                color: _primaryColor,
                letterSpacing: 0.5,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _neomorphicIconCircle(
    IconData icon, {
    Color? iconColor,
    Color? bgColor,
    double size = 48,
    bool isInner = false,
  }) {
    final base = bgColor ?? _baseColor;
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: base,
        shape: BoxShape.circle,
        boxShadow:
            isInner
                ? [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.2),
                    offset: const Offset(4, 4),
                    blurRadius: 10,
                  ),
                  BoxShadow(
                    color: Colors.white.withOpacity(0.1),
                    offset: const Offset(-2, -2),
                    blurRadius: 8,
                  ),
                ]
                : [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.12),
                    offset: const Offset(6, 6),
                    blurRadius: 15,
                  ),
                  BoxShadow(
                    color: Colors.white.withOpacity(0.9),
                    offset: const Offset(-6, -6),
                    blurRadius: 15,
                  ),
                ],
      ),
      child: Center(
        child: Icon(icon, size: size * 0.5, color: iconColor ?? _textPrimary),
      ),
    );
  }

  Widget _neomorphicProgressBar(double progress, bool isComplete) {
    return Container(
      height: 24,
      decoration: BoxDecoration(
        color: _baseColor,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.15),
            offset: const Offset(4, 4),
            blurRadius: 10,
          ),
          BoxShadow(
            color: Colors.white.withOpacity(0.7),
            offset: const Offset(-4, -4),
            blurRadius: 10,
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: LayoutBuilder(
          builder: (context, constraints) {
            return Stack(
              children: [
                // Inner shadow background
                Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.black.withOpacity(0.05),
                        Colors.transparent,
                      ],
                    ),
                  ),
                ),
                AnimatedContainer(
                  duration: const Duration(milliseconds: 1000),
                  curve: Curves.easeOutCubic,
                  width: constraints.maxWidth * progress,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors:
                          isComplete
                              ? [_successColor, _successColor.withOpacity(0.8)]
                              : [_primaryColor, _accentColor],
                    ),
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: (isComplete ? _successColor : _primaryColor)
                            .withOpacity(0.4),
                        offset: const Offset(2, 2),
                        blurRadius: 8,
                      ),
                    ],
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildNoFeeHistoryUI() {
    return Center(
      child: _neomorphicCard(
        padding: const EdgeInsets.all(40),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            _neomorphicIconCircle(
              Icons.history_edu_outlined,
              iconColor: _textSecondary,
              size: 96,
            ),
            const SizedBox(height: 28),
            Text(
              '📚 Oops! Nothing Here',
              style: TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.w900,
                color: _textPrimary,
                letterSpacing: -0.5,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              'No fee records found for ${widget.groupName}',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 15,
                color: _textSecondary,
                height: 1.5,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 36),
            _neomorphicButton(
              onTap: () {
                context.read<SuperAdminFeeBloc>().add(
                  FetchGroupFeeHistoryEvent(groupName: widget.groupName),
                );
              },
              icon: Icons.refresh_rounded,
              label: "Refresh",
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildErrorUI(String message) {
    return Center(
      child: _neomorphicCard(
        padding: const EdgeInsets.all(40),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            _neomorphicIconCircle(
              Icons.error_outline_rounded,
              iconColor: _dangerColor,
              size: 96,
            ),
            const SizedBox(height: 28),
            Text(
              '😕 Uh-oh! Something Broke',
              style: TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.w900,
                color: _textPrimary,
                letterSpacing: -0.5,
              ),
            ),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: _dangerColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Text(
                message,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 14,
                  color: _dangerColor,
                  height: 1.5,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
            const SizedBox(height: 36),
            _neomorphicButton(
              onTap: () {
                context.read<SuperAdminFeeBloc>().add(
                  FetchGroupFeeHistoryEvent(groupName: widget.groupName),
                );
              },
              icon: Icons.refresh_rounded,
              label: "Try Again",
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatItem(
    String label,
    double value,
    IconData icon,
    String emoji,
  ) {
    final color = _getAmountColor(label, value);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12.0),
      child: Container(
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: _baseColor,
          borderRadius: BorderRadius.circular(18),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              offset: const Offset(6, 6),
              blurRadius: 12,
            ),
            BoxShadow(
              color: Colors.white.withOpacity(0.9),
              offset: const Offset(-6, -6),
              blurRadius: 12,
            ),
          ],
        ),
        child: Row(
          children: [
            Text(emoji, style: const TextStyle(fontSize: 28)),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label.toUpperCase(),
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w900,
                      color: color.withOpacity(0.7),
                      letterSpacing: 1.2,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    value.toStringAsFixed(2),
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w900,
                      color: color,
                      letterSpacing: -0.5,
                    ),
                  ),
                ],
              ),
            ),
            _neomorphicIconCircle(
              icon,
              iconColor: color,
              size: 44,
              isInner: true,
            ),
          ],
        ),
      ),
    );
  }

  Color _getAmountColor(String label, double value) {
    switch (label) {
      case 'Remaining':
        return value > 0 ? _dangerColor : _successColor;
      case 'Received':
        return _successColor;
      case 'Total Fee':
        return _primaryColor;
      default:
        return _textPrimary;
    }
  }

  Color _getStatusColor(double remaining) {
    if (remaining == 0) return _successColor;
    if (remaining > 0) return _warningColor;
    return _dangerColor;
  }
}
