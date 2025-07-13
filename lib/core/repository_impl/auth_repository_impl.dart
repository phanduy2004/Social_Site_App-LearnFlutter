import 'package:social_site_app/core/model/either.dart';
import 'package:social_site_app/core/model/failure.dart';
import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:social_site_app/core/datasource/auth_remote_datasource.dart';
import 'package:social_site_app/core/entity/user_entity.dart';
import 'package:social_site_app/core/repository/auth_repository.dart';
import 'package:google_sign_in/google_sign_in.dart';
class AuthRepositoryImpl implements AuthRepository{
  final AuthRemoteDatasource authRemoteDatasource;

  final GoogleSignIn googleSignIn;

  AuthRepositoryImpl({required this.authRemoteDatasource, required this.googleSignIn});

  @override
  Future<Either<Failure, UserEntity>> signInWithGoogle() async {
    try{
      final GoogleSignInAccount? googleUser = await googleSignIn.signIn();
      final GoogleSignInAuthentication? googleAuth = await googleUser?.authentication;

      final credential = GoogleAuthProvider.credential(accessToken: googleAuth?.accessToken,idToken: googleAuth?.idToken);

      final firebaseCredentials = await FirebaseAuth.instance.signInWithCredential(credential);

      final token = await firebaseCredentials.user?.getIdToken();

      if(token!=null){
        return Right(await authRemoteDatasource.signInWithGoogle(token));
      }
      else{
        return Left(AuthFailure(message: 'Auth Failure'));
      }
    }
    on DioException catch (e){
      return Left(AuthFailure(message: e.response?.data['message']));
    }
    catch (e){
      return Left(AuthFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> logOut() async {
    try{
      final GoogleSignIn googleSignIn = GoogleSignIn();
      await googleSignIn.signOut();
      await googleSignIn.disconnect(); // Ngắt kết nối hoàn toàn
      await FirebaseAuth.instance.signOut();

      return Right(null);
    }
    catch(e){
      return Left(AuthFailure(message: e.toString()));
    }
  }

}