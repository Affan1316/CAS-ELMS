import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_cas_app_main/src/features/fee_feature/presentation/bloc/fee_admin_bloc.dart';
import 'package:flutter_cas_app_main/src/features/fee_feature/presentation/bloc/fee_admin_event.dart';
import 'package:flutter_cas_app_main/src/features/fee_feature/presentation/bloc/fee_admin_state.dart';
import 'package:flutter_cas_app_main/src/features/fee_feature/presentation/widgets/gradient_background.dart';
import 'package:flutter_cas_app_main/src/features/fee_feature/presentation/widgets/member_card_content.dart';
import 'package:flutter_cas_app_main/src/features/fee_feature/presentation/widgets/neu_card.dart';
import 'package:flutter_cas_app_main/src/features/fee_feature/presentation/widgets/responsive_padding.dart';
import 'package:flutter_cas_app_main/src/features/fee_feature/presentation/widgets/responsive_text.dart';
import 'package:flutter_cas_app_main/src/features/fee_feature/presentation/widgets/screen_header.dart';
import 'package:flutter_cas_app_main/src/features/fee_feature/presentation/widgets/search_field.dart';
import 'package:flutter_cas_app_main/src/features/my_student_attendence/presentation/student_adentence_page.dart';
import 'package:flutter_cas_app_main/src/features/student_feature/data/group_student_entity_class.dart';
import 'package:flutter_cas_app_main/src/features/student_feature/presentation/pages/student_side_fee_details_screen%20.dart';
import 'package:flutter_cas_app_main/src/features/time_graph_page/presentation/pages/time_track_graph_page.dart';
import 'fee_details_screen.dart';

class GroupMembersScreen extends StatefulWidget {
  final String groupId;
  final bool isNavigateToAttendence;
  final bool isNavigateToStudentFeeDetails;
  final bool isNavigateToWorkShopGraphPage;

  const GroupMembersScreen({
    super.key,
    required this.groupId,
    required this.isNavigateToAttendence,
    required this.isNavigateToStudentFeeDetails,
    required this.isNavigateToWorkShopGraphPage,
  });

  @override
  State<GroupMembersScreen> createState() => _GroupMembersScreenState();
}

class _GroupMembersScreenState extends State<GroupMembersScreen> {
  final TextEditingController _searchController = TextEditingController();
  List<StudentFeatureGroupStudentEntityClass> _filteredStudents = [];
  List<StudentFeatureGroupStudentEntityClass> _nonfilteredStudents = [];
  Timer? _afterThisTimeFilterAgain;

  // Track currently selected student for navigation
  StudentFeatureGroupStudentEntityClass? _selectedStudent;

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
    _afterThisTimeFilterAgain = Timer(const Duration(milliseconds: 500), () {
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
        backgroundColor: Colors.white,
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
                ),
                const SizedBox(height: 20),

                /// ✅ Single BlocListener for navigation
                BlocListener<FeeAdminBloc, FeeAdminState>(
                  listenWhen:
                      (_, curr) => curr is CheckingingFeeDefaulterCompleteState,
                  listener: (context, state) {
                    if (state is CheckingingFeeDefaulterCompleteState &&
                        _selectedStudent != null) {
                      context.read<FeeAdminBloc>().add(
                        GetStudentInstalmentEvent(
                          studentId: _selectedStudent!.rollNum,
                          groupId: widget.groupId,
                        ),
                      );

                      debugPrint(
                        "isNavigateToAttendence:${widget.isNavigateToAttendence}",
                      );
                      debugPrint(
                        "isNavigateToStudentFeeDetails:${widget.isNavigateToStudentFeeDetails}",
                      );
                      debugPrint(
                        "isNavigateToWorkShopGraphPage:${widget.isNavigateToWorkShopGraphPage}",
                      );

                      if (widget.isNavigateToAttendence) {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder:
                                (_) => StudentAdentencePage(
                                  rollNo: _selectedStudent!.rollNum,
                                  name: _selectedStudent!.name,
                                ),
                          ),
                        );
                      } else {
                        if (widget.isNavigateToStudentFeeDetails) {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder:
                                  (_) => StudentSideFeeDetailsScreen(
                                    key: ValueKey(_selectedStudent!.rollNum),
                                    studentId: _selectedStudent!.rollNum,
                                  ),
                            ),
                          );
                        } else {
                          if (widget.isNavigateToWorkShopGraphPage) {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder:
                                    (_) => StudentTimeTrackerPage(
                                      rollNo: _selectedStudent!.rollNum,
                                    ),
                              ),
                            );
                          } else {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder:
                                    (_) => FeeDetailsScreen(
                                      groupId: widget.groupId,
                                      isDefaulter: false,
                                      key: ValueKey(_selectedStudent!.rollNum),
                                      studentId: _selectedStudent!.rollNum,
                                    ),
                              ),
                            );
                          }
                        }
                      }
                    }
                  },
                  child: BlocBuilder<FeeAdminBloc, FeeAdminState>(
                    builder: (context, state) {
                      if (state is FeeAdminGroupStudentsLoadedState) {
                        _filteredStudents = state.dataList;
                        _nonfilteredStudents = state.dataList;
                      }
                      if (state
                          is FeeAdminGroupStudentsFilteringCompleteState) {
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
                                      child: MemberCardContent(
                                        student: student,
                                        groupId: widget.groupId,
                                        isNavigateToAttendence:
                                            widget.isNavigateToAttendence,
                                        isNavigateToWorkShopGraphPage:
                                            widget
                                                .isNavigateToWorkShopGraphPage,
                                        onViewFee: (s) {
                                          _selectedStudent = s;
                                          context.read<FeeAdminBloc>().add(
                                            CheckFeeDefaulterEvent(
                                              groupId: widget.groupId,
                                              studentId: s.rollNum,
                                            ),
                                          );
                                        },
                                      ),
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
                                      child: MemberCardContent(
                                        student: student,
                                        groupId: widget.groupId,
                                        isNavigateToAttendence:
                                            widget.isNavigateToAttendence,
                                        isNavigateToWorkShopGraphPage:
                                            widget
                                                .isNavigateToWorkShopGraphPage,
                                        onViewFee: (s) {
                                          _selectedStudent = s;
                                          context.read<FeeAdminBloc>().add(
                                            CheckFeeDefaulterEvent(
                                              groupId: widget.groupId,
                                              studentId: s.rollNum,
                                            ),
                                          );
                                        },
                                      ),
                                    );
                                  },
                                ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
