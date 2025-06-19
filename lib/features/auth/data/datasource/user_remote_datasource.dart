import 'dart:io';

import 'package:social_site_app/features/auth/domain/entity/user_entity.dart';
import 'package:dio/dio.dart';
class UserRemoteDatasource{
  final Dio dio;

  UserRemoteDatasource({required this.dio});

  Future<UserEntity> getUser() async{
    var request = await dio.get('users/profile');
    return UserEntity.fromJson(request.data);
  }
  Future editUser(String name, String bio) async{
    var request = await dio.put('users/profile', data: {
      'name': name,
      'bio' : bio
    });
    return;
  }
  Future uploadAvatar(File avatar) async{
    var request = await dio.put('users/profile', data: FormData.fromMap({
      'avatar': MultipartFile.fromFileSync(avatar.path)
    }));
  }
}