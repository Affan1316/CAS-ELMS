import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_cas_app_main/src/features/fee_feature/presentation/pages/group_members_screen.dart';
import 'package:flutter_cas_app_main/src/features/super_admin_fee_feature/data/entity/group_fee_history.dart';
import 'package:flutter_cas_app_main/src/features/super_admin_fee_feature/presentation/bloc/super_admin_fee_bloc.dart';
import 'package:flutter_cas_app_main/src/features/super_admin_fee_feature/presentation/bloc/super_admin_fee_event.dart';
import 'package:flutter_cas_app_main/src/features/super_admin_fee_feature/presentation/bloc/super_admin_fee_state.dart';
import 'package:flutter_cas_app_main/src/features/super_admin_fee_feature/presentation/widgets/all_group_fee_card.dart';

import '../widgets/list_tile.dart';

/// Improved Groups report page with totals card added.
/// - Shows totals of all groups and totals of visible groups (when searching)
/// - Uses existing bloc cache to compute totals (only counts loaded summaries)
class GroupsReportPage extends StatefulWidget {
  const GroupsReportPage({super.key});

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
    if (value.abs() >= 1e6) return '${(value / 1e6).toStringAsFixed(1)}M';
    if (value.abs() >= 1e3) return '${(value / 1e3).toStringAsFixed(1)}K';
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
      color: const Color(0xFF5B21B6),
      borderRadius: BorderRadius.circular(_corner),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [Color(0xFF5B21B6), Color(0xFF4C1D95)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(_corner),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              offset: const Offset(0, 4),
              blurRadius: 12,
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
                      color: const Color(0xFFE2E8F0),
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    _compactAmount(totalAll),
                    style: theme.textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.w900,
                      fontSize: 18,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Received ${_compactAmount(receivedAll)} • $loadedCount/${summaries.length} loaded',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: const Color(0xFFA0AEC0),
                    ),
                  ),
                ],
              ),
            ),

            // Right block: filtered totals (when search is used)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: const Color(0xFF7C3AED),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    'Filtered',
                    style: theme.textTheme.bodySmall?.copyWith(
                      fontWeight: FontWeight.w800,
                      color: const Color(0xFFE2E8F0),
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    _compactAmount(filteredTotal),
                    style: theme.textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.w900,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    _compactAmount(filteredReceived),
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: const Color(0xFFA0AEC0),
                    ),
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
      backgroundColor: const Color(0xFFF7FAFC),
      appBar: AppBar(
        backgroundColor: const Color(0xFFF7FAFC),
        elevation: 0,
        centerTitle: true,
        title: Text(
          'Groups — Reports',
          style: TextStyle(
            color: const Color(0xFF2D3748),
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

  //  Align(alignment: Alignment.bottomCenter,child: AllGroupsFeeCard(),)
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
    //TOD0: add TotalsCard
    // primary loaded state
    if (state is GroupNamesLoaded) {
      final names = _filterNames(state.listOfNames);

      // show search + totals card + grid/list
      return Stack(
        fit: StackFit.expand,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: _baseSpacing,
              vertical: _baseSpacing,
            ),
            child: Column(
              children: [
                _buildSearchRow(),
                const SizedBox(height: _baseSpacing),
                // totals card inserted here
                // _buildTotalsCard(context, names),
                const SizedBox(height: _baseSpacing),
                Expanded(child: _buildResponsiveGrid(context, names)),
              ],
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: AllGroupsFeeCard(names: names),
          ),
        ],
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
      style: TextStyle(color: const Color.fromARGB(255, 0, 0, 0)),
      decoration: InputDecoration(
        hintText: 'Search groups',
        isDense: true,
        prefixIcon: const Icon(Icons.search, color: Color(0xFF718096)),
        suffixIcon:
            _searchController.text.isEmpty
                ? null
                : IconButton(
                  onPressed: () {
                    _searchController.clear();
                    setState(() {});
                  },
                  icon: const Icon(Icons.clear, color: Color(0xFF718096)),
                ),
        contentPadding: const EdgeInsets.symmetric(vertical: 12),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(_corner),
          borderSide: BorderSide.none,
        ),
        filled: true,
        fillColor: Colors.white,
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
    super.key,
    required this.groupName,
    required this.summary,
    this.cornerRadius = 14.0,
  });

  Color _statusColor(double remaining, double percent) {
    // Use both absolute remaining and percent to determine urgency
    if (remaining <= 0 || percent >= 100) {
      return const Color(0xFF10B981); // success - vibrant green
    }
    if (percent < 33) {
      return const Color(0xFFEF4444); // low progress = danger - vibrant red
    }
    if (percent < 66) {
      return const Color(0xFFF59E0B); // warning - vibrant orange
    }
    return const Color(0xFF3B82F6); // approaching completion - vibrant blue
  }

  String _compactAmount(double value) {
    // simple K/M formatter
    if (value.abs() >= 1e6) return '${(value / 1e6).toStringAsFixed(1)}M';
    if (value.abs() >= 1e3) return '${(value / 1e3).toStringAsFixed(1)}K';
    return value.toStringAsFixed(2);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return summary == null
        ? _buildContent(theme, context, true)
        : _buildContent(theme, context);
  }

  Widget _buildLoading(ThemeData theme) {
    return ConstrainedBox(
      constraints: const BoxConstraints(
        minHeight: 80,
        maxWidth: 320,
        minWidth: 280,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                '👥 ',
                style: theme.textTheme.labelSmall?.copyWith(
                  fontWeight: FontWeight.w800,
                  color: const Color(0xFF64748B),
                  fontSize: 22,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                groupName,
                style: theme.textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.w900,
                  color: const Color(0xFF1E293B),
                  fontSize: 22,
                ),
              ),
              Expanded(child: Container()),
            ],
          ),
          const SizedBox(height: 22),
          const SizedBox(height: 8, child: LinearProgressIndicator()),
        ],
      ),
    );
  }

  Widget _buildContent(
    ThemeData theme,
    BuildContext context, [
    bool isNull = false,
  ]) {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(
          color: Color(0xFFE0E2E7),
          width: 1,
        ), // Thin border for M3 look
      ),
      color: Color(0xFFF8FAFC), // Very light grey surface
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        // M3 ripple color
        splashColor: Color(0xFFE2E8F0),
        onTap: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder:
                  (_) => GroupMembersScreen(
                    groupId: groupName,
                    isNavigateToAttendence: false,
                    isNavigateToStudentFeeDetails: true,
                    isNavigateToWorkShopGraphPage: false,
                  ),
            ),
          );
        },
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 320),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header Row
                Row(
                  children: [
                    const Icon(
                      Icons.groups_rounded,
                      color: Color(0xFF6366F1), // Static Indigo Primary
                      size: 28,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        groupName,
                        style: const TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF1E293B), // Dark Slate
                          letterSpacing: -0.5,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 18),

                // Stats Container
                Builder(
                  builder: (context) {
                    if (!isNull) {
                      final double total = summary!.total;
                      final double received = summary!.received;
                      final double remaining = summary!.remaining;
                      final double progress =
                          total > 0 ? (received / total).clamp(0.0, 1.0) : 0.0;
                      final int percent = (progress * 100).round();
                      final statusColor = _statusColor(
                        remaining,
                        percent.toDouble(),
                      );
                      return Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: const Color(0xFFF1F5F9)),
                        ),
                        child: Column(
                          children: [
                            ListTileForGroupFee(
                              label: "Total",
                              value: _compactAmount(total),
                            ),
                            const Divider(
                              height: 1,
                              color: Color(0xFFF1F5F9),
                              indent: 12,
                              endIndent: 12,
                            ),
                            ListTileForGroupFee(
                              label: "Received",
                              value: _compactAmount(received),
                              valueColor: const Color(0xFF10B981),
                            ), // Green
                            const Divider(
                              height: 1,
                              color: Color(0xFFF1F5F9),
                              indent: 12,
                              endIndent: 12,
                            ),
                            ListTileForGroupFee(
                              label: "Remaining",
                              value: _compactAmount(remaining),
                              valueColor: const Color(0xFFEF4444),
                            ), // Red
                          ],
                        ),
                      );
                    } else {
                      return const SizedBox(
                        height: 8,
                        child: LinearProgressIndicator(),
                      );
                    }
                  },
                ),
              ],
            ),
          ),
        ),
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
              style: const TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.w800,
                color: Color(0xFF64748B),
              ),
            ),
            Text(
              value,
              style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w900,
                color: Color(0xFF1E293B),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
