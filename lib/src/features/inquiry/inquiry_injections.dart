import 'package:flutter_cas_app_main/src/features/inquiry/domain/repositories/inquiry_repository.dart';
import 'package:get_it/get_it.dart';
import 'package:flutter_cas_app_main/src/features/inquiry/data/datasources/inquiry_remote_data_source.dart';
import 'package:flutter_cas_app_main/src/features/inquiry/data/repositories/inquiry_repository_impl.dart';
import 'package:flutter_cas_app_main/src/features/inquiry/domain/usecases/create_inquiry.dart';
import 'package:flutter_cas_app_main/src/features/inquiry/domain/usecases/get_inquiry.dart';
import 'package:flutter_cas_app_main/src/features/inquiry/presentation/bloc/inquiry_bloc.dart';


Future<void> initInquiry(GetIt sl) async {
  
  // Data source
  sl.registerLazySingleton<InquiryRemoteDataSource>(
    () => InquiryRemoteDataSource(sl()),
  );

  // Repository (only register interface)
  sl.registerLazySingleton<InquiryRepository>(
    () => InquiryRepositoryImpl(sl()),
  );

  // Use cases
  sl.registerLazySingleton<CreateInquiry>(() => CreateInquiry(sl()));
  sl.registerLazySingleton<GetInquiry>(() => GetInquiry(sl()));

  // Bloc
  sl.registerFactory<InquiryBloc>(() => InquiryBloc(sl(), sl()));
}
