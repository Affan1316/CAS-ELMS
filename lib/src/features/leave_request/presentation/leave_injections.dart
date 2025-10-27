import 'package:flutter_cas_app_main/src/features/leave_request/data/datasources/leave_remote_data_source.dart';
import 'package:flutter_cas_app_main/src/features/leave_request/data/repository/leave_repository_impl.dart';
import 'package:flutter_cas_app_main/src/features/leave_request/domain/repository/leave_repository.dart';
import 'package:flutter_cas_app_main/src/features/leave_request/domain/usecases/create_leave.dart';
import 'package:flutter_cas_app_main/src/features/leave_request/domain/usecases/get_leave.dart';
import 'package:flutter_cas_app_main/src/features/leave_request/domain/usecases/update_leave.dart';
import 'package:flutter_cas_app_main/src/features/leave_request/presentation/bloc/leave_bloc.dart';
import 'package:get_it/get_it.dart';

Future<void> initLeave(GetIt sl) async {
  
  // Data source
  sl.registerLazySingleton<LeaveRemoteDataSource>(
    () => LeaveRemoteDataSource(sl()),
  );

  // Repository
  sl.registerLazySingleton<LeaveRepository>(
    () => LeaveRepositoryImpl(sl()),
  );

  // Use cases
  sl.registerLazySingleton<CreateLeave>(() => CreateLeave(sl()));
  sl.registerLazySingleton<GetLeave>(() => GetLeave(sl()));
  sl.registerLazySingleton<UpdateLeave>(() => UpdateLeave(sl()));
  

  // Bloc
  sl.registerFactory<LeaveBloc>(() => LeaveBloc(sl(),sl(),sl()));
}