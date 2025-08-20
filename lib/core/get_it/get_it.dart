import 'package:get_it/get_it.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:social_site_app/core/api/api_client.dart';
import 'package:social_site_app/core/datasource/auth_remote_datasource.dart';
import 'package:social_site_app/core/repository/job_type_repository.dart';
import 'package:social_site_app/core/repository_impl/auth_repository_impl.dart';
import 'package:social_site_app/core/repository_impl/job_type_repository_impl.dart';
import 'package:social_site_app/features/auth/presentation/bloc/user_bloc.dart';
import 'package:social_site_app/features/chat/presentation/bloc/chat_bloc.dart';
import 'package:social_site_app/features/create_meet/presentation/bloc/create_meet_bloc.dart';
import 'package:social_site_app/features/create_meet/presentation/bloc/location_picker_bloc.dart';
import 'package:social_site_app/core/repository/meet_repository.dart';
import 'package:social_site_app/features/job_type/bloc/job_type_bloc.dart';
import 'package:social_site_app/features/meet/presentation/bloc/meet_bloc.dart';
import 'package:social_site_app/features/profile/presentation/bloc/last_meets_bloc.dart';

import '../../features/create_meet/presentation/bloc_emergency/create_emergency_bloc.dart';
import '../datasource/emergency_remote_datasource.dart';
import '../datasource/job_type_remote_datasource.dart';
import '../datasource/user_remote_datasource.dart';
import '../repository/emergency_repository.dart';
import '../repository_impl/emergency_repository_impl.dart';
import '../repository_impl/user_repository_impl.dart';
import '../repository/auth_repository.dart';
import '../repository/user_repository.dart';
import '../datasource/chat_remote_datasource.dart';
import '../datasource/chat_socket_datasource.dart';
import '../repository_impl/chat_repository_impl.dart';
import '../repository/chat_repository.dart';
import '../../features/main/presentation/bloc/main_bloc.dart';
import '../datasource/meet_remote_datasource.dart';
import '../repository_impl/meet_repository_impl.dart';

var getIt = GetIt.instance;

void setup(){
registerGoogleSignIn();
registerApiClient();
registerDataSource();
registerRepositories();
registerBloc();
}

void registerGoogleSignIn(){
 getIt.registerSingleton(GoogleSignIn());
}
void registerApiClient(){
 getIt.registerSingleton(ApiClient());
}
void registerDataSource(){
 var dio = getIt<ApiClient>().getDio();
 var dioWithToken = getIt<ApiClient>().getDio(tokenInterceptor: true);
 getIt.registerSingleton(AuthRemoteDatasource(dio: dio));
 getIt.registerSingleton(UserRemoteDatasource(dio: dioWithToken));
 getIt.registerSingleton(MeetRemoteDatasource(dio: dioWithToken));
 getIt.registerSingleton(ChatRemoteDatasource(dio: dioWithToken));
 getIt.registerSingleton(ChatSocketDatasource());
 getIt.registerSingleton(JobTypeRemoteDatasource(dio: dioWithToken));
 getIt.registerSingleton(EmergencyRemoteDatasource(dio: dioWithToken));



}
void registerRepositories(){
 getIt.registerSingleton<AuthRepository>(
     AuthRepositoryImpl(authRemoteDatasource: getIt(), googleSignIn: getIt()));
 getIt.registerSingleton<UserRepository>(
     UserRepositoryImpl(userRemoteDatasource: getIt()));
 getIt.registerSingleton<MeetRepository>(
     MeetRepositoryImpl(meetRemoteDatasource: getIt()));
 getIt.registerSingleton<ChatRepository>(
     ChatRepositoryImpl(chatRemoteDatasource: getIt(), chatSocketDatasource: getIt()));
 getIt.registerSingleton<JobTypeRepository>(
     JobTypeRepositoryImpl(jobTypeRemoteDatasource: getIt()));
 getIt.registerSingleton<EmergencyRepository>(
     EmergencyRepositoryImpl(emergencyRemoteDatasource: getIt()));
}

void registerBloc(){

 getIt.registerFactory(
         () => UserBloc(authRepository: getIt(), userRepository: getIt()));
 getIt.registerFactory(
         () => LastMeetsBloc(meetRepository: getIt()));
 getIt.registerFactory(() => LocationPickerBloc());
 getIt.registerFactory(() => CreateMeetBloc(meetRepository: getIt()));
 getIt.registerFactory(() => MeetBloc(meetRepository: getIt()));
 getIt.registerFactory(() => MainBloc(meetRepository: getIt()));
 getIt.registerFactory(() => ChatBloc(chatRepository: getIt()));
 getIt.registerFactory(() => JobTypeBloc(jobTypeRepository: getIt()));
 getIt.registerFactory(() => CreateEmergencyBloc(emergencyRepository: getIt()));

}