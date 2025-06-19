import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'user_entity.q.dart';

@JsonSerializable()
class UserEntity extends Equatable {
  @JsonKey(name: '_id')
  final String id;
  final String email;
  final String name;
  final String avatar;
  final String? bio;

  UserEntity({
    required this.id,
    required this.email,
    required this.name,
    required this.avatar,
    this.bio,
  });
  factory UserEntity.fromJson(Map<String, dynamic> json) => _$UserEntityFromJson(json);
  @override
  // TODO: implement props
  List<Object?> get props => [id, email, name, avatar, bio];
}
