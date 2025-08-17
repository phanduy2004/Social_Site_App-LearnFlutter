// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'job_entity.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

JobEntity _$JobEntityFromJson(Map<String, dynamic> json) => JobEntity(
  id: json['_id'] as String,
  job: JobTypeEntity.fromJson(json['job'] as Map<String, dynamic>),
  level: json['level'] as String,
  pointsPerHour: (json['pointsPerHour'] as num).toInt(),
  description: json['description'] as String,
  user: json['user'] as String,
);

Map<String, dynamic> _$JobEntityToJson(JobEntity instance) => <String, dynamic>{
  '_id': instance.id,
  'job': instance.job,
  'level': instance.level,
  'pointsPerHour': instance.pointsPerHour,
  'description': instance.description,
  'user': instance.user,
};
