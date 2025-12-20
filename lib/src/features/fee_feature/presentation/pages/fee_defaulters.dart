import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_cas_app_main/src/features/fee_feature/presentation/bloc/fee_admin_bloc.dart';
import 'package:flutter_cas_app_main/src/features/fee_feature/presentation/bloc/fee_admin_event.dart';
import 'package:flutter_cas_app_main/src/features/fee_feature/presentation/bloc/fee_admin_state.dart';
import 'package:flutter_cas_app_main/src/features/fee_feature/presentation/pages/fee_defaulters_group_detail_page.dart';

class FeeDefaulters extends StatefulWidget {
  const FeeDefaulters({super.key});

  @override
  State<FeeDefaulters> createState() => _FeeDefaultersState();
}

class _FeeDefaultersState extends State<FeeDefaulters> {
  List<String> _fullGroupNames = [];
  List<String> _displayedGroupNames = [];

  String? selectedGroup;
  bool isLoading = true;
  String? errorMessage;

  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    isLoading = true;
    errorMessage = null;
    context.read<FeeAdminBloc>().add(ReadFeeDefaulterGroupsEvent());
    _searchController.addListener(_filterGroups);
  }

  @override
  void dispose() {
    _searchController.removeListener(_filterGroups);
    _searchController.dispose();
    super.dispose();
  }

  void _filterGroups() {
    final q = _searchController.text.trim().toLowerCase();
    if (q.isEmpty) {
      setState(() => _displayedGroupNames = List<String>.from(_fullGroupNames));
      return;
    }

    final results =
        _fullGroupNames.where((g) => g.toLowerCase().contains(q)).toList();
    setState(() => _displayedGroupNames = results);
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    final height = size.height;

    return BlocConsumer<FeeAdminBloc, FeeAdminState>(
      listener: _blocListener,
      builder: (context, state) {
        if (isLoading) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        if (errorMessage != null) {
          return _buildErrorScreen(context);
        }

        return SafeArea(
          child: Scaffold(
            backgroundColor: Colors.white,
            body: Column(
              children: [
                _buildHeader(height),
                Expanded(child: _buildBody(context)),
              ],
            ),
          ),
        );
      },
    );
  }

  void _blocListener(BuildContext context, FeeAdminState state) {
    if (state is GroupNamesReadCompleted) {
      setState(() {
        _fullGroupNames = List<String>.from(state.listOFGroupNames);
        _displayedGroupNames = List<String>.from(_fullGroupNames);
        isLoading = false;
        errorMessage = null;
      });
    } else if (state is FeeDefaultersDataLoaded) {
      if (selectedGroup != null && state.feeDefaultersCollective != null) {
        Navigator.of(context)
            .push(
              MaterialPageRoute(
                builder:
                    (context) => FeeDefaultersGroupDetailPage(
                      listOfFeeDefaulterEntity: state.listOFFeeDefaulterEntity,
                      feeDefaultersCollective: state.feeDefaultersCollective!,
                      groupName: selectedGroup!,
                    ),
              ),
            )
            .then((_) {
              selectedGroup = null;
            });
      } else {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Data not available for this group')),
          );
        }
      }
    } else if (state is FeeAdminErrorState) {
      setState(() {
        errorMessage = state.error;
        isLoading = false;
      });
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(state.error)));
      }
    }
  }

  Widget _buildHeader(double height) {
    return Column(
      children: [
        Container(
          width: double.infinity,
          height: height * 0.28,
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFF0E96C5), Color(0xFF4CC9F0), Color(0xFF8E9EFF)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: const Center(
            child: Padding(
              padding: EdgeInsets.only(bottom: 70),
              child: Text(
                'Fee Defaulters',
                style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ),
        // Simple search field
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8),
          child: TextField(
            controller: _searchController,
            decoration: InputDecoration(
              hintText: 'Search groups by name...',
              filled: true,
              fillColor: Colors.white,
              prefixIcon: const Icon(Icons.search),
              suffixIcon:
                  _searchController.text.isNotEmpty
                      ? IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: () {
                          _searchController.clear();
                          _filterGroups();
                        },
                      )
                      : null,
              contentPadding: const EdgeInsets.symmetric(vertical: 12),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(
                  color: Colors.black, // Black border
                  width: 2, // Thickness of border
                ),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: Colors.black, width: 2),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: Colors.black12, width: 2),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildBody(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(45),
          topRight: Radius.circular(45),
        ),
      ),
      child: Column(
        children: [
          // // Month Selector (placeholder)
          // Padding(
          //   padding: const EdgeInsets.all(16.0),
          //   child: Row(
          //     mainAxisAlignment: MainAxisAlignment.start,
          //     children: [
          //       ElevatedButton.icon(
          //         onPressed: () {
          //           // TODO: Implement month picker
          //         },
          //         icon: const Icon(Icons.arrow_downward_rounded),
          //         label: const Text('Select Month'),
          //         style: const ButtonStyle(
          //           backgroundColor: WidgetStatePropertyAll(
          //             Color(0xFF0E96C5),
          //           ),
          //           foregroundColor: WidgetStatePropertyAll(Colors.white),
          //         ),
          //       ),
          //     ],
          //   ),
          // ),

          // List of Groups
          Expanded(
            child:
                _displayedGroupNames.isEmpty
                    ? Center(
                      child:
                          _fullGroupNames.isEmpty
                              ? const Text(
                                'No groups available',
                                style: TextStyle(fontSize: 16),
                              )
                              : Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: const [
                                  Icon(
                                    Icons.search_off,
                                    size: 64,
                                    color: Colors.black26,
                                  ),
                                  SizedBox(height: 12),
                                  Text(
                                    'No groups match your search',
                                    style: TextStyle(fontSize: 16),
                                  ),
                                ],
                              ),
                    )
                    : ListView.builder(
                      itemCount: _displayedGroupNames.length,
                      itemBuilder: (context, index) {
                        final groupName = _displayedGroupNames[index];
                        return InkWell(
                          onTap: () {
                            selectedGroup = groupName;
                            context.read<FeeAdminBloc>().add(
                              ReadFeeDefaulterEvent(groupId: groupName),
                            );
                          },
                          borderRadius: BorderRadius.circular(20),
                          child: GroupCard(groupName: groupName),
                        );
                      },
                    ),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorScreen(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  errorMessage ?? 'Unknown error',
                  style: const TextStyle(fontSize: 16),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      isLoading = true;
                      errorMessage = null;
                    });
                    context.read<FeeAdminBloc>().add(
                      ReadFeeDefaulterGroupsEvent(),
                    );
                  },
                  child: const Text('Retry'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class GroupCard extends StatelessWidget {
  final String groupName;

  const GroupCard({super.key, required this.groupName});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 20),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: const [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 10,
            offset: Offset(2, 4),
          ),
        ],
      ),
      child: Text(
        groupName,
        style: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: Color(0xFF2D3142),
        ),
      ),
    );
  }
}
