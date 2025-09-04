import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_cas_app_main/src/features/group/domain/usecases/add_group_usecase.dart';
import 'package:flutter_cas_app_main/src/features/group/domain/usecases/update_group_usecase.dart';
import 'package:flutter_cas_app_main/src/features/group/presentation/bloc/group_events.dart';
import 'package:flutter_cas_app_main/src/features/group/presentation/bloc/group_states.dart';

class AddGroupBloc extends Bloc<GroupEvents, GroupStates> {
  AddGroupUsecase addGroupUsecase;
  UpdateGroupUsecase updateGroupUsecase;
  AddGroupBloc({
    required this.addGroupUsecase,
    required this.updateGroupUsecase,
  }) : super(GroupInitialState()) {
    on<AddGroupEvent>(_addGroup);
    on<UpdateGroupEvent>(_updateGroup);
  }

  Future<void> _addGroup(AddGroupEvent event, Emitter<GroupStates> emit) async {
    try {
      emit(GroupLoadingState());
      await addGroupUsecase(groupEntity: event.groupEntity);
      emit(GroupSubmittedState());
    } catch (e) {
      print(e.toString());
    }
  }

  Future<void> _updateGroup(
    UpdateGroupEvent event,
    Emitter<GroupStates> emit,
  ) async {
    try {
      await updateGroupUsecase(
        groupId: event.groupId,
        groupEntity: event.groupEntity,
      );
    } catch (e) {
      print(e.toString());
    }
  }
}
