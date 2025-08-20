// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'emergency_entity.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

EmergencyEntity _$EmergencyEntityFromJson(Map<String, dynamic> json) =>
    EmergencyEntity(
      id: json['_id'] as String,
      title: json['title'] as String,
      service:
          (json['service'] as List<dynamic>?)
              ?.map((e) => JobTypeEntity.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      description: json['description'] as String?,
      urgency: $enumDecode(
        _$UrgencyEnumMap,
        json['urgency'],
        unknownValue: Urgency.medium,
      ),
      contactPhone: json['contactPhone'] as String,
      address: json['address'] as String? ?? '',
      latitude: (json['latitude'] as num?)?.toDouble(),
      longitude: (json['longitude'] as num?)?.toDouble(),
      status: $enumDecode(
        _$EmergencyStatusEnumMap,
        json['status'],
        unknownValue: EmergencyStatus.pending,
      ),
      shareLiveLocation: json['shareLiveLocation'] as bool? ?? false,
      createdBy: json['createdBy'] == null
          ? null
          : UserEntity.fromJson(json['createdBy'] as Map<String, dynamic>),
      assignedTo: json['assignedTo'] == null
          ? null
          : UserEntity.fromJson(json['assignedTo'] as Map<String, dynamic>),
      scheduledAt: json['scheduledAt'] == null
          ? null
          : DateTime.parse(json['scheduledAt'] as String),
      autoCloseAt: json['autoCloseAt'] == null
          ? null
          : DateTime.parse(json['autoCloseAt'] as String),
      isDeleted: json['isDeleted'] as bool?,
      createdAt: json['createdAt'] == null
          ? null
          : DateTime.parse(json['createdAt'] as String),
      updatedAt: json['updatedAt'] == null
          ? null
          : DateTime.parse(json['updatedAt'] as String),
    );

Map<String, dynamic> _$EmergencyEntityToJson(EmergencyEntity instance) =>
    <String, dynamic>{
      '_id': instance.id,
      'title': instance.title,
      'service': instance.service,
      'description': instance.description,
      'urgency': _$UrgencyEnumMap[instance.urgency]!,
      'contactPhone': instance.contactPhone,
      'address': instance.address,
      'latitude': instance.latitude,
      'longitude': instance.longitude,
      'status': _$EmergencyStatusEnumMap[instance.status]!,
      'shareLiveLocation': instance.shareLiveLocation,
      'createdBy': instance.createdBy,
      'assignedTo': instance.assignedTo,
      'scheduledAt': instance.scheduledAt?.toIso8601String(),
      'autoCloseAt': instance.autoCloseAt?.toIso8601String(),
      'isDeleted': instance.isDeleted,
      'createdAt': instance.createdAt?.toIso8601String(),
      'updatedAt': instance.updatedAt?.toIso8601String(),
    };

const _$UrgencyEnumMap = {
  Urgency.low: 'low',
  Urgency.medium: 'medium',
  Urgency.high: 'high',
};

const _$EmergencyStatusEnumMap = {
  EmergencyStatus.pending: 'pending',
  EmergencyStatus.accepted: 'accepted',
  EmergencyStatus.in_progress: 'in_progress',
  EmergencyStatus.resolved: 'resolved',
  EmergencyStatus.cancelled: 'cancelled',
};
