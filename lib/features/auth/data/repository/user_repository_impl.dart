import 'dart:io';

import 'package:social_site_app/core/model/either.dart';

import 'package:social_site_app/core/model/failure.dart';
import 'package:social_site_app/features/auth/data/datasource/user_remote_datasource.dart';

import 'package:social_site_app/features/auth/domain/entity/user_entity.dart';

import '../../domain/repository/user_repository.dart';
import 'package:dio/dio.dart';

class UserRepositoryImpl implements UserRepository {
  final UserRemoteDatasource userRemoteDatasource;

  UserRepositoryImpl({required this.userRemoteDatasource});

  @override
  Future<Either<Failure, UserEntity>> getUser() async {
    try {
      return Right(await userRemoteDatasource.getUser());
    } on DioException catch (e) {
      return Left(UserFailure(message: e.response?.data['message']));
    } catch (e) {
      return Left(UserFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure,void>> editUser({required String name,  required String bio, File? avatar}) async {
    try{
      if(avatar != null){
        await userRemoteDatasource.uploadAvatar(avatar);
      }
      return Right((await userRemoteDatasource.editUser(name, bio)));
    }
    on DioException catch(e){
      return Left(AuthFailure(message: e.response?.data['message']));
    }
    catch(e){
      return Left(AuthFailure(message: e.toString()));
    }
  }

}