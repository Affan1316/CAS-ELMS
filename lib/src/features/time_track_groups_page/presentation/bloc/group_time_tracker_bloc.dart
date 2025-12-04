import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:meta/meta.dart';

part 'group_time_tracker_event.dart';
part 'group_time_tracker_state.dart';

class GroupTimeTrackerBloc
    extends Bloc<GroupTimeTrackerEvent, GroupTimeTrackerState> {
  GroupTimeTrackerBloc() : super(GroupTimeTrackerInitial()) {
    on<SelectCourseEvent>((event, emit) async {
      emit(GroupTimeTrackerLoading());
      try {
        var groups =
            await FirebaseFirestore.instance
                .collection("groups")
                .where("CourseName", isEqualTo: event.courseName)
                .get();
        if (groups.docs.isNotEmpty) {
          List<String> groupNames = [];
          for (var group in groups.docs) {
            groupNames.add(group["GroupName"]);
          }
          emit(
            GroupLoaded(groupNames: groupNames, courseName: event.courseName),
          );
        } else {
          emit(GroupTimeTrackerError(error: "No groups found"));
        }
      } catch (e) {
        emit(GroupTimeTrackerError());
      }
    });
  }
}
