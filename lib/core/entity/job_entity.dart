import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:social_site_app/core/entity/job_type_entity.dart';
import 'package:social_site_app/core/entity/user_entity.dart';
part 'job_entity.g.dart';

@JsonSerializable( )
class JobEntity extends Equatable{
  @JsonKey(name:  '_id')
  final String id;
  @JsonKey(name: 'job')
  final JobTypeEntity job;
  final String level;
  final int pointsPerHour;
  final String description;
  final String user;

  JobEntity({required this.id, required this.job, required this.level, required this.pointsPerHour, required this.description,required this.user});
  factory JobEntity.fromJson(Map<String,dynamic> json) => _$JobEntityFromJson(json);

  @override
  // TODO: implement props
  List<Object?> get props => [id,job,level,pointsPerHour,description,user];

}