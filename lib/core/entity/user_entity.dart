import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:social_site_app/core/entity/job_entity.dart';

part 'user_entity.g.dart';

@JsonSerializable()
class UserEntity extends Equatable {
  @JsonKey(name: '_id')
  final String id;
  final String email;
  final String name;
  final String avatar;
  final String? bio;
  final List<JobEntity>? jobs;

  UserEntity({
    required this.id,
    required this.email,
    required this.name,
    required this.avatar,
    this.bio,
    this.jobs
  });
  factory UserEntity.fromJson(Map<String, dynamic> json) => _$UserEntityFromJson(json);
  @override
  // TODO: implement props
  List<Object?> get props => [id, email, name, avatar, bio,jobs];
}
