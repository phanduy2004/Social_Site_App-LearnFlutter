import 'package:social_site_app/core/model/either.dart';
import 'package:social_site_app/core/model/failure.dart';
import 'package:social_site_app/features/auth/domain/entity/user_entity.dart';

abstract class AuthRepository{
  Future<Either<Failure,UserEntity>> signInWithGoogle();
  Future<Either<Failure,void>> logOut();
}