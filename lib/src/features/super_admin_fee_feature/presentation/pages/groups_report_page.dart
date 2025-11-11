import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_cas_app_main/src/features/fee_feature/presentation/pages/group_members_screen.dart';
import 'package:flutter_cas_app_main/src/features/super_admin_fee_feature/data/entity/group_fee_history.dart';
import 'package:flutter_cas_app_main/src/features/super_admin_fee_feature/presentation/pages/group_fee_history_page.dart';
import 'package:flutter_cas_app_main/src/features/super_admin_fee_feature/presentation/bloc/super_admin_fee_bloc.dart';
import 'package:flutter_cas_app_main/src/features/super_admin_fee_feature/presentation/bloc/super_admin_fee_event.dart';
import 'package:flutter_cas_app_main/src/features/super_admin_fee_feature/presentation/bloc/super_admin_fee_state.dart';

/// Improved Groups report page with totals card added.
/// - Shows totals of all groups and totals of visible groups (when searching)
/// - Uses existing bloc cache to compute totals (only counts loaded summaries)
class GroupsReportPage extends StatefulWidget {
  const GroupsReportPage({Key? key}) : super(key: key);

  @override
  State<GroupsReportPage> createState() => _GroupsReportPageState();
}

class _GroupsReportPageState extends State<GroupsReportPage> {
  final TextEditingController _searchController = TextEditingController();

  // --- Metrology / design tokens ---
  static const double _baseSpacing = 12.0;
  static const double _corner = 14.0;
  static const double _minCardHeight = 120.0;

  @override
  void initState() {
    super.initState();
    _fetch();
  }

  void _fetch() => context.read<SuperAdminFeeBloc>().add(GetGroupNamesEvent());

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List<String> _filterNames(List<String> names) {
    final q = _searchController.text.trim().toLowerCase();
    if (q.isEmpty) return names;
    return names.where((n) => n.toLowerCase().contains(q)).toList();
  }

  // simple K/M formatter (same style as the card)
  String _compactAmount(double value) {
    if (value.abs() >= 1e6) return (value / 1e6).toStringAsFixed(1) + 'M';
    if (value.abs() >= 1e3) return (value / 1e3).toStringAsFixed(1) + 'K';
    return value.toStringAsFixed(2);
  }

  /// Totals card that shows overall totals computed from the bloc's cache.
  /// If some group summaries are not yet loaded (null), the card still shows
  /// the partial totals and a small status (e.g. "8/12 loaded").
  Widget _buildTotalsCard(BuildContext context, List<String> visibleNames) {
    final summaries = context.read<SuperAdminFeeBloc>().getGroupSummaries;

    // Totals across all cached groups (only non-null summaries counted)
    double totalAll = 0.0;
    double receivedAll = 0.0;
    int loadedCount = 0;
    summaries.forEach((k, v) {
      if (v != null) {
        totalAll += v.total;
        receivedAll += v.received;
        loadedCount++;
      }
    });

    // Totals for the currently visible/filtered names (helps reflect search)
    double filteredTotal = 0.0;
    double filteredReceived = 0.0;
    for (final name in visibleNames) {
      final s = summaries[name];
      if (s != null) {
        filteredTotal += s.total;
        filteredReceived += s.received;
      }
    }

    final theme = Theme.of(context);

    return Material(
      color: const Color(0xFFE8EDF5),
      borderRadius: BorderRadius.circular(_corner),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: const Color(0xFFE8EDF5),
          borderRadius: BorderRadius.circular(_corner),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.03),
              offset: const Offset(3, 3),
              blurRadius: 6,
            ),
            BoxShadow(
              color: Colors.white.withOpacity(0.9),
              offset: const Offset(-3, -3),
              blurRadius: 6,
            ),
          ],
        ),
        child: Row(
          children: [
            // Left block: overall totals
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'All groups — totals',
                    style: theme.textTheme.labelSmall?.copyWith(
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    _compactAmount(totalAll),
                    style: theme.textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.w900,
                      fontSize: 18,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Received ${_compactAmount(receivedAll)} • ${loadedCount}/${summaries.length} loaded',
                    style: theme.textTheme.bodySmall,
                  ),
                ],
              ),
            ),

            // Right block: filtered totals (when search is used)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: const Color(0xFFF6F7FB),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    'Filtered',
                    style: theme.textTheme.bodySmall?.copyWith(
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    _compactAmount(filteredTotal),
                    style: theme.textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    _compactAmount(filteredReceived),
                    style: theme.textTheme.bodySmall,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFE6E7EE),
      appBar: AppBar(
        backgroundColor: const Color(0xFFE6E7EE),
        elevation: 0,
        centerTitle: true,
        title: Text(
          'Groups — Reports',
          style: TextStyle(
            color: Colors.grey[800],
            fontWeight: FontWeight.w700,
            fontSize: 18,
          ),
        ),
      ),
      body: SafeArea(
        child: BlocBuilder<SuperAdminFeeBloc, SuperAdminFeeState>(
          buildWhen: (previous, current) {
            // react to loading / loaded / error states
            return current is LoadingGroupNames ||
                current is GroupNamesLoaded ||
                current is SuperAdminFeeErrorState;
          },
          builder: (context, state) {
            // Pull-to-refresh wraps the content
            return RefreshIndicator(
              onRefresh: () async => _fetch(),
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 300),
                child: _buildStateContent(context, state),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildStateContent(BuildContext context, SuperAdminFeeState state) {
    if (state is LoadingGroupNames) {
      return const Center(child: CircularProgressIndicator());
    }

    if (state is SuperAdminFeeErrorState) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Failed to load groups',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: 12),
              ElevatedButton(onPressed: _fetch, child: const Text('Retry')),
            ],
          ),
        ),
      );
    }

    // primary loaded state
    if (state is GroupNamesLoaded) {
      final names = _filterNames(state.listOfNames);

      // show search + totals card + grid/list
      return Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: _baseSpacing,
          vertical: _baseSpacing,
        ),
        child: Column(
          children: [
            _buildSearchRow(),
            const SizedBox(height: _baseSpacing),
            // totals card inserted here
            _buildTotalsCard(context, names),
            const SizedBox(height: _baseSpacing),
            Expanded(child: _buildResponsiveGrid(context, names)),
          ],
        ),
      );
    }

    // fallback to cached summaries if available
    final cached = context.read<SuperAdminFeeBloc>().getGroupSummaries;
    if (cached.isNotEmpty) {
      final names = _filterNames(cached.keys.toList());
      return Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: _baseSpacing,
          vertical: _baseSpacing,
        ),
        child: Column(
          children: [
            _buildSearchRow(),
            const SizedBox(height: _baseSpacing),
            // totals card inserted here (uses cached summaries map)
            _buildTotalsCard(context, names),
            const SizedBox(height: _baseSpacing),
            Expanded(child: _buildResponsiveGrid(context, names)),
          ],
        ),
      );
    }

    return const Center(child: CircularProgressIndicator());
  }

  Widget _buildSearchRow() {
    return TextField(
      controller: _searchController,
      onChanged: (_) => setState(() {}),
      decoration: InputDecoration(
        hintText: 'Search groups',
        isDense: true,
        prefixIcon: const Icon(Icons.search),
        suffixIcon:
            _searchController.text.isEmpty
                ? null
                : IconButton(
                  onPressed: () {
                    _searchController.clear();
                    setState(() {});
                  },
                  icon: const Icon(Icons.clear),
                ),
        contentPadding: const EdgeInsets.symmetric(vertical: 12),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(_corner),
          borderSide: BorderSide.none,
        ),
        filled: true,
        fillColor: const Color(0xFFEFEFF6),
      ),
    );
  }

  Widget _buildResponsiveGrid(BuildContext context, List<String> names) {
    final summaries = context.read<SuperAdminFeeBloc>().getGroupSummaries;

    return LayoutBuilder(
      builder: (context, constraints) {
        // analytic geometry for responsive layout
        // choose number of columns by available width and desired card width range
        final maxWidth = constraints.maxWidth;

        int columns;
        double cardWidth;

        if (maxWidth < 420) {
          columns = 1;
          cardWidth = maxWidth - (_baseSpacing * 2);
        } else if (maxWidth < 800) {
          columns = 2;
          cardWidth = (maxWidth - (_baseSpacing * (columns + 1))) / columns;
        } else if (maxWidth < 1200) {
          columns = 3;
          cardWidth = (maxWidth - (_baseSpacing * (columns + 1))) / columns;
        } else {
          columns = 4;
          cardWidth = (maxWidth - (_baseSpacing * (columns + 1))) / columns;
        }

        // compute card height using a kept aspect ratio (analytic geometry)
        final desiredAspect = cardWidth / _minCardHeight; // width / height
        final childAspectRatio = desiredAspect.clamp(2.8, 4.5);

        // For small screens show ListView for comfortable vertical scrolling
        if (columns == 1) {
          return ListView.separated(
            physics: const BouncingScrollPhysics(),
            itemCount: names.length + 0, // no extra items
            separatorBuilder: (_, __) => const SizedBox(height: _baseSpacing),
            itemBuilder: (context, index) {
              final name = names[index];
              final summary = summaries[name];
              return ResponsiveGroupCard(
                groupName: name,
                summary: summary,
                cornerRadius: _corner,
              );
            },
          );
        }

        return GridView.builder(
          physics: const BouncingScrollPhysics(),
          itemCount: names.length,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: columns,
            mainAxisSpacing: _baseSpacing,
            crossAxisSpacing: _baseSpacing,
            childAspectRatio: childAspectRatio,
          ),
          itemBuilder: (context, index) {
            final name = names[index];
            final summary = summaries[name];
            return ResponsiveGroupCard(
              groupName: name,
              summary: summary,
              cornerRadius: _corner,
            );
          },
        );
      },
    );
  }
}

/// Responsive card following metrology and geometry rules.
/// - Tap area is full card
/// - Smooth animated status color
/// - Compact, legible typographic scale
class ResponsiveGroupCard extends StatelessWidget {
  final String groupName;
  final GroupFeeHistory? summary;
  final double cornerRadius;

  const ResponsiveGroupCard({
    Key? key,
    required this.groupName,
    required this.summary,
    this.cornerRadius = 14.0,
  }) : super(key: key);

  Color _statusColor(double remaining, double percent) {
    // Use both absolute remaining and percent to determine urgency
    if (remaining <= 0 || percent >= 100)
      return const Color(0xFF00C48C); // success
    if (percent < 33) return const Color(0xFFFF6B6B); // low progress = danger
    if (percent < 66) return const Color(0xFFFFA502); // warning
    return const Color(0xFFFFD166); // approaching completion
  }

  String _compactAmount(double value) {
    // simple K/M formatter
    if (value.abs() >= 1e6) return (value / 1e6).toStringAsFixed(1) + 'M';
    if (value.abs() >= 1e3) return (value / 1e3).toStringAsFixed(1) + 'K';
    return value.toStringAsFixed(2);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Semantics(
      label: 'Group card for $groupName',
      button: true,
      child: Material(
        color: const Color(0xFFE8EDF5),
        borderRadius: BorderRadius.circular(cornerRadius),
        child: InkWell(
          borderRadius: BorderRadius.circular(cornerRadius),
          onTap:
              summary == null
                  ? null
                  : () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder:
                            (_) => GroupFeeHistoryPage(groupName: groupName),
                      ),
                    );
                  },
          child: Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: const Color(0xFFE8EDF5),
              borderRadius: BorderRadius.circular(cornerRadius),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.04),
                  offset: const Offset(4, 4),
                  blurRadius: 8,
                ),
                BoxShadow(
                  color: Colors.white.withOpacity(0.9),
                  offset: const Offset(-4, -4),
                  blurRadius: 8,
                ),
              ],
            ),
            child:
                summary == null
                    ? _buildLoading(theme)
                    : _buildContent(theme, context),
          ),
        ),
      ),
    );
  }

  Widget _buildLoading(ThemeData theme) {
    return ConstrainedBox(
      constraints: const BoxConstraints(minHeight: 120),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '👥 GROUP',
            style: theme.textTheme.labelSmall?.copyWith(
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            groupName,
            style: theme.textTheme.titleSmall?.copyWith(
              fontWeight: FontWeight.w900,
            ),
          ),
          const SizedBox(height: 10),
          const SizedBox(height: 8, child: LinearProgressIndicator()),
        ],
      ),
    );
  }

  Widget _buildContent(ThemeData theme, BuildContext context) {
    final double total = summary!.total;
    final double received = summary!.received;
    final double remaining = summary!.remaining;
    final double progress =
        total > 0 ? (received / total).clamp(0.0, 1.0) : 0.0;
    final int percent = (progress * 100).round();
    final statusColor = _statusColor(remaining, percent.toDouble());

    return ConstrainedBox(
      constraints: const BoxConstraints(minHeight: 120),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // header row with chip
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '👥 GROUP',
                      style: theme.textTheme.labelSmall?.copyWith(
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      groupName,
                      style: theme.textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                  ],
                ),
              ),

              // status chip
              AnimatedContainer(
                duration: const Duration(milliseconds: 350),
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: statusColor,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      remaining <= 0 ? '🎉' : '🔔',
                      style: const TextStyle(color: Colors.white, fontSize: 14),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      remaining <= 0 ? 'Done' : 'Pending',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 11,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 10),

          // stats row
          Row(
            children: [
              _statBlock('💰', 'Total', _compactAmount(total)),
              const SizedBox(width: 12),
              _statBlock('✅', 'Received', _compactAmount(received)),
              const SizedBox(width: 12),
              _statBlock('⏳', 'Remaining', _compactAmount(remaining)),
            ],
          ),

          const SizedBox(height: 10),

          // progress and actions
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // progress bar
                    ClipRRect(
                      borderRadius: BorderRadius.circular(6),
                      child: SizedBox(
                        height: 10,
                        child: LinearProgressIndicator(value: progress),
                      ),
                    ),
                    const SizedBox(height: 6),
                    // percent with tooltip
                    Tooltip(
                      message: '$percent% collected',
                      child: Text(
                        '$percent%',
                        style: const TextStyle(
                          fontWeight: FontWeight.w700,
                          fontSize: 12,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(width: 8),

              SizedBox(
                height: 36,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) => GroupMembersScreen(groupId: groupName),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 14,
                      vertical: 8,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Text('Details'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _statBlock(String emoji, String label, String value) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(emoji, style: const TextStyle(fontSize: 16)),
        const SizedBox(width: 6),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: const TextStyle(fontSize: 10, fontWeight: FontWeight.w800),
            ),
            Text(
              value,
              style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w900),
            ),
          ],
        ),
      ],
    );
  }
}
