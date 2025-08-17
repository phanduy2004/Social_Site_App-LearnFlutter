// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'job_type_entity.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

JobTypeEntity _$JobTypeEntityFromJson(Map<String, dynamic> json) =>
    JobTypeEntity(
      id: json['_id'] as String,
      key: json['key'] as String?,
      name: json['name'] as String,
      description: json['description'] as String,
      icon: json['icon'] as String?,
    );

Map<String, dynamic> _$JobTypeEntityToJson(JobTypeEntity instance) =>
    <String, dynamic>{
      '_id': instance.id,
      'key': instance.key,
      'name': instance.name,
      'description': instance.description,
      'icon': instance.icon,
    };
