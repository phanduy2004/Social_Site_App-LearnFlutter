import 'package:dio/dio.dart';
import 'package:social_site_app/core/entity/user_entity.dart';

class AuthRemoteDatasource{
  final Dio dio;

  AuthRemoteDatasource({required this.dio});

  Future<UserEntity> signInWithGoogle(String token) async {
    final response = await dio.post('users/auth', data: {'token': token},options: Options(headers: {'Content-Type': 'application/json'}),);

    print('Response data: ${response.data}'); // Debug
    return UserEntity.fromJson(response.data);
  }

}