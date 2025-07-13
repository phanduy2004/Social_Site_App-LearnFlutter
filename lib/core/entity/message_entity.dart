import 'dart:convert';

import 'package:json_annotation/json_annotation.dart';
import 'package:social_site_app/core/entity/user_entity.dart';

part 'message_entity.q.dart';
@JsonSerializable()
class MessageEntity{
  final String text;
  final DateTime createdAt;
  final UserEntity sender;

  MessageEntity({required this.text, required this.createdAt, required this.sender});

  factory MessageEntity.fromJson(Map<String, dynamic> json) =>
      _$MessageEntityFromJson(json);

  Map<String, dynamic> toJson() => _$MessageEntityToJson(this);
}