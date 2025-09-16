// Data Models

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_cas_app_main/src/features/fee_feature/data/data_source/data_service_fee_feature.dart';
import 'package:flutter_cas_app_main/src/features/fee_feature/presentation/bloc/fee_admin_bloc.dart';
import 'package:flutter_cas_app_main/src/features/fee_feature/presentation/bloc/fee_admin_event.dart';
import 'package:flutter_cas_app_main/src/features/fee_feature/presentation/bloc/fee_admin_state.dart';
import 'package:flutter_cas_app_main/src/features/fee_feature/presentation/widgets/gradient_background.dart';
import 'package:flutter_cas_app_main/src/features/fee_feature/data/entities/group_fee_feature.dart';
import 'package:flutter_cas_app_main/src/features/fee_feature/presentation/widgets/member_card_content.dart';
import 'package:flutter_cas_app_main/src/features/fee_feature/presentation/widgets/neu_card.dart';
import 'package:flutter_cas_app_main/src/features/fee_feature/presentation/widgets/responsive_padding.dart';
import 'package:flutter_cas_app_main/src/features/fee_feature/presentation/widgets/responsive_text.dart';
import 'package:flutter_cas_app_main/src/features/fee_feature/presentation/widgets/screen_header.dart';
import 'package:flutter_cas_app_main/src/features/fee_feature/presentation/widgets/search_field.dart';
import 'package:flutter_cas_app_main/src/features/fee_feature/data/entities/student_fee_feature.dart';
import 'package:flutter_cas_app_main/src/features/student_feature/data/group_student_entity_class.dart';

class GroupMembersScreen extends StatefulWidget {
  final String groupId;
  const GroupMembersScreen({super.key, required this.groupId});

  @override
  State<GroupMembersScreen> createState() => _GroupMembersScreenState();
}

class _GroupMembersScreenState extends State<GroupMembersScreen> {
  final TextEditingController _searchController = TextEditingController();
  List<StudentFeatureGroupStudentEntityClass> _filteredStudents = [];
  List<StudentFeatureGroupStudentEntityClass> _nonfilteredStudents = [];
  Timer? _afterThisTimeFilterAgain;
  // late GroupFeeFeature group;

  @override
  void initState() {
    super.initState();

    context.read<FeeAdminBloc>().add(
      FeeAdminFetchGroupsStudentEvent(groupTitle: widget.groupId),
    );

    _searchController.addListener(() {
      _filterStudents(_searchController.text);
    });
  }

  void _filterStudents(String query) {
    if (_afterThisTimeFilterAgain?.isActive ?? false) {
      _afterThisTimeFilterAgain!.cancel();
    }
    _afterThisTimeFilterAgain = Timer(Duration(milliseconds: 500), () {
      context.read<FeeAdminBloc>().add(
        FeeAdminGroupStudentsFilteringEvent(query: _searchController.text),
      );
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isTablet = MediaQuery.of(context).size.width > 600;

    return GradientBackground(
      child: Scaffold(
        body: SafeArea(
          child: ResponsivePadding(
            child: Column(
              children: [
                ScreenHeader(
                  title: widget.groupId,
                  trailing: IconButton(
                    icon: const Icon(Icons.refresh, color: Color(0xFF3E206D)),
                    onPressed: () {
                      setState(() {
                        _searchController.clear();
                        _filteredStudents = _nonfilteredStudents;
                      });
                    },
                  ),
                ),
                const SizedBox(height: 16),
                SearchField(
                  controller: _searchController,
                  hintText: "Search students by name or ID...",
                  // onChanged: _filterStudents,
                ),
                const SizedBox(height: 20),
                BlocBuilder<FeeAdminBloc, FeeAdminState>(
                  builder: (context, state) {
                    if (state is FeeAdminGroupStudentsLoadedState) {
                      _filteredStudents = state.dataList;
                      _nonfilteredStudents = state.dataList;
                    }
                    if (state is FeeAdminGroupStudentsFilteringCompleteState) {
                      _filteredStudents = state.filteredDataList;
                    }

                    return Expanded(
                      child:
                          _filteredStudents.isEmpty
                              ? const Center(
                                child: ResponsiveText(
                                  text: "No students found",
                                  phoneSize: 16,
                                  tabletSize: 20,
                                  color: Colors.grey,
                                ),
                              )
                              : isTablet
                              ? GridView.builder(
                                gridDelegate:
                                    const SliverGridDelegateWithFixedCrossAxisCount(
                                      crossAxisCount: 2,
                                      crossAxisSpacing: 20,
                                      mainAxisSpacing: 20,
                                      childAspectRatio: 3.5,
                                    ),
                                itemCount: _filteredStudents.length,
                                itemBuilder: (context, index) {
                                  final student = _filteredStudents[index];
                                  return NeuCard(
                                    child: MemberCardContent(student: student),
                                  );
                                },
                              )
                              : ListView.separated(
                                itemCount: _filteredStudents.length,
                                separatorBuilder:
                                    (_, __) => const SizedBox(height: 16),
                                itemBuilder: (context, index) {
                                  final student = _filteredStudents[index];
                                  return NeuCard(
                                    child: MemberCardContent(student: student),
                                  );
                                },
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
