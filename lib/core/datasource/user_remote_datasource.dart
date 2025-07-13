import 'dart:io';
import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:social_site_app/core/entity/job_entity.dart';
import 'package:social_site_app/core/entity/job_type_entity.dart';
import 'package:social_site_app/core/entity/user_entity.dart';

class UserRemoteDatasource {
  final Dio dio;

  UserRemoteDatasource({required this.dio});

  Future<UserEntity> getUser() async {
    var request = await dio.get('users/profile');
    return UserEntity.fromJson(request.data);
  }

  Future<void> editUser(String name, String bio, List<JobEntity> jobs) async {
    var request = await dio.put('users/profile',data: {
      'name' : name,
      'bio' : bio,
      'jobs': jobs.map((job) => job.job.id).toList(),
    });
    return;
  }
  Future uploadAvatar(File avatar) async {
    var request = await dio.put('users/avatar',data: FormData.fromMap({
      'avatar' : MultipartFile.fromFileSync(avatar.path)
    }));
  }
}