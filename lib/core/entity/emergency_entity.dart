import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:social_site_app/core/entity/job_type_entity.dart';
import 'package:social_site_app/core/entity/user_entity.dart';

part 'emergency_entity.g.dart';

enum Urgency { low, medium, high }
enum EmergencyStatus { pending, accepted, in_progress, resolved, cancelled }

@JsonSerializable()
class EmergencyEntity extends Equatable {
  @JsonKey(name: '_id')
  final String id;

  // Backend bắt buộc
  final String title;

  // Backend trả mảng service (đã populate)
  @JsonKey(defaultValue: <JobTypeEntity>[])
  final List<JobTypeEntity> service;

  final String? description;

  @JsonKey(unknownEnumValue: Urgency.medium)
  final Urgency urgency;

  final String contactPhone;

  @JsonKey(defaultValue: '')
  final String address;

  final double? latitude;
  final double? longitude;

  @JsonKey(unknownEnumValue: EmergencyStatus.pending)
  final EmergencyStatus status;

  @JsonKey(defaultValue: false)
  final bool shareLiveLocation;

  // Có thể null nếu chưa populate/ chưa ai nhận
  final UserEntity? createdBy;
  final UserEntity? assignedTo;

  final DateTime? scheduledAt;
  final DateTime? autoCloseAt;

  final bool? isDeleted;

  // Timestamps Mongo
  final DateTime? createdAt;
  final DateTime? updatedAt;

  const EmergencyEntity({
    required this.id,
    required this.title,
    required this.service,
    required this.description,
    required this.urgency,
    required this.contactPhone,
    required this.address,
    required this.latitude,
    required this.longitude,
    required this.status,
    required this.shareLiveLocation,
    required this.createdBy,
    required this.assignedTo,
    required this.scheduledAt,
    required this.autoCloseAt,
    required this.isDeleted,
    required this.createdAt,
    required this.updatedAt,
  });

  /// Fallback: nếu server không trả latitude/longitude phẳng,
  /// tự lấy từ location.coordinates: [lng, lat]

  factory EmergencyEntity.fromJson(Map<String,dynamic> json) => _$EmergencyEntityFromJson(json);


  @override
  List<Object?> get props => [
    id,
    title,
    service,
    description,
    urgency,
    contactPhone,
    address,
    latitude,
    longitude,
    status,
    shareLiveLocation,
    createdBy,
    assignedTo,
    scheduledAt,
    autoCloseAt,
    isDeleted,
    createdAt,
    updatedAt,
  ];
}
