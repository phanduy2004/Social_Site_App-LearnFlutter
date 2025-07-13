import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:social_site_app/core/entity/job_entity.dart';
import 'package:social_site_app/core/entity/job_type_entity.dart';
import 'package:social_site_app/core/model/failure.dart';
import 'package:social_site_app/core/entity/user_entity.dart';

import '../model/either.dart';

abstract class UserRepository{
  Future<Either<Failure,UserEntity>> getUser();
  Future<Either<Failure, void>> editUser(
      {required String name,required String bio, File? avatar, required List<JobEntity>? jobs});
}
