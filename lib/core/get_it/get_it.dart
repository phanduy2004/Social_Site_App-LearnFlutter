import 'package:get_it/get_it.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:social_site_app/core/api/api_client.dart';
import 'package:social_site_app/core/model/failure.dart';
import 'package:social_site_app/features/auth/data/datasource/auth_remote_datasource.dart';
import 'package:social_site_app/features/auth/data/repository/auth_repository_impl.dart';
import 'package:social_site_app/features/auth/presentation/bloc/user_bloc.dart';
import 'package:social_site_app/features/create_meet/presentation/bloc/create_meet_bloc.dart';
import 'package:social_site_app/features/create_meet/presentation/bloc/location_picker_bloc.dart';
import 'package:social_site_app/features/meet/domain/repository/meet_repository.dart';
import 'package:social_site_app/features/meet/presentation/bloc/meet_bloc.dart';
import 'package:social_site_app/features/profile/presentation/bloc/last_meets_bloc.dart';

import '../../features/auth/data/datasource/user_remote_datasource.dart';
import '../../features/auth/data/repository/user_repository_impl.dart';
import '../../features/auth/domain/repository/auth_repository.dart';
import '../../features/auth/domain/repository/user_repository.dart';
import '../../features/main/presentation/bloc/main_bloc.dart';
import '../../features/meet/data/datasource/meet_remote_datasource.dart';
import '../../features/meet/data/repository/meet_repository_impl.dart';

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


}
void registerRepositories(){
 getIt.registerSingleton<AuthRepository>(
     AuthRepositoryImpl(authRemoteDatasource: getIt(), googleSignIn: getIt()));
 getIt.registerSingleton<UserRepository>(
     UserRepositoryImpl(userRemoteDatasource: getIt()));
 getIt.registerSingleton<MeetRepository>(
     MeetRepositoryImpl(meetRemoteDatasource: getIt()));
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




}