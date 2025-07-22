import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
part 'job_type_entity.g.dart';

@JsonSerializable()
class JobTypeEntity extends Equatable{
  @JsonKey(name: '_id')
  final String id;
  final String? key;
  final String name;
  final String description;
  final String? icon;

  JobTypeEntity({required this.id, this.key, required this.name, required this.description, required this.icon});

  factory JobTypeEntity.fromJson(Map<String,dynamic> json) => _$JobTypeEntityFromJson(json);

  @override
  // TODO: implement props
  List<Object?> get props => [id,key,name,description,icon];

}
