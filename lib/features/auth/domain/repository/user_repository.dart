import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:social_site_app/core/model/failure.dart';
import 'package:social_site_app/features/auth/domain/entity/user_entity.dart';

import '../../../../core/model/either.dart';

abstract class UserRepository{
  Future<Either<Failure,UserEntity>> getUser();
  Future<Either<Failure, void>> editUser(
      {required String name,required String bio, File? avatar});
}
