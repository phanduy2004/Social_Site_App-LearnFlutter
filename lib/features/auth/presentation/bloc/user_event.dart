import 'dart:io';

import 'package:social_site_app/core/entity/job_entity.dart';

abstract class UserEvent{

}
class SignInWithGoogleEvent extends UserEvent{
  
}
class GetUserEvent extends UserEvent{

}
class SignOutEvent extends UserEvent{

}
class EditProfileEvent extends UserEvent{
  final String name;
  final String bio;
  final File? avatar;
  final List<JobEntity>? jobs;

  EditProfileEvent({required this.name, required this.bio, required this.avatar,required  this.jobs});

}