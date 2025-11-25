import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_cas_app_main/src/core/theme/app_colors.dart';
import 'package:flutter_cas_app_main/src/features/my_student_attendence/presentation/widget/attendence_content_view.dart';

import 'bloc/student_attendence_bloc_bloc.dart';

// StudentAdentencePage
class StudentAdentencePage extends StatefulWidget {
  const StudentAdentencePage({super.key});

  @override
  State<StudentAdentencePage> createState() => _StudentAdentencePageState();
}

class _StudentAdentencePageState extends State<StudentAdentencePage> {
  @override
  void initState() {
    super.initState();
    context.read<StudentAttendenceBloc>().add(LoadAttendance());
  }
   void onLocationPressed(){
     context.read<StudentAttendenceBloc>().add(LocationCheckEvent());

   }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffoldLightThemeBackground,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },


        ),
        title: const Text('Attendance'),actions: [IconButton(onPressed: onLocationPressed, icon: Icon(Icons.location_on_outlined))],actionsPadding: EdgeInsets.only(right: 10),
      ),
      // BlocBuilder rebuilds the UI based on the BLoC's state
      body: BlocBuilder<StudentAttendenceBloc, AttendanceState>(
        bloc: context.read<StudentAttendenceBloc>(),
        builder: (context, state) {
          // Handle the Loading state
          if (state is AttendanceLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          // Handle the Loaded state
          if (state is AttendanceLoaded) {
            return AttendanceContentView(
              student: state.student,
              records: state.records,
            );
          }
          // Handle the Error state
          if (state is AttendanceError) {
            return Center(child: Text(state.message));
          }
          // Default empty state
          return const Center(child: Text('No data.'));
        },
      ),
    );
  }
}
