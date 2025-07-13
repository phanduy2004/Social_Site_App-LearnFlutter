// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_entity.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserEntity _$UserEntityFromJson(Map<String, dynamic> json) => UserEntity(
  id: json['_id'] as String,
  email: json['email'] as String,
  name: json['name'] as String,
  avatar: json['avatar'] as String,
  bio: json['bio'] as String?,
  jobs: (json['jobs'] as List<dynamic>?)
      ?.map((e) => JobEntity.fromJson(e as Map<String, dynamic>))
      .toList(),
);

Map<String, dynamic> _$UserEntityToJson(UserEntity instance) =>
    <String, dynamic>{
      '_id': instance.id,
      'email': instance.email,
      'name': instance.name,
      'avatar': instance.avatar,
      'bio': instance.bio,
      'jobs': instance.jobs,
    };
