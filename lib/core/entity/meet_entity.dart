import 'package:json_annotation/json_annotation.dart';
import 'package:equatable/equatable.dart';
import 'package:social_site_app/core/entity/job_type_entity.dart';
import 'package:social_site_app/core/entity/user_entity.dart';
part 'meet_entity.g.dart';



@JsonSerializable()
class MeetEntity extends Equatable{
  @JsonKey(name: '_id')
  final String id;
  final String? title;
  final String? description;
  final DateTime date;
  final List<UserEntity> attendees;
  final UserEntity admin;
  final bool isFinished;
  final bool isCancelled;
  final double? latitude;
  final double? longitude;
  final List<JobTypeEntity>? service;

  MeetEntity(
      {required this.id,
        this.title,
        this.description,
        required this.date,
        required this.attendees,
        required this.admin,
        required this.isFinished,
        required this.isCancelled,
        this.latitude,
        this.longitude,
        this.service
      });

  @override
  List<Object?> get props => [id,title,description,date,attendees,admin,isFinished,isCancelled,latitude,longitude,service];

  factory MeetEntity.fromJson(Map<String, dynamic> json) {
    print('JSON: $json');
    return _$MeetEntityFromJson(json);
  }}
